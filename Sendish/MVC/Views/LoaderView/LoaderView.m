//
//  LoaderView.m
//  PokerGameApp
//
//  Created by HeLLs GAtE on 12/09/14.
//  Copyright (c) 2014 CodeBrew. All rights reserved.
//

#import "LoaderView.h"

@implementation LoaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"LoaderView" owner:self options:nil] lastObject];
        [self setFrame:frame];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - Animating Views

-(void)startAnimating
{
    [self runSpinAnimationOnView:self.loaderImgView duration:3 rotations:0.75 repeat:100];
}

-(void)stopAnimating
{
    [self removeFromSuperview];
}


- (void) runSpinAnimationOnView:(UIImageView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
