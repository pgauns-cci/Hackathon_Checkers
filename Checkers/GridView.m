//
//  GridView.m
//  Checkers
//
//  Created by Pratima Gauns on 07/03/15.
//  Copyright (c) 2015 VP. All rights reserved.
//

#import "GridView.h"

@implementation GridView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    
    for (int i = 1; i < 8; i++) {
        // Vertical
        [bezierPath moveToPoint:CGPointMake(i * self.frame.size.width / 8, 0)];
        [bezierPath addLineToPoint:CGPointMake(i * self.frame.size.width / 8, self.frame.size.height)];
        
        // Horizontal
        [bezierPath moveToPoint:CGPointMake(0, i * self.frame.size.height / 8)];
        [bezierPath addLineToPoint:CGPointMake(self.frame.size.width, i * self.frame.size.height / 8)];
    }
    
    [[[UIColor whiteColor] colorWithAlphaComponent:0.4f] setStroke];
    [bezierPath setLineWidth:3.0f];
    [bezierPath stroke];
    [self setNeedsDisplay];
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 3.0f;
}
@end
