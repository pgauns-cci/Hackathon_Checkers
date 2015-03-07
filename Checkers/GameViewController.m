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

@interface ColorComponents : NSObject 

@property (nonatomic, readwrite) int red;
@property (nonatomic, readwrite) int green;
@property (nonatomic, readwrite) int blue;

+ (ColorComponents *)colorComponentsFromColor:(UIColor *)color;

@end

@implementation ColorComponents

+ (ColorComponents *)colorComponentsFromColor:(UIColor *)color {
    
    ColorComponents *colorComponents = nil;
    CGColorRef colorRef = [color CGColor];
    int _countComponents = CGColorGetNumberOfComponents(colorRef);
    if (_countComponents == 4) {
        const CGFloat *_components = CGColorGetComponents(colorRef);
        colorComponents = [[ColorComponents alloc] init];
        colorComponents.red = (int)((CGFloat)_components[0] * 255.0f);
        colorComponents.green = (int)((CGFloat)_components[1] * 255.0f);
        colorComponents.blue = (int)((CGFloat)_components[2] * 255.0f);
    }
    return colorComponents;
}

@end

@interface GameViewController ()

@property (strong, nonatomic) IBOutlet UIView *coinSelectorContainerView;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *player1CoinView;
@property (strong, nonatomic) IBOutlet UIView *player2CoinView;

@property (nonatomic, strong) UIColor *firstCellColor;
@property (nonatomic, strong) UIColor *secondCellColor;

@property (nonatomic, strong) UIColor *player1CoinColor;
@property (nonatomic, strong) UIColor *player2CoinColor;

// IBActions
- (IBAction)colorSelectorButtonTapped:(UIButton *)sender;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self detectCoins];
    
    self.button1.layer.borderColor = [UIColor whiteColor].CGColor;
    self.button1.layer.borderWidth = 2.0f;
    self.button1.backgroundColor = self.player1CoinColor;
    
    self.button2.layer.borderColor = [UIColor whiteColor].CGColor;
    self.button2.layer.borderWidth = 2.0f;
    self.button2.backgroundColor = self.player2CoinColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"CheckerBoardSegue"]) {
        [self detectCoins];
        GameCollectionViewController *gameCollectionViewController = segue.destinationViewController;
        gameCollectionViewController.checkerObjects = self.checkerObjects;
        gameCollectionViewController.capturedImage = self.capturedImage;
        gameCollectionViewController.firstCellColor = self.firstCellColor;
        gameCollectionViewController.secondCellColor = self.secondCellColor;

        gameCollectionViewController.player1CoinColor = self.player1CoinColor;
        gameCollectionViewController.player2CoinColor = self.player2CoinColor;
    }
}

- (void)detectCoins {
    
    NSMutableArray *houghAlgoDetectedCoins = [[NSMutableArray alloc] init];
    
    for (Checker *checker in self.checkerObjects) {
        
        NSMutableArray *arrayOfCheckerCircles = [Common detectedCirclesInImage:[Common convertToBinary:checker.imageWithPadding]
                                                                            dp:1.0
                                                                       minDist:10.0
                                                                        param2:30.0
                                                                    min_radius:1.0
                                                                    max_radius:100.0];
        NSLog(@"CaptureGameViewController - checkerCircles count : %lu", (unsigned long)[arrayOfCheckerCircles count]);
        
        if ([arrayOfCheckerCircles count] > 0){
            // Coin - Found
            [houghAlgoDetectedCoins addObject:[NSIndexPath  indexPathForRow:checker.position.row inSection:checker.position.column]];
            checker.containsCoin = true;
        } else {
            // Coin - Not Found
            if ((checker.position.row + checker.position.column) %2 == 0) {
                self.firstCellColor = [Common colorAtPixel:CGPointMake(checker.image.size.width/2, checker.image.size.height/2) :checker.image];
            } else {
                self.secondCellColor = [Common colorAtPixel:CGPointMake(checker.image.size.width/2, checker.image.size.height/2) :checker.image];
            }
        }
    }
    
    NSLog(@"CaptureGameViewController - checkDetectedCheckWithCircles count : %lu", (unsigned long)[houghAlgoDetectedCoins count]);
    
    [self findCheckerCoinColors];
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


- (void)findCheckerCoinColors {
    
    for (Checker *checker in self.checkerObjects) {
        if (!checker.containsCoin) {
            continue;
        }
        
        UIColor *colorOfPixelAtCenter = [Common colorAtPixel:CGPointMake(checker.image.size.width/2, checker.image.size.height/2) :checker.image];
        
        if (!self.player1CoinColor) {
            self.player1CoinColor = colorOfPixelAtCenter;
            checker.checkerPlayer = CheckerPlayer1;
            continue;
        } else {
            // Get RGB components
            ColorComponents *currentColorComponents = [ColorComponents colorComponentsFromColor:colorOfPixelAtCenter];
            ColorComponents *player1CoinColorComponent  = [ColorComponents colorComponentsFromColor:self.player1CoinColor];
            
            if (abs(currentColorComponents.red - player1CoinColorComponent.red) <=10 &&
                abs(currentColorComponents.green - player1CoinColorComponent.green) <= 10 &&
                abs(currentColorComponents.blue - player1CoinColorComponent.blue) <= 10) {
                checker.checkerPlayer = CheckerPlayer1;
                continue;
            } else {
//                if (!self.player2CoinColor) {
                    self.player2CoinColor = colorOfPixelAtCenter;
                    checker.checkerPlayer = CheckerPlayer2;
//                }
            }
        }
    }
}

#pragma mark - IBActions

- (IBAction)colorSelectorButtonTapped:(UIButton *)sender {
    self.player1CoinView.layer.cornerRadius = self.player1CoinView.bounds.size.width / 2.0;
    self.player1CoinView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.player1CoinView.layer.borderWidth = 1.0f;
    
    self.player2CoinView.layer.cornerRadius = self.player2CoinView.bounds.size.width / 2.0;
    self.player2CoinView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.player2CoinView.layer.borderWidth = 1.0f;
    
    if ([sender isEqual:self.button1]) {
        // Button 1 color
        self.player1CoinView.backgroundColor = self.button1.backgroundColor;
        self.player2CoinView.backgroundColor = self.button2.backgroundColor;
    } else {
        // Button 2 color
        self.player1CoinView.backgroundColor = self.button2.backgroundColor;
        self.player2CoinView.backgroundColor = self.button1.backgroundColor;
    }
    self.coinSelectorContainerView.hidden = YES;
}

@end
