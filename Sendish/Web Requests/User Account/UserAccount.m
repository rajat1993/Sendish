//
//  UserAccount.m
//  Sendish
//
//  Created by Rajat Sharma on 05/01/15.
//  Copyright (c) 2015 Rajat Sharma. All rights reserved.
//

#import "UserAccount.h"

@implementation UserAccount

+(UserAccount *)sharedInstance
{
    static UserAccount* _sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[UserAccount alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    if ((self = [super init]) == nil) {
        return nil;
    }
    
    return self;
}

-(void)invalidate
{
    self.authHeader = nil;
    self.authToken = nil;
    self.accountType = nil;
    self.name = nil;
    self.imageUrl = nil;
    self.nickName = nil;
}

@end
