# KD AdBlock V2 — diagnostic build

This is a **diagnostic-only** build. It logs `[KDAdBlock V2] constructor invoked` when loaded and lists detected advertising SDK image names. It does **not** block ads or modify SDK methods. Use only in apps you own or have permission to test.

## Build
Upload `KDAdBlock.m`, `Makefile`, and `.github/workflows/build.yml` to the repository root (workflow in its nested path). GitHub Actions > Build KD AdBlock V2 > Run workflow. Download the artifact after a successful build. Building has not been verified here.

## Check
Observe the app's device console for `[KDAdBlock V2]`. If the log is missing, verify dynamic loader linkage and signing. If present, compare detected SDK names against known embedded frameworks. Logging may repeat because each newly loaded image triggers a scan.

**Limits:** Detection uses image names and selected Objective-C classes; static or renamed SDKs may not be detected. A successful build or presence in an IPA does not prove runtime loading. Do not assume universal ad blocking.
