//
//  CDDAPMFrameRateModel.h
//  CDDAPM
//
//  Created by flashgeek on 2024/10/15.
//

#import <Foundation/Foundation.h>
#import "CDDAPMCoreTypes.h"

typedef NS_ENUM(NSInteger, CDDAPMFrameRateLevel) {
    CDDAPMFrameRateLevelNormal = 0,
    CDDAPMFrameRateLevelMild,
    CDDAPMFrameRateLevelModerate,
    CDDAPMFrameRateLevelSevere
};

NS_ASSUME_NONNULL_BEGIN

@interface CDDAPMFrameRateModel : NSObject<CDDAPMPIssueModelProtocol>
@property (nonatomic, assign) CGFloat FPS;
@property (nonatomic, assign) CDDAPMFrameRateLevel level;
@end

NS_ASSUME_NONNULL_END
