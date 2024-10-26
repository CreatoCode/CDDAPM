//
//  CDDAPMImageDetection.m
//  CDDAPM
//
//  Created by flashgeek on 2024/10/14.
//

#import <Vision/Vision.h>
#import <CoreImage/CoreImage.h>

#import "UIImage+addition.h"
#import "CDDAPMImageDetection.h"

static dispatch_queue_t getQueue(void)
{
    static dispatch_queue_t s_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_queue = dispatch_queue_create("cdd.com.WKWebViewWhiteScreenMonitor", NULL);
        dispatch_queue_set_specific(s_queue, getQueue, NULL, NULL);
    });
    return s_queue;
}

@implementation CDDAPMImageDetection
+ (void)haveWhiteScreen:(UIImage * _Nullable)snapshotImage
             completion:(CDDAPMImageDetectionCompletion)completion
{
    dispatch_async(getQueue(), ^{
        if (snapshotImage) {
            UIImage* scaledImage = [snapshotImage cddImageByScalingToSize:0.5];
            // 创建VNDetectTextRectanglesRequest请求
            VNDetectTextRectanglesRequest *textRequest = [[VNDetectTextRectanglesRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
                if (error) {
                    if (completion) {
                        completion(false, error);
                    }
                    return;
                }
                NSArray *results = [request results];
                
                // 如果没有检测到文本矩形，可能是白屏
                if (results.count == 0) {
                    NSLog(@"可能检测到白屏");
                    // 在这里添加白屏处理逻辑
                } else {
                    NSLog(@"页面正常，检测到 %lu 个文本区域", (unsigned long)results.count);
                }
                if (completion) {
                    completion(results.count == 0, nil);
                }
            }];
            
            // 创建处理请求的处理器
            VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCIImage:[CIImage imageWithCGImage:scaledImage.CGImage] options:@{}];
            
            // 执行请求
            NSError *requestError = nil;
            [handler performRequests:@[textRequest] error:&requestError];
            
            if (requestError) {
                NSLog(@"执行VNDetectTextRectanglesRequest时发生错误: %@", requestError);
            }
        }
    });
}
@end
