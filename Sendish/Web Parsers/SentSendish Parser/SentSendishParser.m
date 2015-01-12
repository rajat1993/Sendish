//
//  SentSendishParser.m
//  Sendish
//
//  Created by Rajat Sharma on 12/01/15.
//  Copyright (c) 2015 Rajat Sharma. All rights reserved.
//

#import "SentSendishParser.h"
#import "SentSendishModal.h"

@implementation SentSendishParser

-(NSArray *)parseArrForSentSendish : (NSArray *)passedArr
{
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (int i = 0; i < [passedArr count]; i++)
    {
        SentSendishModal *sentSendishObj = [[SentSendishModal alloc] init];
        
        sentSendishObj.sentSendish_city = [[passedArr objectAtIndex:i] valueForKey:@"city"];
        sentSendishObj.sentSendish_cityCount = [[passedArr objectAtIndex:i] valueForKey:@"cityCount"];
        sentSendishObj.sentSendish_commentCount = [[passedArr objectAtIndex:i] valueForKey:@"commentCount"];
        sentSendishObj.sentSendish_country = [[passedArr objectAtIndex:i] valueForKey:@"country"];
        sentSendishObj.sentSendish_description = [[passedArr objectAtIndex:i] valueForKey:@"description"];
        sentSendishObj.sentSendish_imgUniqueId = [[passedArr objectAtIndex:i] valueForKey:@"imgUuid"];
        sentSendishObj.sentSendish_likeCount = [[passedArr objectAtIndex:i] valueForKey:@"likeCount"];
        sentSendishObj.sentSendish_timeAgo = [[[passedArr objectAtIndex:i] valueForKey:@"timeAgo"] stringByReplacingOccurrencesOfString:@" ago" withString:@""];
        sentSendishObj.sentSendish_userId = [[passedArr objectAtIndex:i] valueForKey:@"id"];
        
        [tempArr addObject:sentSendishObj];
    }
    
    return tempArr;
}

@end
