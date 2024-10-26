//
//  CDDAPM.h
//  CDDAPM
//
//  Created by flashgeek on 2024/10/11.
//

#import <Foundation/Foundation.h>
#import "CDDAPMTypes.h"
#import "CDDAPMCoreTypes.h"
#import "CDDAPMLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDDAPM : NSObject
+ (id)sharedInstance;
- (void)startPlugins:(NSUInteger)plugin;
- (void)stopPlugins;
- (void)appDidLaunch;
+ (id<CDDAPMPluginProtocol>)getPluginInstanceWithTag:(NSString*)tag;
@end

NS_ASSUME_NONNULL_END
