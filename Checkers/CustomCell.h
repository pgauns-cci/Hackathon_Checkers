//
//  CustomCell.h
//  CollectionViewDragAndDrop
//
//  Created by Bharat Naik on 30/01/14.
//  Copyright (c) 2014 Bharat Naik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger     indexPath;
@property (strong, nonatomic) IBOutlet UIImageView *image;

- (void) initGestures;
- (void) setCellColor:(UIColor *)cellColor;

@end
