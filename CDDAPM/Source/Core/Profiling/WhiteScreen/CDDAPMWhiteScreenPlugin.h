//
//  CDDAPMWhiteScreen.h
//  CDDAPM
//
//  Created by flashgeek on 2024/10/13.
//

#import <Foundation/Foundation.h>
#import "CDDAPMCoreTypes.h"
#import "CDDAPMTypes.h"

FOUNDATION_EXTERN CDDConstString CDDAPMWhiteScreenPluginTag;

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, CDDAPMWhiteScreenScene) {
    CDDAPMWhiteScreenSceneWebView = 0x01,
    CDDAPMWhiteScreenSceneView = CDDAPMWhiteScreenSceneWebView << 1,
};

@interface CDDAPMWhiteScreenPlugin : NSObject<CDDAPMPluginProtocol>

@end

NS_ASSUME_NONNULL_END
