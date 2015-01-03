//
//  LoaderView.h
//  PokerGameApp
//
//  Created by HeLLs GAtE on 12/09/14.
//  Copyright (c) 2014 CodeBrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoaderView : UIView

-(void)startAnimating ;
-(void)stopAnimating ;



@property (strong, nonatomic) IBOutlet UIImageView *loaderImgView;

@end
