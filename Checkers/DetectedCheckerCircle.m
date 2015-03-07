//
//  DetectedCheckerCircle.m
//  Checkers
//
//  Created by Vinnie Da Silva on 07/03/15.
//  Copyright (c) 2015 VP. All rights reserved.
//

#import "DetectedCheckerCircle.h"

static DetectedCheckerCircle *sharedDetectedCheckerCircle = nil;

@implementation DetectedCheckerCircle

+ (DetectedCheckerCircle *)sharedDetectedCheckerCircle {
    @synchronized (self) {
        if (!sharedDetectedCheckerCircle) {
            sharedDetectedCheckerCircle = [[DetectedCheckerCircle alloc] init];
        }
    }
    return sharedDetectedCheckerCircle;
}

@end
