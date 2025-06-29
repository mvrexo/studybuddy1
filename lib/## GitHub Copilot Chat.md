## GitHub Copilot Chat

- Extension Version: 0.27.2 (prod)
- VS Code: vscode/1.100.2
- OS: Windows

## Network

User Settings:
```json
  "github.copilot.advanced.debug.useElectronFetcher": true,
  "github.copilot.advanced.debug.useNodeFetcher": false,
  "github.copilot.advanced.debug.useNodeFetchFetcher": true
```

Connecting to https://api.github.com:
- DNS ipv4 Lookup: 20.205.243.168 (100 ms)
- DNS ipv6 Lookup: Error (61 ms): getaddrinfo ENOTFOUND api.github.com
- Proxy URL: None (37 ms)
- Electron fetch (configured): HTTP 200 (1546 ms)
- Node.js https: HTTP 200 (3815 ms)
- Node.js fetch: HTTP 200 (672 ms)
- Helix fetch: HTTP 200 (911 ms)

Connecting to https://api.individual.githubcopilot.com/_ping:
- DNS ipv4 Lookup: 140.82.114.21 (40 ms)
- DNS ipv6 Lookup: Error (43 ms): getaddrinfo ENOTFOUND api.individual.githubcopilot.com
- Proxy URL: None (2 ms)
- Electron fetch (configured): timed out after 10 seconds
- Node.js https: timed out after 10 seconds
- Node.js fetch: HTTP 200 (8485 ms)
- Helix fetch: HTTP 200 (1349 ms)

## Documentation

In corporate networks: [Troubleshooting firewall settings for GitHub Copilot](https://docs.github.com/en/copilot/troubleshooting-github-copilot/troubleshooting-firewall-settings-for-github-copilot).