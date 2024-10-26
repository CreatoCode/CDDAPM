//
//  CDDAPM.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/11.
//

#import "CDDAPM.h"
#import "CDDAPMCoreTypes.h"
#import "CDDAPMAppLaunchTimePlugin.h"
#import "CDDAPMFreezesPlugin.h"
#import "CDDAPMFrameRatePlugin.h"
#import "CDDAPMZobimePlugin.h"
#import "CDDAPMWhiteScreenPlugin.h"
#import "CDDAPMPageTracker.h"
#import "CDDAPMNetworkRequestPlugin.h"

@interface CDDAPM()<CDDAPMPluginReportProtocol>
@property(strong) NSMutableSet<id<CDDAPMPluginProtocol>>*plugins;
@property(nonatomic, strong) NSDictionary<NSNumber*,Class>*enumMapPluginsClass;
@end

@implementation CDDAPM
+ (instancetype)sharedInstance
{
    static CDDAPM* apm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apm = [[self alloc] init];
        apm.plugins = [[NSMutableSet alloc] init];
    });
    return apm;
}

- (NSDictionary<NSNumber*,Class>*)enumMapPluginsClass
{
    if (!_enumMapPluginsClass) {
        _enumMapPluginsClass = @{
            @(CDDAPMProfilingAppLaunchTime): [CDDAPMAppLaunchTimePlugin class],
            @(CDDAPMProfilingFreezes): [CDDAPMFreezesPlugin class],
            @(CDDAPMProfilingFrameRate): [CDDAPMFrameRatePlugin class],
            @(CDDAPMProfilingZobime): [CDDAPMZobimePlugin class],
            @(CDDAPMProfilingWhiteScreen): [CDDAPMWhiteScreenPlugin class],
            @(CDDAPMProfilingNetworkRequestTime): [CDDAPMNetworkRequestPlugin class],
        };
    }
    return _enumMapPluginsClass;
}

- (void)startPlugins:(NSUInteger)plugin
{
    [[CDDAPMPageTracker sharedInstance] startTracking];
    for (NSNumber *key in self.enumMapPluginsClass) {
        if (plugin & key.integerValue) {
            id<CDDAPMPluginProtocol> plugin = [[self.enumMapPluginsClass[key] alloc] init];
            plugin.reportDelegate = self;
            [plugin start];
            [self.plugins addObject:plugin];
        }
    }
}
- (void)stopPlugins
{
    for (id<CDDAPMPluginProtocol> plugin in self.plugins) {
        [plugin stop];
        [self.plugins removeObject:plugin];
    }
}



- (void)reportIssue:(id<CDDAPMPIssueModelProtocol>_Nullable)issue
{
    CDDAPMLogDebug(@"[CDDAPM report] pages:%@", [[CDDAPMPageTracker sharedInstance] recentPages]);
    CDDAPMLogDebug(@"[CDDAPM report] issue:%@", issue);
}

- (void)reportWithDict:(NSDictionary*_Nonnull)dict
{
    CDDAPMLogDebug(@"[CDDAPM report] pages:%@", [[CDDAPMPageTracker sharedInstance] recentPages]);
    CDDAPMLogDebug(@"[CDDAPM report] dict:%@", dict);
}

- (void)appDidLaunch
{
    double time = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970;
    CDDAPMLogDebug(@"----------FinishLaunch---------: %f",time);
}

+ (id<CDDAPMPluginProtocol>)getPluginInstanceWithTag:(NSString*)tag
{
    for (id<CDDAPMPluginProtocol> plugin in [[self sharedInstance] plugins]) {
        if ([[[plugin class] getTag] isEqualToString:tag]) {
            return plugin;
        }
    };
    return nil;
}
@end
