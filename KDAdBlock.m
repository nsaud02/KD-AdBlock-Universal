#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <dispatch/dispatch.h>
#import <objc/runtime.h>
#include <string.h>

// Diagnostic-only V2: detects known advertising SDKs, never changes app behavior.
static const char * const markers[] = {
    "FBAudienceNetwork", "InMobiSDK", "GoogleMobileAds", "AppLovinSDK",
    "IronSource", "UnityAds", "Vungle", "Pangle", "Mintegral", "DTExchange"
};

static void KDScan(void) {
    @autoreleasepool {
        NSMutableSet<NSString *> *found = [NSMutableSet set];
        uint32_t count = _dyld_image_count();
        for (uint32_t i = 0; i < count; i++) {
            const char *path = _dyld_get_image_name(i);
            if (!path) continue;
            for (size_t j = 0; j < sizeof(markers)/sizeof(markers[0]); j++) {
                if (strstr(path, markers[j])) [found addObject:@(markers[j])];
            }
        }
        // Classes may be linked into the executable rather than separate images.
        if (objc_getClass("GADInterstitialAd") || objc_getClass("GADBannerView"))
            [found addObject:@"GoogleMobileAds (class)"];
        if (objc_getClass("MAInterstitialAd")) [found addObject:@"AppLovin (class)"];
        NSLog(@"[KDAdBlock V2] loaded=YES; detected=%@", [[found allObjects] sortedArrayUsingSelector:@selector(compare:)]);
    }
}

static void KDImageAdded(const struct mach_header *header, intptr_t slide) {
    (void)header; (void)slide;
    // dyld callbacks may run under loader locks: defer runtime inspection.
    dispatch_async(dispatch_get_main_queue(), ^{ KDScan(); });
}

__attribute__((constructor)) static void KDStart(void) {
    NSLog(@"[KDAdBlock V2] constructor invoked");
    _dyld_register_func_for_add_image(KDImageAdded);
    dispatch_async(dispatch_get_main_queue(), ^{ KDScan(); });
}
