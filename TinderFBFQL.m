//
//  TinderFBFQL.m
//  Tinder
//
//  Created by Vinay Raja on 07/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "TinderFBFQL.h"
#import "SDWebImageDownloader.h"

@interface TinderFBFQL ()
{
    
}

@end

@implementation TinderFBFQL


+(BOOL)isSessionActive
{
    return FBSession.activeSession.isOpen;
}
+(void)updateFacebookSession {
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        NSLog(@"Cached session found");
        // If there's one, just open the session silently, without showing the user the login UI
        NSArray *permission = @[@"user_photos",@"friends_photos",@"read_stream"];
        [FBSession openActiveSessionWithReadPermissions:permission
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          //[self sessionStateChanged:session state:state error:error];
                                          if (state == FBSessionStateOpen ) {
                                              NSLog(@"session stat open");
                                          }
                                      }];
        
        // If there's no cached session, we will show a login button
    } else {
        
        NSLog(@"Cached session not found");
        
    }
}
+(void)openCreateFBSession:(id<TinderFBFQLDelegate>)delegate
{
    if (!FBSession.activeSession.isOpen) {
        NSLog(@"session is not opened");
        
        NSArray *permission = @[@"user_photos",@"friends_photos",@"read_stream"];
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:permission
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          }
                                      }];
    }
}

#pragma mark- FQL-ProfileImage
+ (void)executeFQlForProfileImage:(id<TinderFBFQLDelegate>)delegate
{
   
    
    NSArray __block *profileImg;
    

   
    // Query to fetch the active user's friends, limit to 25.
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [ud objectForKey:@"FBUSERDETAIL"];
    
    
    
    //    NSString *query =
    //    @"select src from photo  where album_object_id IN "
    //    @"(SELECT  object_id  FROM album WHERE owner='100001766594434' and name='Profile Pictures')";
    
    // backgroundQueue = dispatch_queue_create("com.razeware.imagegrabber.bgqueue", NULL);
    
    NSString *query = [NSString stringWithFormat:@"SELECT src_big from photo  where album_object_id IN (SELECT  object_id  FROM album WHERE owner='%@' and name='Profile Pictures') LIMIT 5",[dict objectForKey:FACEBOOK_ID]];
    
    NSLog(@"query %@",query);
    
    if ([self isSessionActive]) {
        NSLog(@"session active");
        NSLog(@"permission %@",[[FBSession activeSession] permissions]);
    }
    else {
        NSLog(@"session not active");
    }
    
    // Set up the query parameter
    NSDictionary *queryParam = @{ @"q": query };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (error) {
                                  
                                  NSLog(@"Error: %@", [error localizedDescription]);
                                  
                              } else {
                                  NSLog(@"Result: %@ %s", result, __func__);
                                  
                                  
                                  // Get the friend data to display
                                  
                                  profileImg = (NSArray *) result[@"data"];
                                  NSLog(@"fQlimages %@",profileImg);
                                
                                  NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
                                  for(NSDictionary *url in profileImg) {
                                      [imagesArray addObject:url[@"src_big"]];
                                  }
                                  
                                  [self gotImageURLs:imagesArray withDelegate:delegate];
                                
                                  
                              }
                          }];
    
    
}

+(void)gotImageURLs:(NSArray*)imageURLs withDelegate:(id<TinderFBFQLDelegate>)delegate
{
    
    DataBase * da = [DataBase sharedInstance];
    [[DataBase sharedInstance] deleteAllObjectFortable:@"UploadImages"];
    [da performSelectorOnMainThread:@selector(makeDataBaseEntryForUploadImages:) withObject:imageURLs waitUntilDone:YES];
    [delegate performSelector:@selector(uploadImage:) withObject:imageURLs];
    
    
    //NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i<imageURLs.count; i++)
    {
        if (i==0) {
            
             [[DataBase sharedInstance] saveImageToDocumentsDirectoryForLogin :[imageURLs objectAtIndex:i]:i];
            if (i==0) {
               [delegate performSelector:@selector(doneLoadingProfileImage:) withObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"FBPROFILEURL"]];
            }
            
        }
        else{
            [[DataBase sharedInstance] saveImageToDocumentsDirectoryForLogin :[imageURLs objectAtIndex:i]:i];
        }
    
       
        
    }
   
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsUploaded"];
    [delegate performSelector:@selector(doneDownloadingProfileImages) withObject:nil];
    
//    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    int __block count =0;
//    for (int i = 0; i<imageURLs.count; i++) {
//        //  NSDictionary * dict = [imageURLs objectAtIndex:i];
//        NSString * imgpath;//= [NSString stringWithFormat:@"imgpath_%d",i];
//        //  if ([dict objectForKey:@"src_big"]) {
//        //NSArray *imageName = [[dict objectForKey:@"src_big"] componentsSeparatedByString:@"/"];
//        imgpath = [NSString stringWithFormat:@"%@/%d.jpg",docDir,i];
//        NSURL *url = [NSURL URLWithString:[Helper removeWhiteSpaceFromURL:imageURLs[i]]];
//        
//        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:url
//                                                            options:0
//                                                           progress:^(NSUInteger receivedSize, long long expectedSize)
//                                                            {
//                                                                // progression tracking code
//                                                            }
//                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
//          {
//             
//             
//             
//             if (image && finished)
//             {
//                 // do something with image
//                 
//                 data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
//                 
//                if ([data writeToFile:imgpath atomically:YES]) {
//                     
//                    
//                     [TinderFBFQL saveImage:@{@"fb":[url absoluteString], @"local":imgpath}];
//                    
//                    if (count==0) {
//                        
//                        
//                        [delegate performSelector:@selector(doneLoadingProfileImage:) withObject:imgpath];
//                        
//                        
//                        
//                        
//                    }
//                    
//                    
//                     if (count==imageURLs.count-1) {
//                         
//                         [[ProgressIndicator sharedInstance] hideProgressIndicator];
//                         
//                         NSLog(@"countForlastImage %d",count);
//                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsUploaded"];
//                        
//                         [delegate performSelector:@selector(doneDownloadingProfileImages) withObject:nil];
//                         
//                
//                         
//                         
//                          return ;
//                     }
//                   
//                     
//                    count++;
//                    NSLog(@"countForIncrement %d",count);
//                  
//                    
//                }
//                
//             }
//             
//             
//         }];
//        
//        
//        
//    }
    
    
    
    
    
}





+(void)deleteAllObjectFortable:(NSString*)tableName
{
    TinderAppDelegate* appDelegate =(TinderAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:[appDelegate managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray*fetchedObjects = [[appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *fetchedCategorList=[[NSMutableArray alloc]initWithArray:fetchedObjects];
    NSLog(@"%@",fetchedCategorList);
    
    for (NSManagedObject *managedObject in fetchedCategorList) {
    	[[appDelegate managedObjectContext] deleteObject:managedObject];
    	//DLog(@"%@ object deleted",entityDescription);
    }
    if (![[appDelegate managedObjectContext] save:&error]) {
    	//NSLog(@"Error deleting %@ - error:",error);
    }
    
}


+(void)saveImage:(NSDictionary*)dict
{
    NSLog(@"saving file : %@", dict);
    [[DataBase sharedInstance] saveProfileImage:dict[@"local"] andFBURL:dict[@"fb"]];
}


+ (void)executeFQlForMatchProfileForId:(NSString*)fbid andDelegate:(id<TinderFBFQLDelegate>)delegate
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = nil;
    dict = [ud objectForKey:@"FBUSERDETAIL"];
    
    NSString *query = [NSString stringWithFormat:@"{'FriendsNumber':select mutual_friend_count from user WHERE uid = '%@','IntrestNumber': select page_fan_count from user WHERE uid = '%@',}",fbid,fbid];
    
    NSLog(@"query %@",query);
    
    // Set up the query parameter
    NSDictionary *queryParam = @{ @"q": query };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              
                              NSDictionary * dict =result[@"data"];
                              NSLog(@"countfrnd%@",[dict objectForKey:@"mutual_friend_count"]);
                              
                              [ud setObject:[dict objectForKey:@"mutual_friend_count"] forKey:@"MUTUALFRND"];
                    
                              
                              
                            
                          }
     ];
    
}
//mutual friend
+ (void)executeFQlForMutualFriendForId:(NSString*)fbid andFriendId :(NSString*)FriendId andDelegate:(id<TinderFBFQLDelegate>)delegate{
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = nil;
    dict = [ud objectForKey:@"FBUSERDETAIL"];
    
    
    NSString *query = [NSString stringWithFormat:@"SELECT uid, first_name, last_name, pic_small FROM user WHERE uid IN (SELECT uid2 FROM friend where uid1='%@' and uid2 in (SELECT uid2 FROM friend where uid1=me()))",FriendId];
    
    NSLog(@"query %@",query);
    
    // Set up the query parameter
    NSDictionary *queryParam = @{ @"q": query };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                           
                              NSArray *friendInfo = (NSArray *) result[@"data"];
                      

                            [delegate performSelector:@selector(loadImageForSharedFrnd:) withObject:friendInfo];
                              
                          }
     ];
  
    
}
//mutual intrest

+ (void)executeFQlForMutualLikesForId:(NSString*)fbid andFriendId :(NSString*)FriendId andDelegate:(id<TinderFBFQLDelegate>)delegate{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = nil;
    dict = [ud objectForKey:@"FBUSERDETAIL"];

    
    NSString *query = [NSString stringWithFormat:@"SELECT pic_square,name from page where page_id IN (SELECT page_id  FROM page_fan WHERE uid= '%@' AND page_id IN (SELECT page_id FROM page_fan WHERE uid = '%@'))",[dict objectForKey:FACEBOOK_ID],FriendId];
    
    NSLog(@"query %@",query);
    
    // Set up the query parameter
    NSDictionary *queryParam = @{ @"q": query };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              
                           
                              NSArray *friendIntrest = (NSArray *) result[@"data"];
                              
                              [delegate performSelector:@selector(loadImageForSharedIntrest:) withObject:friendIntrest];
                          }
     ];
  
    
}

@end
