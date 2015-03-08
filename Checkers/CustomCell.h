//
//  CustomCell.h
//  CollectionViewDragAndDrop
//
//  Created by Pratima Gauns on 06/03/15.
//  Copyright (c) 2015 VP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Checker.h"

@interface CustomCell : UICollectionViewCell

@property (nonatomic, strong) Checker *checker;
@property (nonatomic, strong) IBOutlet UIView *coinView;

//@property (strong, nonatomic) IBOutlet UIImageView *image;
//@property (nonatomic, strong) UIColor *coinColor;

@end
