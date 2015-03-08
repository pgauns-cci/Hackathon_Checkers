//
//  Common.m
//  Checkers
//
//  Created by Pratima Gauns on 07/03/15.
//  Copyright (c) 2015 VP. All rights reserved.
//

#import "Common.h"
#import "UIImage+vImage.h"
#import "CVWrapper.h"
#import "DetectedCheckerCircle.h"
#import "CheckerCircle.h"

@implementation Common

+ (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}


+ (UIImage *)convertToBinary:(UIImage *)originalImage {
    originalImage = [originalImage gradientWithIterations:3];
    originalImage = [originalImage sharpen];
    unsigned char *pixelBuffer = [Common getPixelData:originalImage.CGImage];
    size_t length = originalImage.size.width * originalImage.size.height * 4;
    CGFloat intensity;
    int bw;
    //50% threshold
    const CGFloat THRESHOLD = 0.5;
    for (int index = 0; index < length; index += 4)
    {
        intensity = (pixelBuffer[index] + pixelBuffer[index + 1] + pixelBuffer[index + 2]) / 3 / 255.;
        if (intensity > THRESHOLD) {
            bw = 0;
        } else {
            bw = 255;
        }
        pixelBuffer[index] = bw;
        
        
        pixelBuffer[index + 1] = bw;
        pixelBuffer[index + 2] = bw;
    }
    
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    
    CGContextRef bitmapContext=CGBitmapContextCreate(pixelBuffer, originalImage.size.width, originalImage.size.height, 8, 4*originalImage.size.width, colorSpace,  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    
    CGImageRef cgImage=CGBitmapContextCreateImage(bitmapContext);
    
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    CFRelease(colorSpace);
    free(pixelBuffer);
    CGContextRelease(bitmapContext);
    return result;
}

+ (unsigned char *) getPixelData: (CGImageRef) cgCropped {
    
    size_t imageWidth = CGImageGetWidth(cgCropped);
    
    size_t imageHeight = CGImageGetHeight(cgCropped);
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = 4;
    size_t bytesPerRow = bytesPerPixel * imageWidth;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    unsigned char *rawData = malloc(imageHeight * imageWidth * 4);
    CGContextRef offscreenContext = CGBitmapContextCreate(rawData, imageWidth, imageHeight,
                                                          bitsPerComponent, bytesPerRow, colorSpace,
                                                          kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, imageWidth, imageHeight), cgCropped);
    CGContextRelease(offscreenContext);
    
    
    return rawData;
}

+ (BOOL)saveImage:(UIImage *)image withName:(NSString *)fileNameWithExtension {
    // Create path.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileNameWithExtension];
    
    NSString *fileExtension = [fileNameWithExtension pathExtension];
    
    BOOL isImageSaved = NO;
    // Save image.
    if ([fileExtension isEqualToString:@"png"]) {
        isImageSaved = [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    } else if ([fileExtension isEqualToString:@"jpg"]) {
        isImageSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath atomically:YES];
    }
    return isImageSaved;
}

+ (BOOL) imageContainsCoin:(UIImage *)image{
    
    unsigned char *pixelBuffer = [Common getPixelData:image.CGImage];
    size_t length = image.size.width * image.size.height * 4;
    int lowDensity = 0, highDendity = 0;
    
    int intensity;
    //Scan the image to get the lowdensity and highDensity
    for (int index = 0; index < length;index += 4) {
        
        intensity = (pixelBuffer[index] + pixelBuffer[index + 1] + pixelBuffer[index + 2]) / 3;
        
        if(intensity == 255){
            highDendity++;
        }
        else if(intensity == 0){
            lowDensity++;
        }
    }
//    NSLog(@"(%d : %d)", lowDensity, highDendity);
//    NSLog(@"Difference : (%d)",abs(highDendity - lowDensity));
    
    if(abs(highDendity - lowDensity) < length/(4 * 3)){
        return true;
    }
    return false;
    
}

+ (UIImage *) drawCircleOverImage:(UIImage *) originalImage{
    // begin a graphics context of sufficient size
    UIGraphicsBeginImageContext(originalImage.size);
    
    // draw original image into the context
    [originalImage drawAtPoint:CGPointZero];
    
    // get the context for CoreGraphics
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // set stroking color and draw circle
    [[UIColor redColor] setStroke];
    
    // make circle rect 5 px from border
    CGRect circleRect = CGRectMake(0, 0,
                                   originalImage.size.width,
                                   originalImage.size.height);
    circleRect = CGRectInset(circleRect, 5, 5);
    
    // draw circle
    CGContextStrokeEllipseInRect(ctx, circleRect);
    
    // make image out of bitmap context
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // free the context
    UIGraphicsEndImageContext();
    
    return retImage;
}

+ (UIImage *) highlightImageWithCoin:(UIImage *)image{
    UIImage *binaryImage = [self convertToBinary:image];
    
    if([self imageContainsCoin:binaryImage]){
        binaryImage = [self drawCircleOverImage:binaryImage];
    }
    return binaryImage;
}

+ (NSMutableArray*) detectedCirclesInImage:(UIImage*)image {
    [CVWrapper detectedCirclesInImage:image];
    NSMutableArray *arrayOfCheckerCircles = [DetectedCheckerCircle sharedDetectedCheckerCircle].arrayOfCheckerCircles;
    
    // Testing purpose
//    for (CheckerCircle *checkerCircle in arrayOfCheckerCircles) {
//        NSLog(@"CheckerCircle :   %@", checkerCircle.description);
//    }
    return arrayOfCheckerCircles;
}

+ (NSMutableArray*) detectedCirclesInImage:(UIImage*)image
                                        dp:(CGFloat)dp
                                   minDist:(CGFloat)minDist
                                    param2:(CGFloat)param2
                                min_radius:(int)min_radius
                                max_radius:(int)max_radius {
    [CVWrapper detectedCirclesInImage:image
                                   dp:dp
                              minDist:minDist
                               param2:param2
                           min_radius:min_radius
                           max_radius:max_radius];
    
    NSMutableArray *arrayOfCheckerCircles = [DetectedCheckerCircle sharedDetectedCheckerCircle].arrayOfCheckerCircles;
    
    // Testing purpose
//    for (CheckerCircle *checkerCircle in arrayOfCheckerCircles) {
//        NSLog(@"CheckerCircle :   %@", checkerCircle.description);
//    }
    return arrayOfCheckerCircles;
}

+ (BOOL) coinExistInImage:(UIImage *)image{
    UIImage *binaryImage = [self convertToBinary:image];
    
    if([self imageContainsCoin:binaryImage]){
        return true;
    }
    return false;
}

+ (UIColor *)colorAtPixel:(CGPoint)point :(UIImage *)image{
    // Cancel if the point is outside of the image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point)) {
        return nil;
    }
    
    // Create a 1x1 pixel byte array and bitmap context to draw the pixel onto.
    // Reference: http://stackoverflow.com/questions/1042830/retrieving-a-pixel-alpha-value-for-a-uiimage
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    
    CGImageRef cgImage = image.CGImage;
    
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    
    CGContextRef context = CGBitmapContextCreate( pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in
    CGContextTranslateCTM(context, -pointX, -pointY);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert the color values [0...255] to floats [0.0f...1.0f]
    CGFloat r = (CGFloat)pixelData[0] / 255.0f;
    CGFloat g = (CGFloat)pixelData[1] / 255.0f;
    CGFloat b = (CGFloat)pixelData[2] / 255.0f;
    CGFloat a = (CGFloat)pixelData[3] / 255.0f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}
@end
