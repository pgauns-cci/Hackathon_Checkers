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
#define LX_LIMITED_MOVEMENT 0

typedef enum PlayerTurn {
    PlayerAnyTurn = 0,
    Player1Turn = 1,
    Player2Turn = 2,
} PlayerTurn;

@interface GameCollectionViewController ()

@property (nonatomic, readwrite) BOOL isplayer1;

@end

@implementation GameCollectionViewController

static NSString * const reuseIdentifier = @"CustomCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
    
    [self checkerStatus];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.collectionView.contentOffset = CGPointMake(0, 2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) refreshView{
    [self checkerStatus];
    
    for (Checker *checker in self.checkerObjects) {
//        CustomCell *customCell = (CustomCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:checker.position.row inSection:checker.position.column]];
//        [customCell refreshCell];
        [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:checker.position.row inSection:checker.position.column]]];
    }
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
    if (checker.checkerPlayer == 1) {
        cell.coinView.backgroundColor = self.player1CoinColor;
        cell.coinView.hidden = NO;
    } else if (checker.checkerPlayer == 2) {
        cell.coinView.backgroundColor = self.player2CoinColor;
        cell.coinView.hidden = NO;
    } else {
        cell.coinView.backgroundColor = [UIColor clearColor];
        cell.coinView.hidden = YES;
    }
    
    if (((indexPath.row + indexPath.section) %2) == 0) {
        // Display first cell color
        cell.backgroundColor = self.firstCellColor;
        if([checker containsCoin]){
            self.isEvenCheckPlayable = TRUE;
        }
    } else {
        // Display second cell color
        cell.backgroundColor = self.secondCellColor;
        if([checker containsCoin]){
            self.isEvenCheckPlayable = FALSE;
        }
    }
    
    return cell;
}

#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    int arrayIndex = indexPath.row + indexPath.section  * 8;
    Checker *checker = [self.checkerObjects objectAtIndex:arrayIndex];
    if([checker containsCoin]){
        return YES;
    }
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    if(self.isEvenCheckPlayable && (toIndexPath.row + toIndexPath.section) %2 == 0){
        return YES;
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath {
    Checker *fromChecker = [self.checkerObjects objectAtIndex:(fromIndexPath.row + fromIndexPath.section  * 8)];
    fromChecker.containsCoin = FALSE;
    
    Checker *toChecker = [self.checkerObjects objectAtIndex:(toIndexPath.row + toIndexPath.section  * 8) ];
    toChecker.containsCoin = TRUE;
    toChecker.checkerPlayer = fromChecker.checkerPlayer;
    fromChecker.checkerPlayer = 0;
    [self.collectionView reloadData];
}

#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will end drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did end drag");
}

- (void) checkerStatus{
    for (Checker *checker in self.checkerObjects) {
        if([checker containsCoin]){
            NSLog(@"Coin Position : (%d, %d)", checker.position.row, checker.position.column);
        }
    }
}
@end
