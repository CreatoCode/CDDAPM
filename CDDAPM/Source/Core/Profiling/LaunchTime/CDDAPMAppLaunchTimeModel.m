//
//  CDDAPMAppLaunchTimeModel.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/15.
//

#import "CDDAPMAppLaunchTimeModel.h"
#import "CDDAPMAppLaunchTimePlugin.h"

@implementation CDDAPMAppLaunchTimeModel
@synthesize tag;

@synthesize dataType;

- (CDDAPMPIssueDataType)dataType
{
    return CDDAPMPIssueDataType_Data;
}

- (NSString*)tag
{
    return (NSString*)CDDAPMAppLaunchTimePluginTag;
}

- (NSTimeInterval)duration
{
    return self.firstFrameRenderTime - [[NSDate dateWithTimeIntervalSince1970:self.processStartTime] timeIntervalSinceReferenceDate];
}

- (NSDictionary * _Nonnull)jsonData { 
    return @{@"tag":CDDAPMAppLaunchTimePluginTag,
             @"duration":@(self.duration)};
}
@end
