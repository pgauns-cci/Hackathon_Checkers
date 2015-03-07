//
//  GameViewController.m
//  HackathonChecker
//
//  Created by Vinnie Da Silva on 06/03/15.
//  Copyright (c) 2015 Creative capsule Infotech. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.button1.layer.borderColor = [UIColor whiteColor].CGColor;
    self.button1.layer.borderWidth = 2.0f;
    
    self.button2.layer.borderColor = [UIColor whiteColor].CGColor;
    self.button2.layer.borderWidth = 2.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"CheckerBoardSegue"]) {
        
    }
}

@end
