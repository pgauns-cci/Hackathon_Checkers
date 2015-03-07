//
//  UIImage+ImageProcessing.h
//  Checkers
//
//  Created by Pratima Gauns on 07/03/15.
//  Copyright (c) 2015 VP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageProcessing)
- (UIImage *)grayScaleImage;
- (UIImage *)binaryImage;
- (BOOL)saveImageWithName:(NSString *)fileNameWithExtension;
- (UIImage *)cropImageInFrame:(CGRect)rect;

// Convolution Oprations
- (UIImage *)sharpenImage;

// Geometric Operations
- (UIImage *)rotateImageInRadians:(float)radians;

// Histogram Operations
- (UIImage *)equalizedImage;

@end
