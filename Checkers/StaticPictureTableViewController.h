//
//  StaticPictureTableViewController.h
//  Checkers
//
//  Created by Pratima Gauns on 08/03/15.
//  Copyright (c) 2015 VP. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StaticPictureTableViewControllerDelegate <NSObject>
@required
- (void) tableViewDidSelectPictureAtIndex: (int)index;
@end

@interface StaticPictureTableViewController : UITableViewController

@property (nonatomic, assign) id<StaticPictureTableViewControllerDelegate> delegate;
@end
