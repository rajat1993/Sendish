//
//  IOSRequest.h
//  Greetzly
//
//  Created by Pargat Dhillon on 22/08/14.
//  Copyright (c) 2014 Code Brew Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface IOSRequest : NSObject

+(void)fetchWebData : (NSString *)url success: (void (^)(NSDictionary *responseDict))success failure: (void (^)(NSError *error))failure;

+(void)postRequestForregister : (NSString *)url andParmas : (NSDictionary *)params success: (void (^) (NSDictionary *responseStr))success failure: (void (^) (NSError *error))failure;

@end
