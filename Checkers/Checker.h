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

@interface Checker : NSObject
@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic, readwrite) NSInteger index;
@property (nonatomic, strong) UIImage *image;
@end
