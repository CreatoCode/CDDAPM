//
//  CDDAPMWhiteScreenModel.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/15.
//

#import "CDDAPMWhiteScreenModel.h"
#import "CDDAPMWhiteScreenPlugin.h"

@implementation CDDAPMWhiteScreenModel
@dynamic tag;
@dynamic dataType;

- (CDDAPMPIssueDataType)dataType
{
    return CDDAPMPIssueDataType_Data;
}

- (NSString*)tag
{
    return (NSString*)CDDAPMWhiteScreenPluginTag;
}

- (NSDictionary * _Nonnull)jsonData { 
    return @{@"tag":CDDAPMWhiteScreenPluginTag,
             @"viewController":self.viewController,
            //  @"duration":@(self.duration),
             @"url":self.url.length ? self.url:@""};
}
@end
