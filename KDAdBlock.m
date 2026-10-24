#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

// KD AdBlock V1: opt-in compatibility hooks for known full-screen ad presenters.
// This does not hook general UIKit presentation, avoiding disruption of login/search.
static void KDNoOp(id self, SEL _cmd) { (void)self; (void)_cmd; }
static void KDNoOpWithController(id self, SEL _cmd, id controller) { (void)self; (void)_cmd; (void)controller; }

typedef struct { const char *className; const char *selectorName; BOOL takesController; } KDHook;
static const KDHook hooks[] = {
    {"GADInterstitialAd", "presentFromRootViewController:", YES},
    {"GADAppOpenAd", "presentFromRootViewController:", YES},
    {"GADRewardedInterstitialAd", "presentFromRootViewController:", YES},
    {"MAInterstitialAd", "showAd", NO},
    {"ISInterstitialAd", "show", NO},
};

static void KDInstallHooks(void) {
    for (size_t i = 0; i < sizeof(hooks)/sizeof(hooks[0]); i++) {
        Class cls = objc_getClass(hooks[i].className);
        if (!cls) continue;
        SEL sel = sel_registerName(hooks[i].selectorName);
        Method method = class_getInstanceMethod(cls, sel);
        if (!method) continue;
        unsigned int expected = hooks[i].takesController ? 3 : 2;
        if (method_getNumberOfArguments(method) != expected) continue;
        IMP replacement = hooks[i].takesController ? (IMP)KDNoOpWithController : (IMP)KDNoOp;
        method_setImplementation(method, replacement);
    }
}

__attribute__((constructor)) static void KDStart(void) {
    @autoreleasepool {
        // Some SDK classes load later. This V1 only hooks classes present at startup.
        KDInstallHooks();
    }
}
