//
//  UIImage+Compress.m
//  RCTAuroraIMUI
//
//  Created by Mr.Zhang on 2018/10/18.
//  Copyright © 2018 HXHG. All rights reserved.
//

#import "UIImage+Compress.h"

@implementation UIImage (Compress)

+ (UIImage *)zipNSDataWithImage:(UIImage *)sourceImage{
    
        NSInteger maximum = 500 * 1024; // 500k
        NSData* data = UIImageJPEGRepresentation(sourceImage, 1);
    
    
    
        if (data.length < maximum) {
            //        NSLog(@"%s base: %zd", __func__, data.length);
            return [[UIImage alloc] initWithData:data];
        }
    
    
        // 预估总体大小
        CGImageRef image = sourceImage.CGImage;
    
        if(image == NULL){
       
            NSLog(@"不存在图片");
            
            return nil;
        }
    
        size_t bits = CGImageGetBitsPerPixel(image) / CGImageGetBitsPerComponent(image);
       NSLog(@"图片宽度 %lf   位图获取的宽度 %zu",sourceImage.size.width,CGImageGetWidth(image));
      NSLog(@"图片高度 %lf   位图获取的高度 %zu",sourceImage.size.height,CGImageGetHeight(image));
        size_t total = CGImageGetBytesPerRow(image) * CGImageGetHeight(image);
    NSLog(@"图片大小 %ld  位图的图片大小 %zu",data.length ,total);
        // 计算缩放比例
        CGFloat quality = (CGFloat)data.length / total; // 预估压缩率
        CGFloat rate = CGImageGetWidth(image) / (CGFloat)CGImageGetHeight(image);
        CGFloat h2 = (CGFloat)(maximum / quality) / bits / rate;
    
        CGFloat height = sqrt(h2);
        CGFloat width = height * rate;
    
        // 缩放图片
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [sourceImage drawInRect:CGRectMake(0, 0, width, height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
        return [[UIImage alloc] initWithData:UIImageJPEGRepresentation(newImage, 0.7)];

}


+ (UIImage *)scaleImage:(UIImage *)sourceImage{
    
    
    NSData *data =UIImagePNGRepresentation(sourceImage);
    CGFloat dataSize = data.length/1024;
    
    if (dataSize <= 400)//小于实际比这个数字还大
    {
        return sourceImage;
    }
    
    //缩放尺寸 不能小于当前屏幕的设备尺寸
    CGFloat width  = sourceImage.size.width;
    CGFloat height = sourceImage.size.height;
    //屏幕的宽度和高度
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds) /  2.0;
    CGSize size = CGSizeMake(screenWidth, screenWidth * height / width);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [sourceImage drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsEndImageContext();
    if (!newImage)
    {
        return sourceImage;
    }
    
    NSData *imgData = UIImageJPEGRepresentation(newImage, 0.5);
    
    NSUInteger i = 0;
    NSLog(@"原来的大小 = %lf",imgData.length/1024.0);
    while (imgData.length / 1024.0 > 500) {
        //每次压缩一半
        imgData = UIImageJPEGRepresentation([[UIImage alloc] initWithData:imgData], 0.5);
        NSLog(@"大小压缩 执行 %ld 次",++i);
    }
 
     NSLog(@"图片缩放的大小 = %lf",imgData.length/1024.0);
    return [[UIImage alloc] initWithData:imgData];
    
}

+ (NSData *)dateForScaleImage:(UIImage *)sourceImage{
    
    
    NSData *data = UIImageJPEGRepresentation(sourceImage , 1.0);
    CGFloat dataSize = data.length/1024;
    
    if (dataSize <= 400)//小于实际比这个数字还大
    {
        return data;
    }
    
    //缩放尺寸 不能小于当前屏幕的设备尺寸
    CGFloat width  = sourceImage.size.width;
    CGFloat height = sourceImage.size.height;
    //屏幕的宽度和高度
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds) /  2.0;
    CGSize size = CGSizeMake(screenWidth, ceil(screenWidth * height / width));
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [sourceImage drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsEndImageContext();
    if (!newImage)
    {
        return data;
    }
    
    NSData *imgData = UIImageJPEGRepresentation(newImage, 0.5);
    
//    NSUInteger i = 0;//压缩次数
//    NSLog(@"原来的大小 = %lf",imgData.length/1024.0);
    while (imgData.length / 1024.0 > 500) {
        //每次压缩一半
        imgData = UIImageJPEGRepresentation([[UIImage alloc] initWithData:imgData], 0.5);
//        NSLog(@"大小压缩 执行 %ld 次",++i);
    }
    
//    NSLog(@"图片缩放的大小 = %lf",imgData.length/1024.0);
    return imgData;
    
}

@end
