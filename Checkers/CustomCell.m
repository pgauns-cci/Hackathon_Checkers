//
//  CustomCell.m
//  CollectionViewDragAndDrop
//
//  Created by Bharat Naik on 30/01/14.
//  Copyright (c) 2014 Bharat Naik. All rights reserved.
//

#import "CustomCell.h"
#import "AppDelegate.h"

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
    
    [self setBackgroundColor:cellColor];
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
	
//    if (pressRecognizer.state == UIGestureRecognizerStateBegan) {
//        delegate.gestureDetect = YES;
//        delegate.cellFrame = self;
//    }
//	
//    if (pressRecognizer.state == UIGestureRecognizerStateEnded) {
//        delegate.gestureDetect = NO;
//    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
