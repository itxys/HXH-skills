$ErrorActionPreference = 'Stop'
Write-Host '[tuanbot-dev-playbook] quick validate start'

$repo = 'D:\AI_PJ\ai-robots'
Push-Location $repo

$cmds = @(
  'npm run test:gate:runtime-adapter-routing',
  'npm run test:gate:memory-layering',
  'npm run test:gate:scheduler-autonomy',
  'npm run test:gate:platform-social-p3',
  'npm run release:451x:readiness'
)

foreach ($c in $cmds) {
  Write-Host ">>> $c"
  cmd /c $c
  if ($LASTEXITCODE -ne 0) { throw "FAILED: $c" }
}

Pop-Location
Write-Host '[tuanbot-dev-playbook] quick validate PASS'
