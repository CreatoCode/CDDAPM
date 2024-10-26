//
//  CDDAPMFreezesModel.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/15.
//

#import "CDDAPMFreezesPlugin.h"
#import "CDDAPMFreezesModel.h"

@implementation CDDAPMFreezesModel
@dynamic tag;
@dynamic dataType;

- (CDDAPMPIssueDataType)dataType
{
    return CDDAPMPIssueDataType_Data;
}

- (NSString*)tag
{
    return (NSString*)CDDAPMFreezesPluginTag;
}

- (NSDictionary * _Nonnull)jsonData { 
    return @{@"tag":CDDAPMFreezesPluginTag};
}
@end
