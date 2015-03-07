//
//  DetectedCheckerCircle.h
//  Checkers
//
//  Created by Vinnie Da Silva on 07/03/15.
//  Copyright (c) 2015 VP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetectedCheckerCircle : NSObject

@property (nonatomic, strong) NSMutableArray *arrayOfCheckerCircles;

+ (DetectedCheckerCircle *)sharedDetectedCheckerCircle;

@end
