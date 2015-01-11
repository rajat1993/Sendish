//
//  IOSRequest.m
//  Greetzly
//
//  Created by Pargat Dhillon on 22/08/14.
//  Copyright (c) 2014 Code Brew Labs. All rights reserved.
//

#import "IOSRequest.h"
#import "UserAccount.h"

@implementation IOSRequest

+(void)fetchWebData : (NSString *)url success: (void (^)(NSDictionary *responseDict))success failure: (void (^)(NSError *error))failure
{
    UserAccount *userObj = [[UserAccount alloc] init];
    
    NSMutableURLRequest *urlReq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlReq setValue:userObj.authToken forHTTPHeaderField:userObj.authHeader];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlReq];
//    operation.responseSerializer = [AFHTTPResponseSerializer serializer];

    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    operation.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];
    [operation start];
    
    }


+(void)uploadData : (NSString *)url parameters:(NSDictionary *)dparameters imageData:(NSData *)dimageData  success: (void (^) (NSDictionary *responseStr))success failure: (void (^) (NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *op = [manager POST:url parameters:dparameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:dimageData name:@"pic" fileName:@"photo11.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op start];
}

+(void)uploadData : (NSString *)url parameters:(NSDictionary *)dparameters videoData:(NSData *)dVideoData  success: (void (^) (NSDictionary *responseStr))success failure: (void (^) (NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestOperation *op = [manager POST:url parameters:dparameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
                
        [formData appendPartWithFileData:dVideoData name:@"video" fileName:@"video.mp4" mimeType:@"video/mp4"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];
    //op.responseSerializer = [AFHTTPResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op start];
}

+(void)postRequest : (NSString *)url parameters:(NSDictionary *)dparameters  success: (void (^) (NSDictionary *responseStr))success failure: (void (^) (NSError *error))failure

{
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:z]];
//    [request setCachePolicy:NSURLCacheStorageNotAllowed];
//    NSString *body = [params JSONRepresentation];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    [request setHTTPMethod:@"POST"];
//    return [JFDownload performRequest:request withFinishTarget:target andFinishSelector:selector startImmediately:YES];

    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    AFHTTPRequestOperation *op = [manager POST:url parameters:dparameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject)
                                  
                                  {
                                      
                                      NSError* error = nil;
                                      
                                      
                                      
                                      
                                      
                                      success([NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error]);
                                      
                                      
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      
                                      
                                      
                                      failure(error);
                                      
                                  }];
    
    [op start];
    
    
    
}

+(void)uploadData : (NSString *)url parameters:(NSDictionary *)dparameters imageData:(NSArray *)imageArr videoData:(NSArray *)videoArr success: (void (^) (NSDictionary *responseStr))success failure: (void (^) (NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer.timeoutInterval = 60;
    
    AFHTTPRequestOperation *op = [manager POST:url parameters:dparameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        
        for (int i = 0; i < [imageArr count]; i++)
        {
            [formData appendPartWithFileData:[imageArr objectAtIndex:i] name:@"cliquein_pic" fileName:[NSString stringWithFormat:@"photo%d.jpg",i] mimeType:@"image/jpeg"];
        }
        for (int i = 0; i < [videoArr count]; i++)
        {
            [formData appendPartWithFileData:[videoArr objectAtIndex:i] name:@"cliquein_video" fileName:[NSString stringWithFormat:@"video%d.mp4",i] mimeType:@"video/mp4"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];
    //op.responseSerializer = [AFHTTPResponseSerializer serializer];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [op start];
}


///////////////////////////////////////////////////////////////////////////////////////////



+(void)postRequestForregister : (NSString *)url andParmas : (NSDictionary *)params success: (void (^) (NSDictionary *responseStr))success failure: (void (^) (NSError *error))failure
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
  //  [request setTimeoutInterval:600];
    [request setHTTPMethod:@"POST"];
//    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)executionsData.length] forHTTPHeaderField:@"Content-Length"];
    
    NSError *error = nil;
    
    NSData *executionsData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];

    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:executionsData];
//    [request setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* resultsDict   = (NSDictionary*)responseObject;
        NSLog(@"%@", resultsDict);
        //process result json dictionary
        
        //success
        //success([NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure
        NSLog(@"Error:%@",error);
        failure(error);
    }];

    [op start];
}

+(void)makeFacebookLogin : (NSString *)url success: (void (^) (NSDictionary *responseStr))success failure: (void (^) (NSError *error))failure
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

    [request setHTTPMethod:@"POST"];

}


@end
