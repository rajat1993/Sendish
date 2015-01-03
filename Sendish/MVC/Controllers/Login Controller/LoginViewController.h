//
//  LoginViewController.h
//  Sendish
//
//  Created by Rajat Sharma on 29/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *TF_loginEmail;
@property (weak, nonatomic) IBOutlet UITextField *TF_loginPassword;

- (IBAction)Action_fbLogin:(id)sender;
- (IBAction)Action_forgotPassword:(id)sender;
- (IBAction)Action_Done:(id)sender;

@end
