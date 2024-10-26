#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CDDAPMPageTracker : NSObject

+ (instancetype)sharedInstance;
- (void)startTracking;
- (NSArray<NSString *> *)recentPages;

@end
