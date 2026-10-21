// @vitest-environment node
import { spawnSync } from 'node:child_process'
import { readFileSync } from 'node:fs'
import { describe, expect, it } from 'vitest'

const workflow = readFileSync(
  new URL('../../../.github/workflows/test-azure-oidc.yml', import.meta.url),
  'utf8',
)
const steps = workflow.split('      - name: ')
const preflight = steps.find(step => step.startsWith('Check Azure environment variables'))!
const login = steps.find(step => step.startsWith('Login to Azure'))!
const resourceGroup = steps.find(step => step.startsWith('Verify DEV resource group'))!
const script = preflight.split('        run: |\n')[1]!.replace(/^ {10}/gm, '')
const configured = {
  CLIENT_ID: 'test-client',
  TENANT_ID: 'test-tenant',
  SUBSCRIPTION_ID: 'test-subscription',
  RESOURCE_GROUP: 'test-resource-group',
}

describe('Azure DEV OIDC workflow', () => {
  it('uses the DEV environment and permits OIDC token requests', () => {
    expect(workflow).toContain('    environment: dev')
    expect(workflow).toContain('  id-token: write')
  })

  it.each([
    ['CLIENT_ID', 'client-id'],
    ['TENANT_ID', 'tenant-id'],
    ['SUBSCRIPTION_ID', 'subscription-id'],
  ])('resolves %s from secrets or variables consistently for validation and login', (name, input) => {
    const expression = `\${{ secrets.AZURE_${name} || vars.AZURE_${name} }}`
    expect(preflight).toContain(`${name}: ${expression}`)
    expect(login).toContain(`${input}: ${expression}`)
  })

  it('accepts the resource group as a variable or secret in both steps', () => {
    const expression = '${{ vars.AZURE_RESOURCE_GROUP || secrets.AZURE_RESOURCE_GROUP }}'
    expect(preflight).toContain(`RESOURCE_GROUP: ${expression}`)
    expect(resourceGroup).toContain(`DEV_RG: ${expression}`)
    expect(resourceGroup).toContain('--name "$DEV_RG"')
  })

  it('passes preflight without a location and does not print configuration values', () => {
    expect(workflow).not.toContain('AZURE_LOCATION')
    const result = spawnSync('bash', ['--noprofile', '--norc', '-e', '-o', 'pipefail', '-c', script], {
      env: configured,
      encoding: 'utf8',
    })
    expect(result.status, result.stderr).toBe(0)
    for (const [name, value] of Object.entries(configured)) {
      expect(result.stdout).toContain(`${name} is configured`)
      expect(result.stdout).not.toContain(value)
    }
  })

  it.each(Object.keys(configured))('fails preflight when %s is missing', (name) => {
    const result = spawnSync('bash', ['--noprofile', '--norc', '-e', '-o', 'pipefail', '-c', script], {
      env: { ...configured, [name]: '' },
      encoding: 'utf8',
    })
    expect(result.status, result.stderr).toBe(1)
    expect(result.stdout).toContain(`::error::${name} is missing or empty`)
  })
})
