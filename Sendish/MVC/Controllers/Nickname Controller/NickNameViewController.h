//
//  NickNameViewController.h
//  Sendish
//
//  Created by Rajat Sharma on 03/01/15.
//  Copyright (c) 2015 Rajat Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NickNameViewController : UIViewController

@property (nonatomic,strong) CLLocation *currentUserLocation;

@property (weak, nonatomic) IBOutlet UITextField *TF_nickName;

- (IBAction)Action_getStarted:(id)sender;

@end
