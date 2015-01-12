//
//  TakeSendishViewController.m
//  Sendish
//
//  Created by Rajat Sharma on 30/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import "TakeSendishViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "Constants.h"
#import "UserAccount.h"
#import "UIImage+Extras.h"

@interface TakeSendishViewController ()

@property UIView *blurView;

@property AVCaptureSession *session;
@property AVCaptureVideoPreviewLayer *previewLayer;
@property AVCaptureStillImageOutput *stillImageOutput;
@property AVCaptureDevice *device;

@property int success;
@property (nonatomic,strong) NSURLConnection *urlConn;
@property (nonatomic,retain) NSMutableData *mutData;

@property AlertView *alertObj;
@property LoaderView *loaderObj;

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
    
    [self getCurrentLocation];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSelectorOnMainThread:@selector(setupCameraView) withObject:nil waitUntilDone:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    @try
    {
        [self.previewLayer removeFromSuperlayer];
        [self.session stopRunning];
        self.session = nil;

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
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

-(void)setupCameraView
{
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    self.previewLayer.frame = self.cameraView.bounds;
    
    [self.cameraView.layer addSublayer:self.previewLayer];
    
    NSArray *possibleDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];

    self.device = [possibleDevices firstObject];
    
    NSError *error = nil;

    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        
        [self performSelectorInBackground:@selector(addInput:) withObject:input];
        //[self.session addInput:input];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
                    //return to main thread
        
            
                    
        });

    });
    
 //   [self.session addInput:input];

    self.stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [self.session addOutput:self.stillImageOutput];
    
    [self.session startRunning];
}

-(void)addInput : (AVCaptureDeviceInput *)input
{
    [self.session addInput:input];
}

#pragma mark - Alert Delegate Methods

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if ([[[alertView textFieldAtIndex:0] text] length] == 0)
    {
        return NO;
    }
    
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.Btn_description setTitle:[[alertView textFieldAtIndex:0] text] forState:UIControlStateNormal];
    }
}

#pragma mark - Get Current Location

-(void)getCurrentLocation
{
    self.locMgr = [[CLLocationManager alloc] init];
    self.locMgr.delegate = self;
    
    if ([self.locMgr respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locMgr requestWhenInUseAuthorization];
    }
    
    [self.locMgr startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.alertObj = [[AlertView alloc] init];
    
    [self.alertObj showStaticAlertWithTitle:@"" AndMessage:error.localizedDescription];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locMgr stopUpdatingLocation];
    self.locMgr.delegate = nil;
    
    self.currentLocation = [locations lastObject];
    
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    
    [reverseGeocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error){

             return;
         }
         
         CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
         NSString *countryName = myPlacemark.country;

         NSString *cityName = [myPlacemark.addressDictionary valueForKey:@"City"];
          
         self.Label_place.text = [NSString stringWithFormat:@"   %@, %@", cityName, countryName];
     }];
}

#pragma mark - Loader Setup

-(void)setUpLoaderView
{
    AppDelegate *appDelObj = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.loaderObj = [[LoaderView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.loaderObj startAnimating];
    [appDelObj.window addSubview:self.loaderObj];
    [appDelObj.window bringSubviewToFront:self.loaderObj];
}


#pragma mark - Button Actions

- (IBAction)Action_toggleFlash:(id)sender
{
    self.alertObj = [[AlertView alloc] init];
    
    if(![self.device hasFlash])
    {
        [self.alertObj showStaticAlertWithTitle:@"" AndMessage:@"Flash not available"];
        return;
    }
    
    if(self.flashView.hidden)
    {
        [self.flashView setHidden:NO];
    }
    else
    {
        [self.flashView setHidden:YES];
    }
}

- (IBAction)Action_captureImage:(id)sender
{
    self.alertObj = [[AlertView alloc] init];
    
    if ([[self.Btn_takePhoto.titleLabel.text lowercaseString] isEqualToString:@"send"])
    {
        if ([[self.Btn_description.titleLabel.text lowercaseString] isEqualToString:@"tap to add description"])
        {
            [self.alertObj showStaticAlertWithTitle:@"" AndMessage:@"Please add a description for this sendish."];
            return;
        }
        
        NSString *urlStr = [BasePath stringByAppendingString:SendSendish];
        
        NSDictionary *params = @{@"latitude" : [NSString stringWithFormat:@"%.8f", self.currentLocation.coordinate.latitude], @"longitude" : [NSString stringWithFormat:@"%.8f", self.currentLocation.coordinate.longitude], @"description" : self.Btn_description.titleLabel.text};
        
        [self setUpLoaderView];
        [self callWebService:urlStr AndParmas:params];
    }
    else
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
                    captureImage = [captureImage imageByScalingAndCroppingForSize:CGSizeMake(640, 640)];
                    
                    self.imgView_captured.image = captureImage;
                    
                    [self.cameraView setHidden:YES];
                    [self.imgView_captured setHidden:NO];
                    
                    [self.Btn_description setHidden:NO];
                    [self.Btn_flash setHidden:YES];
                    [self.flashView setHidden:YES];
                    
                    [self.Btn_rotateCamera setTitle:@"Cancel" forState:UIControlStateNormal];
                    [self.Btn_takePhoto setTitle:@"Send" forState:UIControlStateNormal];
                    
                    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                    
                    [library saveImage:captureImage toAlbum:@"SENDISH" withCompletionBlock:^(NSError *error) {
                        
                        if(error)
                        {
                            [self.alertObj showStaticAlertWithTitle:@"" AndMessage:@"Unable to save photo at this time.\nPlease try again later."];
                        }
                    }];
                }
                
            }];
            
        }

    }
}

- (IBAction)Action_rotateCamera:(id)sender
{
    if ([[self.Btn_rotateCamera.titleLabel.text lowercaseString] isEqualToString:@"cancel"])
    {
        self.cameraView.hidden = NO;
        [self.Btn_flash setHidden:NO];
        
        [self.Btn_takePhoto setTitle:@"Take" forState:UIControlStateNormal];
        [self.Btn_rotateCamera setTitle:@"Rotate" forState:UIControlStateNormal];
        
        self.imgView_captured.hidden = YES;
        [self.Btn_description setHidden:YES];
    }
    else
    {
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        
        if([devices count] <= 1)
        {
            return;
        }
        
        NSArray *possibleDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDeviceInput *input in [self.session inputs])
        {
            [self.session removeInput:input];
        }
        
        //    CATransition *animation = [CATransition animation];
        //    animation.duration = .75f;
        //    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //    animation.type = @"oglFlip";
        //    animation.delegate = self;
        
        NSError *error = nil;
        
        // Set torch to on
        if([self.device position] == AVCaptureDevicePositionBack)
        {
            
            //        animation.subtype = kCATransitionFromLeft;
            
            self.device = [possibleDevices objectAtIndex:1];
            
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
            if (!input) {
                // Handle the error appropriately.
                NSLog(@"ERROR: trying to open camera: %@", error);
            }
            
            [self.session addInput:input];
            
        }
        else
        {
            //        animation.subtype = kCATransitionFromRight;
            
            self.device = [possibleDevices objectAtIndex:0];
            
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
            if (!input) {
                // Handle the error appropriately.
                NSLog(@"ERROR: trying to open camera: %@", error);
            }
            
            [self.session addInput:input];
        }
        
        //    [self.previewLayer addAnimation:animation forKey:nil];

    }

}

- (IBAction)Action_ON:(id)sender
{
    if(self.device.torchMode == AVCaptureTorchModeOn)
    {
        [self.flashView setHidden:YES];
        return;
    }
    
    [self setFlashModeTo:@"ON"];
}

- (IBAction)Action_OFF:(id)sender
{
    if(self.device.torchMode == AVCaptureTorchModeOn)
    {
        return;
    }
    
    [self setFlashModeTo:@"OFF"];
}

- (IBAction)Action_AUTO:(id)sender
{
    if(self.device.torchMode == AVCaptureTorchModeOn)
    {
        return;
    }
    
    [self setFlashModeTo:@"AUTO"];
}

- (IBAction)Action_description:(id)sender
{
    UIAlertView *alert_description = [[UIAlertView alloc] initWithTitle:@"" message:@"Enter a short description for this sendish." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    [alert_description setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert_description show];
}

#pragma mark - Flash Methods

-(void)setFlashModeTo : (NSString *)mode
{
    [self.session beginConfiguration];
    [self.device lockForConfiguration:nil];
    
    if([mode isEqualToString:@"ON"])
    {
        [self.device setTorchMode:AVCaptureTorchModeOn];
    }
    else if ([mode isEqualToString:@"OFF"])
    {
        [self.device setTorchMode:AVCaptureTorchModeOff];
    }
    else
    {
        [self.device setTorchMode:AVCaptureTorchModeAuto];
    }
    
    [self.device unlockForConfiguration];
    [self.session commitConfiguration];
    
    [self.Btn_flash setTitle:mode forState:UIControlStateNormal];
    [self.flashView setHidden:YES];
}

#pragma mark - Transition Methods

-(void)animationDidStart:(CAAnimation *)anim
{
    [self addBlurToView:self.cameraView];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.blurView removeFromSuperview];
}

#pragma mark - Blur effect 

- (void)addBlurToView:(UIView *)view {
    self.blurView = nil;
    
    if([UIBlurEffect class]) { // iOS 8
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.blurView.frame = self.previewLayer.frame;
        
    } else { // workaround for iOS 7
        self.blurView = [[UIToolbar alloc] initWithFrame:view.bounds];
    }
    
    [self.blurView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [view addSubview:self.blurView];
}

#pragma mark - WebService Methods

-(void)callWebService : (NSString *)urlStr AndParmas : (NSDictionary *)params
{
    self.mutData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlReq = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlReq setHTTPMethod:@"POST"];

    NSString *boundary = @"---------------SendishBoundary111";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [urlReq setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [urlReq addValue:[[UserAccount sharedInstance] authToken] forHTTPHeaderField:[[UserAccount sharedInstance] authHeader]];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    NSData *imageData = UIImageJPEGRepresentation(self.imgView_captured.image, 1.0);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"image"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [urlReq setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [urlReq setValue:postLength forHTTPHeaderField:@"Content-Length"];
    

    self.urlConn = [[NSURLConnection alloc] initWithRequest:urlReq delegate:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.alertObj = [[AlertView alloc] init];
    
    [self.loaderObj performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    [self.alertObj showStaticAlertWithTitle:@"" AndMessage:@"Error connecting to server.\nPlease try again later"];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    self.alertObj = [[AlertView alloc] init];
    
    [self.mutData setLength:0];
    
    if ([response statusCode] == 201)
    {
        self.success = 1;
    }
    else
    {
        self.success = 0;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.mutData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.loaderObj performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    
    self.alertObj = [[AlertView alloc] init];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.mutData options:NSJSONReadingMutableLeaves error:nil];
    
    if (self.success == 0)
    {
        [self.alertObj showStaticAlertWithTitle:@"" AndMessage:[[dict valueForKeyPath:@"errors.image"] objectAtIndex:0]];
    }
    else
    {
        [self.alertObj showStaticAlertWithTitle:@"Success" AndMessage:@"Sendish Sent."];
        [self.Btn_rotateCamera setTitle:@"Rotate" forState:UIControlStateNormal];
        [self Action_rotateCamera:self];
    }
    
    NSLog(@"%@",dict);
}

@end
