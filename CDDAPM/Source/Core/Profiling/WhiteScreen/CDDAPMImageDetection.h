//
//  CDDAPMImageDetection.h
//  CDDAPM
//
//  Created by flashgeek on 2024/10/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CDDAPMImageDetectionCompletion)(BOOL, NSError*_Nullable) ;

NS_ASSUME_NONNULL_BEGIN

@interface CDDAPMImageDetection : NSObject
+ (void)haveWhiteScreen:(UIImage * _Nullable)snapshotImage
             completion:(CDDAPMImageDetectionCompletion)completion;
@end

NS_ASSUME_NONNULL_END
