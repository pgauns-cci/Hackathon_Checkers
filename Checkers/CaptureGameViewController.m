//
//  ViewController.m
//  Checkers
//
//  Created by Pratima Gauns on 06/03/15.
//  Copyright (c) 2015 VP. All rights reserved.
//

#import "CaptureGameViewController.h"
#import "UIImage+ImageProcessing.h"
#import "CaptureSessionManager.h"
#import "GameViewController.h"
#import "StaticPictureTableViewController.h"
#import "GridView.h"
#import "Checker.h"
#import "Common.h"
#import "AppDelegate.h"



@interface CaptureGameViewController ()<StaticPictureTableViewControllerDelegate>

// Properties
@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) IBOutlet UIButton *resetButton;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) CaptureSessionManager *captureManager;
@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;
@property (nonatomic, readwrite) BOOL isCapturingGame;
@property (nonatomic, strong) IBOutlet GridView *gridView;
@property (nonatomic, strong) UIImage *capturedImage;
@property (nonatomic, strong) IBOutlet UIImageView *checkerboardImageView;
@property (nonatomic, strong) NSMutableArray *arrayOfCheckerObjects;   // images for single box

// IBActions
- (IBAction)handleSingleTapGesture:(id)sender;
- (IBAction)nextButtonTapped:(UIBarButtonItem *)sender;
- (IBAction)resetButtonTapped:(UIButton *)sender;

// Private Methods
- (void)configureCaptureManager;
- (void)configurePreviewLayer;
- (void)saveCapturedImage;
- (void)imageCapturedSuccessfully;
- (void)generateCheckerObjects;

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
- (void)saveImageToPhotoAlbum;

@end

@implementation CaptureGameViewController

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.resetButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.resetButton.layer.borderWidth = 4.0f;
    self.resetButton.layer.cornerRadius = 20.0f;
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = self.resetButton.bounds;
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.resetButton.bounds cornerRadius:20.0f].CGPath;
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    
    [self.resetButton.layer setMask:shapeLayer];
    
    
    

    
    [self configureCaptureManager];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageCapturedSuccessfully)
                                                 name:kImageCapturedSuccessfully
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSMutableArray *arrayOfCheckerCircles = [Common detectedCirclesInImage:[Common convertToBinary:[UIImage imageNamed:@"CheckerBoard_dark.png"]]
                                                                        dp:1.0
                                                                   minDist:10.0
                                                                    param2:30.0
                                                                min_radius:1.0
                                                                max_radius:120.0];
//    NSLog(@"CaptureGameViewController - checkerCircles count : %d", [arrayOfCheckerCircles count]);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload {
    [self setContainerView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Custom getters

//- (CaptureSessionManager *)captureManager {
//    if (!_captureManager) {
//        _captureManager = [[CaptureSessionManager alloc] init];
//    }
//    return _captureManager;
//}

#pragma mark - Custom Setters

- (void)setIsCapturingGame:(BOOL)isCapturingGame {
    _isCapturingGame = isCapturingGame;
    self.backgroundImageView.image = [UIImage imageNamed:@"background"];
    if (!_isCapturingGame) {
        
        // Reset Capture Manager
        [self configureCaptureManager];
        self.checkerboardImageView.image = nil;
        self.checkerboardImageView.hidden = YES;
        
        // Change text on the label
//        self.infoLabel.text = @"Tap to capture";
        
        self.infoLabel.hidden = NO;
        self.resetButton.hidden = YES;
        self.tapGestureRecognizer.enabled = YES;
        
        [self.arrayOfCheckerObjects removeAllObjects];
        self.arrayOfCheckerObjects = nil;
    } else {
        // Capture image
        [self saveCapturedImage];
        
        // Change text on the label
        self.infoLabel.hidden = YES;
//        self.infoLabel.text = @"Reset";
        self.tapGestureRecognizer.enabled = NO;
        
        self.resetButton.hidden = NO;
    }
}

#pragma mark - IBActions

- (IBAction)handleSingleTapGesture:(id)sender {
    self.isCapturingGame = !self.isCapturingGame;
    
}

- (IBAction)nextButtonTapped:(UIBarButtonItem *)sender {
//    [self generateCheckerObjects];
    if (self.arrayOfCheckerObjects) {
        [self performSegueWithIdentifier:@"GameViewSegue" sender:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please capture or choose an image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)resetButtonTapped:(UIButton *)sender {
    self.isCapturingGame = !self.isCapturingGame;
}

#pragma mark - Private Methods

- (void)configureCaptureManager {
    
    if (!self.captureManager) {
        self.captureManager = [[CaptureSessionManager alloc] init];
    }
    
    [self.captureManager addVideoInput];
    [self configurePreviewLayer];
    [self.captureManager.captureSession startRunning];
    [self.captureManager addStillImageOutput];
}

- (void)configurePreviewLayer {
    [self.captureManager previewLayer];
    CGRect layerRect = self.containerView.layer.bounds;
    AVCaptureVideoPreviewLayer *previewLayer = [self.captureManager previewLayer];
    previewLayer.bounds = layerRect;
    previewLayer.position = CGPointMake(CGRectGetMidX(layerRect),
                                        CGRectGetMidY(layerRect));
    
    if (!previewLayer.superlayer) {
        [self.containerView.layer addSublayer:previewLayer];
    }
}

- (void)saveCapturedImage {
    [[self captureManager] captureStillImage];
}

- (void)imageCapturedSuccessfully {
    
    UIImage *image = self.captureManager.stillImage;
    CGFloat newHeight = self.containerView.frame.size.height * (image.size.width / self.containerView.frame.size.width);
    CGFloat heightDifference = (image.size.height - newHeight) / 2.0f;
    CGRect croppingRect = CGRectMake(0, heightDifference, image.size.width, newHeight);
    
    // Get a cropped image with the aspect ration same as the containerViewController
    UIImage *croppedImage = [image cropImageInFrame:croppingRect];
    image = croppedImage;
    
    CGFloat ratio = (image.size.width / self.containerView.frame.size.width);
    CGRect gridCropFrame = CGRectMake(self.gridView.frame.origin.x * ratio, (self.gridView.frame.origin.y * ratio), self.gridView.frame.size.width * ratio, self.gridView.frame.size.height * ratio);
    
    self.capturedImage =  [image cropImageInFrame:gridCropFrame];
    self.checkerboardImageView.image = self.capturedImage   ;
    [self.checkerboardImageView setContentMode:UIViewContentModeScaleAspectFit];
    self.checkerboardImageView.layer.borderWidth = 3.0f;
    self.checkerboardImageView.layer.borderColor = [UIColor redColor].CGColor;
    self.checkerboardImageView.hidden = NO;
    self.captureManager = nil;
    
    [self generateCheckerObjects];
    
    //    [self performSegueWithIdentifier:@"showGameViewController" sender:self];
    //GameViewController *vc = [[GameViewController alloc] init];
    //vc.checkerObjects = self.arrayOfCheckerObjects;
    //[self presentViewController:vc animated:YES completion:nil];
    //Save image in album
    //    [self saveImageToPhotoAlbum];
}

- (void)generateCheckerObjects {
    self.arrayOfCheckerObjects = nil;
    self.arrayOfCheckerObjects = [[NSMutableArray alloc] init];
    int index = 0;
    CGFloat widthOfImage = self.capturedImage.size.width / 8.0f;
    CGFloat heightOfImage = self.capturedImage.size.height / 8.0f;
    for (int y = 0; y < 8; y++) {
        for (int x = 0; x < 8; x++) {
            Checker *checker = [[Checker alloc] init];
            checker.position = CheckerPositionMake(x, y);
            checker.index = index;
            checker.image = [self.capturedImage cropImageInFrame:CGRectMake(x * widthOfImage, y * heightOfImage, widthOfImage, heightOfImage)];
            checker.imageWithPadding = [self.capturedImage cropImageInFrame:CGRectMake(x*widthOfImage - widthOfImage*kPaddingPercentage, y*heightOfImage - heightOfImage*kPaddingPercentage, widthOfImage + widthOfImage*kPaddingPercentage*2.0f, heightOfImage + heightOfImage*kPaddingPercentage*2.0f)];
            [self.arrayOfCheckerObjects addObject:checker];
            index ++;
        }
    }
}

- (void)saveImageToPhotoAlbum {
    UIImageWriteToSavedPhotosAlbum(self.capturedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:@"Image couldn't be saved"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GameViewSegue"]) {
        GameViewController *gameViewController = segue.destinationViewController;
        gameViewController.checkerObjects = self.arrayOfCheckerObjects;
        gameViewController.capturedImage = self.capturedImage;
    }
    else if([segue.identifier isEqualToString:@"StaticPictureTableView"]){
        StaticPictureTableViewController *staticPictureTableViewController = segue.destinationViewController;
        staticPictureTableViewController.delegate = self;
    }
}

# pragma mark StaticPictureTableViewControllerDelegate methods
- (void) tableViewDidSelectPictureAtIndex: (int)index{
    UIImage *image = [UIImage imageNamed:[[(AppDelegate *)[[UIApplication sharedApplication] delegate] staticPictures] objectAtIndex:index]];
    
    
    if (self.captureManager) {
        self.captureManager = nil;
    }
    self.isCapturingGame = YES;
    
    
    self.backgroundImageView.image = image;
    
    CGFloat newHeight = self.containerView.frame.size.height * (image.size.width / self.containerView.frame.size.width);
    CGFloat heightDifference = (image.size.height - newHeight) / 2.0f;
    CGRect croppingRect = CGRectMake(0, heightDifference, image.size.width, newHeight);
    
    // Get a cropped image with the aspect ration same as the containerViewController
    UIImage *croppedImage = [image cropImageInFrame:croppingRect];
    image = croppedImage;
    
    CGFloat ratio = (image.size.width / self.containerView.frame.size.width);
    CGRect gridCropFrame = CGRectMake(self.gridView.frame.origin.x * ratio, (self.gridView.frame.origin.y * ratio), self.gridView.frame.size.width * ratio, self.gridView.frame.size.height * ratio);
    
    self.capturedImage =  [image cropImageInFrame:gridCropFrame];
    self.checkerboardImageView.image = self.capturedImage   ;
    [self.checkerboardImageView setContentMode:UIViewContentModeScaleAspectFit];
    self.checkerboardImageView.layer.borderWidth = 3.0f;
    self.checkerboardImageView.layer.borderColor = [UIColor redColor].CGColor;
    self.checkerboardImageView.hidden = NO;
    self.captureManager = nil;
    
    [self generateCheckerObjects];
}
@end
