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
+ (UIImage *) detectImageWithCoin:(UIImage *)image;

// Circle Detection using OpenCV

// Returns array of CheckerCircle objects
+ (NSMutableArray*) detectedCirclesInImage:(UIImage*)image;

// Returns array of CheckerCircle objects
+ (NSMutableArray*) detectedCirclesInImage:(UIImage*)image
                                 dp:(CGFloat)dp
                            minDist:(CGFloat)minDist
                             param2:(CGFloat)param2
                         min_radius:(int)min_radius
                         max_radius:(int)max_radius;

+ (UIImage *) highlightImageWithCoin:(UIImage *)image;
+ (BOOL) coinExistInImage:(UIImage *)image;
@end
