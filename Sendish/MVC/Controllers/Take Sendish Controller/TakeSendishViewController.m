//
//  TakeSendishViewController.m
//  Sendish
//
//  Created by Rajat Sharma on 30/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import "TakeSendishViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface TakeSendishViewController ()

@property BOOL isFlashOn;

@property AVCaptureSession *session;
@property AVCaptureStillImageOutput *stillImageOutput;
@property AVCaptureDevice *device;

@end

@implementation TakeSendishViewController

#pragma mark - Internal Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    if([devices count] <= 1)
    {
        [self setupCameraViewWithCamera:1];
    }
    else
    {
        [self setupCameraViewWithCamera:0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Setter Methods

-(void)setupCameraViewWithCamera : (NSInteger)deviceIndex
{
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    
    previewLayer.frame = self.cameraView.bounds;
    
    [self.cameraView.layer addSublayer:previewLayer];
    
    NSArray *possibleDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];

    self.device = [possibleDevices objectAtIndex:deviceIndex];
    
    NSError *error = nil;

    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    
    [self.session addInput:input];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [self.session addOutput:self.stillImageOutput];

    [self.session startRunning];

}


#pragma mark - Button Actions

- (IBAction)Action_toggleFlash:(id)sender
{
    if(![self.device hasFlash])
    {
        return;
    }
    
    if(self.isFlashOn)
    {
        self.isFlashOn = NO;
        
        [self.session beginConfiguration];
        [self.device lockForConfiguration:nil];
        
        // Set torch to on
        [self.device setTorchMode:AVCaptureTorchModeOff];
        
        [self.device unlockForConfiguration];
        [self.session commitConfiguration];
    }
    else
    {
        self.isFlashOn = YES;
        
        [self.session beginConfiguration];
        [self.device lockForConfiguration:nil];
        
        // Set torch to on
        [self.device setTorchMode:AVCaptureTorchModeOn];
        
        [self.device unlockForConfiguration];
        [self.session commitConfiguration];
    }

}

- (IBAction)Action_captureImage:(id)sender
{
    if(self.cameraView.hidden == YES)
    {
        self.cameraView.hidden = NO;
        self.imgView_captured.hidden = YES;
    }
    else
    {
        AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
        
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            
            if (imageDataSampleBuffer != NULL) {
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                
                UIImage *captureImage = [[UIImage alloc] initWithData:imageData];
                
                self.imgView_captured.image = captureImage;
                
                [self.cameraView setHidden:YES];
                [self.imgView_captured setHidden:NO];
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                
                [library saveImage:captureImage toAlbum:@"Sendish" withCompletionBlock:^(NSError *error) {
                    
                    if(error)
                    {
                        
                    }
                }];
            }
            
        }];

    }
}

- (IBAction)Action_rotateCamera:(id)sender
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    if([devices count] <= 1)
    {
        return;
    }
    
    self.session = nil;

    // Set torch to on
    if([self.device position] == AVCaptureDevicePositionBack)
    {
        [self setupCameraViewWithCamera:1];
    }
    else
    {
        [self setupCameraViewWithCamera:0];
    }
    
}

@end
