#import "UIImage+addition.h"

@implementation UIImage (Scale)

- (UIImage *)cddImageByScalingToSize:(CGFloat)scaleFactor {
    // 计算新的尺寸
    CGSize newSize = CGSizeMake(self.size.width * scaleFactor, self.size.height * scaleFactor);
    
    // 创建一个图形上下文
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    
    // 绘制图像到新的上下文中
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    // 获取新的图像
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}
//
//- (void)cddSaveToCacheWithPath:(NSString *)filePath {
//    // 将图片转换为 NSData
//    NSData *imageData = UIImagePNGRepresentation(self);
//    if (imageData) {
//        // 将数据写入文件
//        [imageData writeToFile:filePath atomically:YES];
//        NSLog(@"图片已保存到路径: %@", filePath);
//    } else {
//        NSLog(@"图片转换为 NSData 失败");
//    }
//}
//
//- (void)cddSaveToCacheWithFileName:(NSString *)fileName {
//    // 获取缓存目录路径
//    NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
//    NSString *filePath = [cacheDirectory stringByAppendingPathComponent:fileName];
//    NSLog(@"filePath:%@", filePath);
//    // 调用 saveToCacheWithPath: 方法
//    [self cddSaveToCacheWithPath:filePath];
//}
//
//- (UIImage *)cddConvertToGrayscale {
//    // 创建一个上下文
//    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // 绘制原图到上下文中
//    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
//    
//    // 获取绘制后的图像
//    UIImage *originalImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    // 创建一个颜色空间
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
//    
//    // 创建一个新的上下文，用于绘制灰度图像
//    CGContextRef grayContext = CGBitmapContextCreate(NULL,
//                                                    originalImage.size.width,
//                                                    originalImage.size.height,
//                                                    8,
//                                                    originalImage.size.width * 1,
//                                                    colorSpace,
//                                                    kCGImageAlphaNone);
//    CGColorSpaceRelease(colorSpace);
//    
//    if (grayContext == NULL) {
//        NSLog(@"创建灰度上下文失败");
//        return nil;
//    }
//    
//    // 绘制原图到灰度上下文中
//    CGContextDrawImage(grayContext, CGRectMake(0, 0, originalImage.size.width, originalImage.size.height), originalImage.CGImage);
//    
//    // 获取灰度图像
//    CGImageRef grayImageRef = CGBitmapContextCreateImage(grayContext);
//    UIImage *grayImage = [UIImage imageWithCGImage:grayImageRef];
//    
//    // 释放上下文和图像
//    CGContextRelease(grayContext);
//    CGImageRelease(grayImageRef);
//    
//    return grayImage;
//}


@end
