//
//  StaticPictureTableViewController.m
//  Checkers
//
//  Created by Pratima Gauns on 08/03/15.
//  Copyright (c) 2015 VP. All rights reserved.
//

#import "StaticPictureTableViewController.h"
#define CELLIDENTIFIER_1 @"CellIdentifierPicture1";
#define CELLIDENTIFIER_2 @"CellIdentifierPicture2";

static NSArray *staticPictures;

@implementation StaticPictureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    staticPictures = [NSArray arrayWithObjects:@"CheckerBoard_light", @"CheckerBoard1", nil];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

# pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier;

    switch (indexPath.row) {
        case 0:
            simpleTableIdentifier = CELLIDENTIFIER_1;
            break;
        case 1:
            simpleTableIdentifier = CELLIDENTIFIER_2;
            break;
        default:
            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:121];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setImage:[UIImage imageNamed:[staticPictures objectAtIndex:indexPath.row]]];
    
    return cell;
}

# pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate tableViewDidSelectPictureAtIndex:indexPath.row];
}
@end
