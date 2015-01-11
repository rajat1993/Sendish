//
//  TakeSendishViewController.h
//  Sendish
//
//  Created by Rajat Sharma on 30/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface TakeSendishViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_captured;
@property (weak, nonatomic) IBOutlet UIView *flashView;
@property (weak, nonatomic) IBOutlet UIButton *Btn_flash;
@property (weak, nonatomic) IBOutlet UIButton *Btn_description;
@property (weak, nonatomic) IBOutlet UIButton *Btn_takePhoto;
@property (weak, nonatomic) IBOutlet UIButton *Btn_rotateCamera;


- (IBAction)Action_toggleFlash:(id)sender;
- (IBAction)Action_captureImage:(id)sender;
- (IBAction)Action_rotateCamera:(id)sender;

- (IBAction)Action_ON:(id)sender;
- (IBAction)Action_OFF:(id)sender;
- (IBAction)Action_AUTO:(id)sender;
- (IBAction)Action_description:(id)sender;




@end
