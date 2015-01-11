//
//  UserAccount.h
//  Sendish
//
//  Created by Rajat Sharma on 05/01/15.
//  Copyright (c) 2015 Rajat Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAccount : NSObject

+(UserAccount *)sharedInstance;

@property (nonatomic,strong) NSString *authToken;
@property (nonatomic,strong) NSString *authHeader;
@property (nonatomic,strong) NSString *accountType;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *nickName;

-(void)invalidate;

@end
