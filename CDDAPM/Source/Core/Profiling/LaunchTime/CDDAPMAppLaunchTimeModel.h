//
//  CDDAPMAppLaunchTimeModel.h
//  CDDAPM
//
//  Created by flashgeek on 2024/10/15.
//

#import <Foundation/Foundation.h>
#import "CDDAPMCoreTypes.h"
#import "CDDAPMAppLaunchTimePlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDDAPMAppLaunchTimeModel : NSObject<CDDAPMPIssueModelProtocol>
@property (nonatomic, assign) CFAbsoluteTime processStartTime;
//@property (nonatomic, assign) CFAbsoluteTime mainRunLoopBeforeTimersTime;
//@property (nonatomic, assign) CFAbsoluteTime appDidFinishLaunchingTime;
@property (nonatomic, assign) CFAbsoluteTime firstFrameRenderTime;
@property (nonatomic, assign) NSTimeInterval duration;
@end

NS_ASSUME_NONNULL_END
