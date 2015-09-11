//
//  Service.m
//  Tinder
//
//  Created by Rahul Sharma on 04/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "Service.h"
#import "AppConstants.h"
#import "TinderSericeUtils.h"

@implementation Service

+(NSURL*)getURLForMethod:(NSString*)method
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, method]];
}

+(NSMutableURLRequest*)createURLRequestFor:(NSString*)method withData:(NSData*)postData
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[self getURLForMethod:method]];
     
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    if ([method isEqualToString:MethodUploadImage]) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    else {

        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    }
    
    return request;
}

+(NSMutableURLRequest *)parseMethod:(NSString*)method withParams:(NSDictionary *)params
{
    NSString *strRequestParm = [TinderSericeUtils paramDictionaryToString:params];
    
    NSData *postData = [strRequestParm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [self createURLRequestFor:method withData:postData];
    
    return request;

}


+(NSMutableURLRequest *)parseLogin :(NSDictionary *)params
{
    NSString *strRequestParm = [TinderSericeUtils paramDictionaryToString:params];

    NSData *postData = [strRequestParm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [self createURLRequestFor:MethodLogin withData:postData];
    
    return request;

  
}

+(NSMutableURLRequest *)parseUploadImages :(NSDictionary *)params
{
    NSString *strRequestParm = [TinderSericeUtils paramDictionaryToString:params];

    NSData *postData = [[strRequestParm stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [self createURLRequestFor:MethodUploadImage withData:postData];
    [request addValue:strRequestParm forHTTPHeaderField: @"Content-Type"];
    
    return request;

}

+(NSMutableURLRequest *)parseGetUserProfile :(NSDictionary *)params{
    
    NSString *strRequestParm = [TinderSericeUtils paramDictionaryToString:params];

    NSData *postData = [strRequestParm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [self createURLRequestFor:MethodGetProfile withData:postData];
    
    return request;
   
}

+(NSMutableURLRequest *)parseGetUpdatePrefrences :(NSDictionary *)params{

    NSString *strRequestParm = [TinderSericeUtils paramDictionaryToString:params];
    
    NSData *postData = [strRequestParm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [self createURLRequestFor:MethodUpdatePreferences withData:postData];
    
    return request;
   
}
+(NSMutableURLRequest *)parseLogOut :(NSDictionary *)params{
    
    NSString *strRequestParm = [TinderSericeUtils paramDictionaryToString:params];
    
    NSData *postData = [strRequestParm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [self createURLRequestFor:MethodLogout withData:postData];
    
    return request;
    
}
+(NSMutableURLRequest *)parseDeleteAccount :(NSDictionary *)params{
    
    NSString *strRequestParm = [TinderSericeUtils paramDictionaryToString:params];
    
    NSData *postData = [strRequestParm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [self createURLRequestFor:MethodDeleteAccount withData:postData];
    
    return request;
    
}

+(NSMutableURLRequest *)parseEditProfile :(NSDictionary *)params{
    
    NSString *strRequestParm = [TinderSericeUtils paramDictionaryToString:params];
    
    NSData *postData = [strRequestParm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [self createURLRequestFor:MethodEditProfile withData:postData];
    
    return request;
    
}

+(NSMutableURLRequest *)parseGetFindMatches :(NSDictionary *)params
{
    
    NSString *strRequestParm = [TinderSericeUtils paramDictionaryToString:params];

    NSData *postData = [strRequestParm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [self createURLRequestFor:MethodFindMatches withData:postData];
    
    return request;
    
}

+(NSMutableURLRequest *)parseUpdateLocation :(NSDictionary *)params
{
    
    NSString *strRequestParm = [TinderSericeUtils paramDictionaryToString:params];
    
    NSData *postData = [strRequestParm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [self createURLRequestFor:MethodUpdateLocation withData:postData];
    
    return request;
}

+(NSMutableURLRequest *)parseInviteAction :(NSDictionary *)params
{
    
    NSString *strRequestParm = [TinderSericeUtils paramDictionaryToString:params];
    
    NSData *postData = [strRequestParm dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [self createURLRequestFor:MethodInviteAction withData:postData];
    
    return request;
}


@end
