#import "CDDAPMPageTracker.h"
#import <objc/runtime.h>
#import "CDDAPMRuntime.h"

@interface UIViewController (CDDAPMPageTracker)
- (void)cddViewDidAppear:(BOOL)animated;
@end

@interface CDDAPMPageTracker()
@property (nonatomic, strong) NSMutableArray<NSString *> *pageHistory;
@end

@implementation CDDAPMPageTracker

+ (instancetype)sharedInstance {
    static CDDAPMPageTracker *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageHistory = [NSMutableArray array];
    }
    return self;
}

- (void)startTracking {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cddapm_exchangeMethod([UIViewController class], @selector(viewDidAppear:), [UIViewController class], @selector(cddViewDidAppear:));
    });
}

- (void)addPageToHistory:(NSString *)pageName {
    @synchronized (self) {
        [self.pageHistory addObject:pageName];
        if (self.pageHistory.count > 10) {
            [self.pageHistory removeObjectAtIndex:0];
        }
    }
}

- (NSArray<NSString *> *)recentPages {
    @synchronized (self) {
        return [self.pageHistory copy];
    }
}

@end

@implementation UIViewController (CDDAPMPageTracker)
- (void)cddViewDidAppear:(BOOL)animated
{
    [self cddViewDidAppear:animated];
    NSString *className = NSStringFromClass([self class]);
    [[CDDAPMPageTracker sharedInstance] addPageToHistory:className];
}
@end
