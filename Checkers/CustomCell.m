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
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.coinView.layer.cornerRadius = self.coinView.bounds.size.width/2;
    self.coinView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.coinView.layer.borderWidth = 1.0f;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    NSLog(@"drawRect: Coin Position : (%d, %d)", self.checker.position.row, self.checker.position.column);
//    // Drawing code
//    if(self.checker.containsCoin){
//        // If the check contains coin then get the center pixel color and draw circle
//        /* Draw a circle */
//        // Get the contextRef
//        CGContextRef contextRef = UIGraphicsGetCurrentContext();
//        
//        // Set the border width
//        CGContextSetLineWidth(contextRef, 1.0);
//        
////        UIColor *color = [Common colorAtPixel:CGPointMake(self.checker.image.size.width / 2, self.checker.image.size.height / 2) :self.checker.image];
//        
//        CGColorRef colorRef = [self.coinColor CGColor];
//        int red = 0;
//        int green = 0;
//        int blue = 0;
//        int _countComponents = CGColorGetNumberOfComponents(colorRef);
//        if (_countComponents == 4) {
//            const CGFloat *_components = CGColorGetComponents(colorRef);
//            red = (int)((CGFloat)_components[0] * 255.0f);
//            green = (int)((CGFloat)_components[1] * 255.0f);
//            blue = (int)((CGFloat)_components[2] * 255.0f);
//        }
//
//        
//        // Set the circle fill color to GREEN
//        CGContextSetRGBFillColor(contextRef, red/255.0f, green/255.0f, blue/255.0f, 1.0);
//        
//        // Set the cicle border color to WHITE
//        CGContextSetRGBStrokeColor(contextRef, 1.0, 1.0, 1.0, 1.0);
//        
//        // Fill the circle with the fill color
//        CGContextFillEllipseInRect(contextRef, rect);
//        
//        // Draw the circle border
//        CGContextStrokeEllipseInRect(contextRef, rect);
//    }
//    else{
//        // If the check is empty then get the center pixel color set it as background
//        UIColor *color = [Common colorAtPixel:CGPointMake(self.checker.image.size.width / 2, self.checker.image.size.height / 2) :self.checker.image];
//        [self setBackgroundColor:color];
//    }
//}
@end
