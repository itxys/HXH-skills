# Gate Matrix（按域）

## Runtime / Event Center
- `npm run test:gate:runtime-adapter-routing`
- `npm run test:gate:runtime-event-center`
- `npm run test:gate:runtime-event-timeline`
- `npm run test:gate:runtime-event-pagination`
- `npm run test:gate:runtime-event-cache`

## Memory
- `npm run test:gate:memory-context-mvp`
- `npm run test:gate:memory-quality`
- `npm run test:gate:memory-layering`
- `npm run test:gate:memory-recall-policy`
- `npm run test:gate:memory-observability`

## Scheduler
- `npm run test:gate:scheduler-autonomy`

## Web-IM / Social
- `npm run test:gate:platform-social-p0`
- `npm run test:gate:platform-social-p1`
- `npm run test:gate:platform-social-p2`
- `npm run test:gate:platform-social-p3`

## OpenClaw 能力借鉴对齐
- `npm run test:gate:openclaw-parity-matrix`
- `npm run test:gate:sidecar-surface`
- `npm run test:gate:sidecar-failure-modes`

## 发布前最小组合
```bash
npm run platform:gate
npm run test:gate:resilience-e2e
npm run release:451x:readiness
npx tsc -p tsconfig.json --noEmit
```
