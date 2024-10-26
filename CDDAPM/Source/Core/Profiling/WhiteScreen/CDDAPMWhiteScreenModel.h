//
//  CDDAPMWhiteScreenModel.h
//  CDDAPM
//
//  Created by flashgeek on 2024/10/15.
//

#import <Foundation/Foundation.h>
#import "CDDAPMCoreTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDDAPMWhiteScreenModel : NSObject<CDDAPMPIssueModelProtocol>
@property (nonatomic, copy, nonnull) NSString *viewController;
@property (nonatomic, copy, nullable) NSString *url; // for webview
// @property (nonatomic, assign) NSTimeInterval duration;
@end

NS_ASSUME_NONNULL_END
