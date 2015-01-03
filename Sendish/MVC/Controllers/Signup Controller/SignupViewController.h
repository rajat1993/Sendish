//
//  SignupViewController.h
//  Sendish
//
//  Created by Rajat Sharma on 29/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK.h>

@interface SignupViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *TF_fullName;
@property (weak, nonatomic) IBOutlet UITextField *TF_email;
@property (weak, nonatomic) IBOutlet UITextField *TF_password;


- (IBAction)Action_fbSignup:(id)sender;
- (IBAction)Action_Next:(id)sender;

@end
