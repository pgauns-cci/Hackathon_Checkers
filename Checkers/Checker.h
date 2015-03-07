//
//  Checker.h
//  Checkers
//
//  Created by Pratima Gauns on 07/03/15.
//  Copyright (c) 2015 VP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#define kPaddingPercentage 0.10f

@interface Checker : NSObject

@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic, readwrite) NSInteger index;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *imageWithPadding;
@property (nonatomic, assign) BOOL containsCoin;
@end
