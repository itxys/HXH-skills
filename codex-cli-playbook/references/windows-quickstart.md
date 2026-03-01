# Windows quickstart (official-aligned)

## Recommended path: WSL
```powershell
wsl --install
wsl
```

Inside WSL:
```bash
npm i -g @openai/codex
codex --version
codex
```

## Keep repo in Linux filesystem
```bash
mkdir -p ~/code && cd ~/code
git clone <repo-url>
cd <repo>
codex
```

Avoid heavy work under `/mnt/c/...` when possible.

## Native Windows quick check
```powershell
npm i -g @openai/codex
codex --version
codex
```

## Common diagnostics
```powershell
where.exe codex
node -v
npm -v
nslookup developers.openai.com
Test-NetConnection developers.openai.com -Port 443
curl.exe -I https://developers.openai.com/codex/ --max-time 20
```
