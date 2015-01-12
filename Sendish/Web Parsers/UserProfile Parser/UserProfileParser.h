//
//  UserProfileParser.h
//  Sendish
//
//  Created by Rajat Sharma on 12/01/15.
//  Copyright (c) 2015 Rajat Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfileParser : NSObject

-(NSDictionary *)parseUserData : (NSDictionary *)passedDict;

@end
