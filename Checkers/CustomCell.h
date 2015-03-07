//
//  CustomCell.h
//  CollectionViewDragAndDrop
//
//  Created by Bharat Naik on 30/01/14.
//  Copyright (c) 2014 Bharat Naik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Checker.h"

@interface CustomCell : UICollectionViewCell

@property (nonatomic, retain) Checker     *checker;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, strong) UIColor *coinColor;

@end
