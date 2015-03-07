//
//  GameCollectionViewController.m
//  HackathonChecker
//
//  Created by Vinnie Da Silva on 06/03/15.
//  Copyright (c) 2015 Creative capsule Infotech. All rights reserved.
//

#import "GameCollectionViewController.h"
#import "CustomCell.h"
#import "Checker.h"

@interface GameCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation GameCollectionViewController

static NSString * const reuseIdentifier = @"CustomCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
//
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.collectionView.contentOffset = CGPointMake(0, -1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 8;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    int arrayIndex = indexPath.row + indexPath.section  * 8;
    Checker *checker = [self.checkerObjects objectAtIndex:arrayIndex];
    cell.checker = checker;
    //[cell.image setImage:checker.image];
    
    
    if (((indexPath.row + indexPath.section) %2) == 0) {
        // Display first cell color
        cell.backgroundColor = self.firstCellColor;
    } else {
        // Display second cell color
        cell.backgroundColor = self.secondCellColor;
    }
     return cell;
}

#pragma mark - UICollectionViewDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 0.5f;
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 0.5f;
}

@end
