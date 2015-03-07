//
//  CheckerCircle.m
//  Checkers
//
//  Created by Vinnie Da Silva on 07/03/15.
//  Copyright (c) 2015 VP. All rights reserved.
//

#import "CheckerCircle.h"

@implementation CheckerCircle

- (NSString *)description {
    return [NSString stringWithFormat:@"radius - %f,  center - %@", self.radius, NSStringFromCGPoint(self.center)];
}

@end
