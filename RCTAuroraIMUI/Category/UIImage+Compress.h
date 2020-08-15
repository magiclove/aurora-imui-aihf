//
//  UIImage+Compress.h
//  RCTAuroraIMUI
//
//  Created by Mr.Zhang on 2018/10/18.
//  Copyright © 2018 HXHG. All rights reserved.
//  //图片压缩分类

#import <UIKit/UIKit.h>

@interface UIImage (Compress)

+ (UIImage *)zipNSDataWithImage:(UIImage *)sourceImage;


+ (UIImage *)scaleImage:(UIImage *)sourceImage;

+ (NSData *)dateForScaleImage:(UIImage *)sourceImage;

@end
