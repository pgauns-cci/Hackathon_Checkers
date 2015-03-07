//
//  UIImage+ImageProcessing.m
//  Checkers
//
//  Created by Pratima Gauns on 07/03/15.
//  Copyright (c) 2015 VP. All rights reserved.
//

#import "UIImage+ImageProcessing.h"
#import "UIImage+vImage.h"

@interface UIImage (PrivateCategoryImageProcessing)

- (unsigned char *)getPixelData:(CGImageRef)cgCropped;

@end

@implementation UIImage (PrivateCategoryImageProcessing)

- (unsigned char *)getPixelData:(CGImageRef)cgCropped {
    
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

@end

@implementation UIImage (ImageProcessing)

#pragma mark - Public Methods

- (UIImage *)grayScaleImage {
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, self.size.width, self.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [self CGImage]);
    
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

- (UIImage *)binaryImage {
    unsigned char *pixelBuffer = [self getPixelData:self.CGImage];
    size_t length = self.size.width * self.size.height * 4;
    CGFloat intensity;
    int bw;
    //50% threshold
    const CGFloat THRESHOLD = 0.5;
    for (int index = 0; index < length; index += 4) {
        intensity = (pixelBuffer[index] + pixelBuffer[index + 1] + pixelBuffer[index + 2]) / 3. / 255.;
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
    CGContextRef bitmapContext=CGBitmapContextCreate(pixelBuffer, self.size.width, self.size.height, 8, 4*self.size.width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    CGImageRef cgImage=CGBitmapContextCreateImage(bitmapContext);
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    CFRelease(colorSpace);
    free(pixelBuffer);
    CGContextRelease(bitmapContext);
    return result;
}

- (BOOL)saveImageWithName:(NSString *)fileNameWithExtension {
    // Create path.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileNameWithExtension];
    NSString *fileExtension = [fileNameWithExtension pathExtension];
    
    BOOL isImageSaved = NO;
    // Save image.
    if ([fileExtension isEqualToString:@"png"]) {
        isImageSaved = [UIImagePNGRepresentation(self) writeToFile:filePath
                                                        atomically:YES];
    } else if ([fileExtension isEqualToString:@"jpg"]) {
        isImageSaved = [UIImageJPEGRepresentation(self, 1.0) writeToFile:filePath
                                                              atomically:YES];
    }
    return isImageSaved;
}

- (UIImage*)cropImageInFrame:(CGRect)rect {
    
    UIView *containerView = [[UIView alloc] init];
    containerView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    containerView.clipsToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = self;
    imageView.frame = CGRectMake(- rect.origin.x, - rect.origin.y, self.size.width, self.size.height);
    
    [containerView addSubview:imageView];
    
    UIImage *result = [self imageFromLayer:containerView.layer];
    return result;
}

- (UIImage *)imageFromLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContext([layer frame].size);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}


// Convolution Oprations
- (UIImage *)sharpenImage {
    UIImage *result = [self sharpen];
    return result;
}

// Geometric Operations
- (UIImage *)rotateImageInRadians:(float)radians {
    UIImage *result = [self rotateInRadians:radians];
    return result;
}

// Histogram Operations
- (UIImage *)equalizedImage {
    UIImage *result = [self equalization];
    return result;
}
@end
