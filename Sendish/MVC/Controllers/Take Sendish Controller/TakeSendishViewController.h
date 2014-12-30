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

@interface TakeSendishViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_captured;


- (IBAction)Action_toggleFlash:(id)sender;
- (IBAction)Action_captureImage:(id)sender;
- (IBAction)Action_rotateCamera:(id)sender;

@end
