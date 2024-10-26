//
//  CDDAPMNetworkRequestModel.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/15.
//

#import "CDDAPMNetworkRequestModel.h"
#import "CDDAPMNetworkRequestPlugin.h"

@implementation CDDAPMNetworkRequestModel
@synthesize tag;

@synthesize dataType;

- (CDDAPMPIssueDataType)dataType
{
    return CDDAPMPIssueDataType_Data;
}

- (NSString*)tag
{
    return (NSString*)CDDAPMNetworkRequestPluginTag;
}

- (NSDictionary * _Nonnull)jsonData { 
    return @{@"tag":CDDAPMNetworkRequestPluginTag,
             @"url":self.url,
             @"duration":@(self.duration)};
}

@end
