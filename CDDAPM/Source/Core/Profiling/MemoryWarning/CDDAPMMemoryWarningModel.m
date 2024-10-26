//
//  CDDAPMMemoryWarningModel.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/15.
//
#import "CDDAPMMemoryWarningPlugin.h"
#import "CDDAPMMemoryWarningModel.h"

@implementation CDDAPMMemoryWarningModel

@synthesize tag;

@synthesize dataType;

- (CDDAPMPIssueDataType)dataType
{
    return CDDAPMPIssueDataType_Data;
}

- (NSString*)tag
{
    return (NSString*)CDDAPMMemoryWarningPluginTag;
}

- (NSDictionary * _Nonnull)jsonData { 
    return @{@"tag":CDDAPMMemoryWarningPluginTag};
}

@end
