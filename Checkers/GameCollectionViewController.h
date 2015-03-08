//
//  GameCollectionViewController.h
//  HackathonChecker
//
//  Created by Vinnie Da Silva on 06/03/15.
//  Copyright (c) 2015 Creative capsule Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXReorderableCollectionViewFlowLayout.h"

@interface GameCollectionViewController : UICollectionViewController<LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>

@property (nonatomic, retain) NSMutableArray *checkerObjects;
@property (nonatomic, retain) UIImage *capturedImage;

// Checker colors
@property (nonatomic, strong) UIColor *firstCellColor;
@property (nonatomic, strong) UIColor *secondCellColor;

// Coin colors
@property (nonatomic, strong) UIColor *player1CoinColor;
@property (nonatomic, strong) UIColor *player2CoinColor;

@property (nonatomic, assign) BOOL isEvenCheckPlayable;

@end
