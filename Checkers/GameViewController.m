//
//  GameViewController.m
//  HackathonChecker
//
//  Created by Vinnie Da Silva on 06/03/15.
//  Copyright (c) 2015 Creative capsule Infotech. All rights reserved.
//

#import "GameViewController.h"
#import "CVWrapper.h"
#import "UIImage+vImage.h"
#import "Checker.h"
#import "Common.h"
#import "GameCollectionViewController.h"

@interface GameViewController ()
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.button1.layer.borderColor = [UIColor whiteColor].CGColor;
    self.button1.layer.borderWidth = 2.0f;
    
    self.button2.layer.borderColor = [UIColor whiteColor].CGColor;
    self.button2.layer.borderWidth = 2.0f;
    
    [self detectCoins];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"CheckerBoardSegue"]) {
        GameCollectionViewController *gameCollectionViewController = segue.destinationViewController;
        gameCollectionViewController.checkerObjects = self.checkerObjects;
        gameCollectionViewController.capturedImage = self.capturedImage;

    }
}

- (void) detectCoins{
    NSMutableArray *houghAlgoDetectedCoins = [[NSMutableArray alloc] init];
    for (Checker *checker in self.checkerObjects) {
        NSMutableArray *arrayOfCheckerCircles = [Common detectedCirclesInImage:[Common convertToBinary:checker.imageWithPadding]
                                                                            dp:1.0
                                                                       minDist:10.0
                                                                        param2:30.0
                                                                    min_radius:1.0
                                                                    max_radius:40.0];
        NSLog(@"CaptureGameViewController - checkerCircles count : %lu", (unsigned long)[arrayOfCheckerCircles count]);
        if([arrayOfCheckerCircles count] > 0){
            [houghAlgoDetectedCoins addObject:[NSIndexPath  indexPathForRow:checker.position.x inSection:checker.position.y]];
            checker.containsCoin = true;
        }
    }
    
    NSLog(@"CaptureGameViewController - checkDetectedCheckWithCircles count : %lu", (unsigned long)[houghAlgoDetectedCoins count]);
    /*
    
     NSMutableArray *desnsityAlgoDetectedCoins = [[NSMutableArray alloc] init];
     for (Checker *checker in self.checkerObjects) {
     if([Common coinExistInImage:checker.image]){
     //If position detected in the Checker then save its position
     [desnsityAlgoDetectedCoins addObject:[NSIndexPath  indexPathForRow:checker.position.x inSection:checker.position.y]];
     }
     }
     
    UIImage *originalImage = [UIImage imageNamed:@"CheckerBoard_dark"];
    UIImage *sharpened = [originalImage gradientWithIterations:3];
    sharpened = [sharpened sharpen];
    
    UIImage *binaryImage = [Common convertToBinary:sharpened];
    
    UIImage* image =
    [CVWrapper detectedCirclesInImage:binaryImage
                                   dp:20
                              minDist:88
                               param2:10
                           min_radius:30
                           max_radius:44];
    dispatch_async(dispatch_get_main_queue(), ^{
        CGSize checkerSize = CGSizeMake(80, 80);
        UIImageView *imageView = [[UIImageView alloc]
                                  initWithFrame:CGRectMake(0,
                                                           0,
                                                           700,
                                                           700)];
        [imageView setImage:image];
        [self.containerView addSubview:imageView];
    });*/
}
@end
