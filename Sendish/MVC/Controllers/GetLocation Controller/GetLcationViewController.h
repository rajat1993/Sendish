//
//  GetLcationViewController.h
//  Sendish
//
//  Created by Rajat Sharma on 03/01/15.
//  Copyright (c) 2015 Rajat Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface GetLcationViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locMgr;
@property (weak, nonatomic) IBOutlet UIButton *Btn_getLocation;

- (IBAction)Action_getLocation:(id)sender;

@end
