//
//  CustomCell.m
//  CollectionViewDragAndDrop
//
//  Created by Pratima Gauns on 06/03/15.
//  Copyright (c) 2015 VP. All rights reserved.
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
@end
