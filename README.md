# KD AdBlock Universal V1 (experimental)

An iOS dynamic library source project for **authorized** IPA modifications. No UI, no activation switch. Attempts to suppress selected full-screen ad presentation calls.

## Build
Requires macOS or compatible build environment with Theos and iOS SDK. Run `make package` or `make` in the project folder. Locate the built `KDAdBlock.dylib` under `.theos/obj/` (path varies by Theos version).

## Limits
- Experimental source, not tested in NumberBook or any iPhone.
- Hooks only known selectors when their classes are already loaded at library initialization. Later-loaded classes won't be hooked.
- Does not block banners, custom popups, embedded promotions, video ads, network calls, or all SDK versions.
- Some apps use different class names/selectors, integrity checks, or code-signing requirements.
- Rewarded ads are intentionally excluded; interfering with reward flows can break app functionality.
- Use only with software you own or are authorized to modify. Observe applicable app terms and distribution rights.

## Injection
Injecting/signing is separate from this project. A compatible app must load the library. Keep a backup of the original IPA. If the app crashes or functions fail, remove the library.
