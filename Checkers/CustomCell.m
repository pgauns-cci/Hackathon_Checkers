//
//  CustomCell.m
//  CollectionViewDragAndDrop
//
//  Created by Bharat Naik on 30/01/14.
//  Copyright (c) 2014 Bharat Naik. All rights reserved.
//

#import "CustomCell.h"
#import "AppDelegate.h"
#import "Common.h"

@interface CustomCell ()
{
    AppDelegate *delegate;
}

@end

@implementation CustomCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) setCellColor:(UIColor *)cellColor{
    
    //[self setBackgroundColor:cellColor];
}

- (void) initGestures{
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressDetected:)];
    pressRecognizer.numberOfTapsRequired = 0;
    pressRecognizer.minimumPressDuration = 0.1;
    [self addGestureRecognizer:pressRecognizer];
}

- (void)pressDetected:(UILongPressGestureRecognizer *)pressRecognizer
{
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if(self.checker.containsCoin){
        // If the check contains coin then get the center pixel color and draw circle
        /* Draw a circle */
        // Get the contextRef
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        
        // Set the border width
        CGContextSetLineWidth(contextRef, 1.0);
        
        UIColor *color = [Common colorAtPixel:CGPointMake(self.checker.image.size.width / 2, self.checker.image.size.height / 2) :self.checker.image];
        
        // Set the circle fill color to GREEN
        CGContextSetRGBFillColor(contextRef, 0.0, 255.0, 0.0, 1.0);
        
        // Set the cicle border color to BLUE
        CGContextSetRGBStrokeColor(contextRef, 0.0, 0.0, 255.0, 1.0);
        
        // Fill the circle with the fill color
        CGContextFillEllipseInRect(contextRef, rect);
        
        // Draw the circle border
        CGContextStrokeEllipseInRect(contextRef, rect);
    }
    else{
        // If the check is empty then get the center pixel color set it as background
        UIColor *color = [Common colorAtPixel:CGPointMake(self.checker.image.size.width / 2, self.checker.image.size.height / 2) :self.checker.image];
        [self setBackgroundColor:color];
    }
}


@end
