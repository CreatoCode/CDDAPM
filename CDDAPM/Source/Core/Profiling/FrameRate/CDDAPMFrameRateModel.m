//
//  CDDAPMFrameRateModel.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/15.
//

#import "CDDAPMFrameRateModel.h"
#import "CDDAPMFrameRatePlugin.h"

@implementation CDDAPMFrameRateModel
@synthesize tag;

@synthesize dataType;

- (CDDAPMPIssueDataType)dataType
{
    return CDDAPMPIssueDataType_Data;
}

- (NSString*)tag
{
    return (NSString*)CDDAPMFrameRatePluginTag;
}

- (NSDictionary * _Nonnull)jsonData { 
    return @{@"tag":CDDAPMFrameRatePluginTag,
     @"fps":@(self.FPS), 
     @"level":@(self.level)};
}
@end
