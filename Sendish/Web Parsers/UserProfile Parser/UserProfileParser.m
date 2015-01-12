//
//  UserProfileParser.m
//  Sendish
//
//  Created by Rajat Sharma on 12/01/15.
//  Copyright (c) 2015 Rajat Sharma. All rights reserved.
//

#import "UserProfileParser.h"
#import "UserModal.h"

@implementation UserProfileParser

-(NSDictionary *)parseUserData : (NSDictionary *)passedDict
{
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];

    UserModal *userModalObj = [[UserModal alloc] init];
    
    userModalObj.user_citiesCount = [NSString stringWithFormat:@"%@", [passedDict valueForKey:@"citiesCount"]];
    userModalObj.user_emailRegistration = [NSString stringWithFormat:@"%@", [passedDict valueForKey:@"emailRegistration"]];
    userModalObj.user_id = [NSString stringWithFormat:@"%@", [passedDict valueForKey:@"id"]];
    userModalObj.user_lastLat = [NSString stringWithFormat:@"%@", [passedDict valueForKey:@"lastLat"]];
    userModalObj.user_lastLng = [NSString stringWithFormat:@"%@", [passedDict valueForKey:@"lastLng"]];
    userModalObj.user_lastLocationTime = [NSString stringWithFormat:@"%@", [passedDict valueForKey:@"lastLocationTime"]];
    userModalObj.user_lastPlace = [NSString stringWithFormat:@"%@", [passedDict valueForKey:@"lastPlace"]];
    userModalObj.user_nickName = [NSString stringWithFormat:@"%@", [passedDict valueForKey:@"nick"]];
    userModalObj.user_rank = [NSString stringWithFormat:@"%@", [passedDict valueForKey:@"rank"]];
    userModalObj.user_totalDislikes = [NSString stringWithFormat:@"%@", [passedDict valueForKey:@"totalDislikes"]];
    userModalObj.user_totalLikes = [NSString stringWithFormat:@"%@", [passedDict valueForKey:@"totalLikes"]];
    
    
    
    [tempDict setObject:userModalObj.user_citiesCount forKey:@"citiescount"];
    [tempDict setObject:userModalObj.user_emailRegistration forKey:@"emailRegistration"];
    [tempDict setObject:userModalObj.user_id forKey:@"id"];
    [tempDict setObject:userModalObj.user_lastLat forKey:@"lastLat"];
    [tempDict setObject:userModalObj.user_lastLng forKey:@"lastLng"];
    [tempDict setObject:userModalObj.user_lastLocationTime forKey:@"lastLocationTime"];
    [tempDict setObject:userModalObj.user_lastPlace forKey:@"lastPlace"];
    [tempDict setObject:userModalObj.user_nickName forKey:@"nick"];
    [tempDict setObject:userModalObj.user_rank forKey:@"rank"];
    [tempDict setObject:userModalObj.user_totalDislikes forKey:@"totalDislikes"];
    [tempDict setObject:userModalObj.user_totalLikes forKey:@"totalLikes"];
    
    
    return tempDict;
}

@end
