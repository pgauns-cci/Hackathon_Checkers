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
#import "GridView.h"
#import "Checker.h"
#import "Common.h"

@interface CaptureGameViewController ()

// Properties
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
                                                                max_radius:40.0];
    NSLog(@"CaptureGameViewController - checkerCircles count : %d", [arrayOfCheckerCircles count]);
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

- (CaptureSessionManager *)captureManager {
    if (!_captureManager) {
        _captureManager = [[CaptureSessionManager alloc] init];
    }
    return _captureManager;
}

#pragma mark - Custom Setters

- (void)setIsCapturingGame:(BOOL)isCapturingGame {
    _isCapturingGame = isCapturingGame;
    if (!_isCapturingGame) {
        
        // Reset Capture Manager
        [self configureCaptureManager];
        self.checkerboardImageView.image = nil;
        self.checkerboardImageView.hidden = YES;
        
        // Change text on the label
        self.infoLabel.text = @"Tap to capture";
    } else {
        // Capture image
        [self saveCapturedImage];
        
        // Change text on the label
        self.infoLabel.text = @"Reset";
    }
}

#pragma mark - IBActions

- (IBAction)handleSingleTapGesture:(id)sender {
    self.isCapturingGame = !self.isCapturingGame;
    
}

- (IBAction)nextButtonTapped:(UIBarButtonItem *)sender {
    [self generateCheckerObjects];
    [self performSegueWithIdentifier:@"GameViewSegue" sender:nil];
}

#pragma mark - Private Methods

- (void)configureCaptureManager {
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
    
    //Hardcorded image
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
    self.capturedImage =  [UIImage imageNamed:@"CheckerBoard_light"];;
    int index = 0;
    CGFloat widthOfImage = self.capturedImage.size.width / 8.0f;
    CGFloat heightOfImage = self.capturedImage.size.height / 8.0f;
    for (int y = 0; y < 8; y++) {
        for (int x = 0; x < 8; x++) {
            Checker *checker = [[Checker alloc] init];
            checker.position = CGPointMake(x, y);
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
}
@end
