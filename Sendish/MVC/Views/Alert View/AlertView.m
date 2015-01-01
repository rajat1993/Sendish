//
//  AlertView.m
//  CliqueIn
//
//  Created by CB Macmini_2 on 21/11/14.
//  Copyright (c) 2014 CB Macmini_2. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self setFrame:frame];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)showStaticAlertWithTitle : (NSString *)title AndMessage : (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


@end
