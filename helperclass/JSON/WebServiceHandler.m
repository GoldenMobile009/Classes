//
//  WebServiceHandler.m
//  HairToDo
//
//  Created by Sahil Khanna on 11/2/11.
//  Copyright 2011 3Embed. All rights reserved.
//

#import "WebServiceHandler.h"
#import "JSONParser.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"

#import "AppConstants.h"


#define HOST @"http://108.166.190.172:81/tinderClone/"



enum serviceType {
    MatchedProfile = 1,
    SendMessage = 2,
    GetMessage = 3,
    BlockUSer =4,
    UnBlockUser
};
@implementation WebServiceHandler

@synthesize requestType;
@synthesize delegate;

#pragma mark -
#pragma mark Connection Delegate


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    id result;
    timeOut = nil;
	JSONParser *parser = [[JSONParser alloc] init];
	//NSArray *array = nil;
	
    if (self.requestType== eParseKey)
	{
		result = [parser dictionaryWithContentsOfJSONURLString:responseData];
		
	}
    
    
    
    
 	//NSLog(@"array %@",array);
	
	
	if ([result count]==0) {
		[target performSelectorOnMainThread:selector withObject:nil waitUntilDone:YES];
	}
	else {
		[target performSelectorOnMainThread:selector withObject:[NSDictionary dictionaryWithObject:result forKey:@"ItemsList"] waitUntilDone:YES];
	}
    
	
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
   
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
   
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    timeOut = nil;
	
	[target performSelectorOnMainThread:selector withObject:[NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"Error"] waitUntilDone:NO];
}

#pragma mark -
#pragma mark Other Methods
- (void)placeWebserviceRequestWithString:(NSMutableURLRequest *)string Target:(id)_target Selector:(SEL)_selector {
    
    NSLog(@"url %@",string);
	urlConnection = [[NSURLConnection alloc] initWithRequest:string delegate:self];
	timeOut = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(cancelDownload) userInfo:nil repeats:NO];
	responseData = [[NSMutableData alloc] init];
	target = _target;
	selector = _selector;
}

- (void) cancelDownload
{
	if (timeOut == nil) {
		return;
	}
	else {
		[urlConnection cancel];
		[target performSelectorOnMainThread:selector withObject:[NSDictionary dictionaryWithObject:@"Connection Timed-out" forKey:@"Error"] waitUntilDone:NO];
		timeOut = nil;
	}
	
}

- (void)webserviceRequestAndResponse:(NSString *)stringMessage serviceType:(int)service facebookId:(NSString *)fId
{
   
   
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HOST]];
    
    [[httpClient operationQueue] cancelAllOperations];
    
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",HOST]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString * strUUID = nil;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        strUUID = [oNSUUID UUIDString];
    } else {
        strUUID = [oNSUUID UUIDString];
        
    }
   
        
    NSDictionary *parameters = nil;
    NSString *serviceString = nil;
    switch (service) {
        case MatchedProfile:{
            serviceString = @"getProfileMatches";
            // NSString *currentDate = [Helper getCurrentTime];
            NSLog(@"Joined before modify :%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"JOINED"]);
            NSString *strTime=[[NSUserDefaults standardUserDefaults] objectForKey:@"JOINED"];
            if(strTime==nil)
            {
                strTime=@"";
            }
            parameters = @{@"ent_sess_token":[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN"], @"ent_dev_id":strUUID,@"ent_datetime":strTime};
            NSLog(@"%@",parameters);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            
            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            [dateFormatter setTimeZone:gmt];
             NSString *timeStamp = [dateFormatter stringFromDate:[NSDate date]];
            
            [[NSUserDefaults standardUserDefaults]setObject:timeStamp forKey:@"JOINED"];
             NSLog(@"Joined before modify :%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"JOINED"]);
            break;
        }
        case SendMessage:{
            serviceString = @"sendMessage";
            parameters = @{@"ent_sess_token":[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN"], @"ent_dev_id":strUUID,@"ent_user_fbid":fId,@"ent_message":stringMessage};
            
            break;
        }
        case GetMessage:{
            serviceString = @"getChatHistory";
            parameters = @{@"ent_sess_token":[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN"], @"ent_dev_id":strUUID,@"ent_user_fbid":fId,@"ent_chat_page":@"1"};
            
            break;
        }
        case BlockUSer:{
            serviceString = @"blockUser";
            parameters = @{@"ent_sess_token":[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN"], @"ent_dev_id":strUUID,@"ent_user_fbid":fId,@"ent_flag":@"4"};
            break;
        }
        case UnBlockUser:{
            serviceString = @"blockUser";
            parameters = @{@"ent_sess_token":[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN"], @"ent_dev_id":strUUID,@"ent_user_fbid":fId,@"ent_flag":@"3"};
            break;
        }
        default:
            break;
    }
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    [client postPath:[NSString stringWithFormat:@"%@%@",BASE_URL,serviceString]
          parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 
                 NSLog(@"response :%@",responseObject);
                 
                 if ([delegate respondsToSelector:@selector(getServiceResponseDelegate:serviceType:error:)]) {
                      [delegate getServiceResponseDelegate:responseObject serviceType:service error:nil];
                 }
                 //[delegate sendMessageResponseDelegate:responseObject error:nil];
                
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Error :%@",error);
                 // [delegate sendMessageResponseDelegate:nil error:error];
                 [delegate getServiceResponseDelegate:nil serviceType:service error:error];
                 //[pi hideProgressIndicator];
//                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                              message:[NSString stringWithFormat:@"%@",error]
//                                                             delegate:nil
//                                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                 [av show];
                 
             }
     ];
    
   

}





@end
