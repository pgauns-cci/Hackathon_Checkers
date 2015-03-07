//
//  Checker.h
//  Checkers
//
//  Created by Pratima Gauns on 07/03/15.
//  Copyright (c) 2015 VP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#define kPaddingPercentage 0.10f

struct CheckerPosition {
    int row;
    int column;
};
typedef struct CheckerPosition CheckerPosition;

static inline CheckerPosition
CheckerPositionMake(int row, int column) {
    CheckerPosition checkerPosition;
    checkerPosition.row = row;
    checkerPosition.column = column;
    return checkerPosition;
}

typedef enum CheckerPlayer {
    CheckerPlayer1 = 1,
    CheckerPlayer2 = 2
} CheckerPlayer;

@interface Checker : NSObject

@property (nonatomic, readwrite) CheckerPosition position;
@property (nonatomic, readwrite) NSInteger index;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *imageWithPadding;
@property (nonatomic, assign) BOOL containsCoin;
@property (nonatomic, readwrite) CheckerPlayer checkerPlayer;

@end
