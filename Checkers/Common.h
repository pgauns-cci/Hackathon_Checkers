//
//  Common.h
//  Checkers
//
//  Created by Pratima Gauns on 07/03/15.
//  Copyright (c) 2015 VP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface Common : NSObject
+ (UIImage *)convertImageToGrayScale:(UIImage *)image;
+ (UIImage *)convertToBinary:(UIImage *)originalImage;

+ (BOOL)saveImage:(UIImage *)image withName:(NSString *)fileNameWithExtension;
+ (UIImage *) highlightImageWithCoin:(UIImage *)image;
+ (BOOL) coinExistInImage:(UIImage *)image;
@end
