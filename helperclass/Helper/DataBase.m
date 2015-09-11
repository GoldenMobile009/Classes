//
//  DataBase.m
//  Restaurant
//
//  Created by 3Embed on 27/09/12.
//
//

#import "DataBase.h"
#import "TinderAppDelegate.h"
#import "Login.h"
#import "UploadImages.h"
#import "MessageTable.h"
#import "MatchedUserList.h"
#import "SDWebImageDownloader.h"
#import "AppConstants.h"
#import "Helper.h"
#import "Constant.h"
#import "DBHandler.h"



static DataBase *sharedObject;


@implementation DataBase
@synthesize delegate;

+ (id)sharedInstance {
	if (!sharedObject) {
		sharedObject = [[self alloc] init];
	}
	
	return sharedObject;
}

-(void)makeDataBaseEntryForLogin:(NSDictionary*)dictionary
{
    NSError *error;
	TinderAppDelegate *appDelegate = (TinderAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	Login* item= [NSEntityDescription insertNewObjectForEntityForName:@"Login" inManagedObjectContext:context];
    
    
    
    
//    int sex ;
//    if ([[dictionary objectForKey:@"gender"] isEqualToString:@"female"]) {
//        sex= FEMALE;
//    }
//    else{
//        
//        sex=MALE;
//    }
//    
//    int age = 0;
//    NSString  *BDAy = [Helper getBirthDate:[dictionary objectForKey:FACEBOOK_BIRTHDAY]];
//    if (BDAy.length ==0 || [BDAy isEqualToString:@""] || BDAy == nil) {
//        BDAy  =@"0000-00-00";
//     
//        age = 23;
//    }
//    else{
//        BDAy = [Helper getBirthDate:[dictionary objectForKey:FACEBOOK_BIRTHDAY]];
//        age = [Helper getAge:[dictionary objectForKey:FACEBOOK_BIRTHDAY]];
//        
//    }
//    
//    
//    
//    
//    NSDictionary * dictLike = [dictionary objectForKey:FACEBOOK_LIKES];
//    NSMutableString* mutString = [[NSMutableString alloc] init];
//    NSArray * arrLike = [dictLike objectForKey:@"data"];
//    for (int k=0; k<arrLike.count; k++) {
//        NSDictionary *  dict = [arrLike objectAtIndex:k];
//        [mutString appendString:[NSString stringWithFormat:@"%@,",[dict objectForKey:@"id"]]];
//    }
//    
//    
//    // NSDictionary  * dictLocation =[dictionary objectForKey:FACEBOOK_LOCATION];
//    NSDictionary  * dictAge =[dictionary objectForKey:FACEBOOK_AGERANGE];
//    NSArray * arrIntrest = [dictionary objectForKey:FACEBOOK_INTRESTED_IN];
//    int min;
//    int max;
//    if ([[dictAge objectForKey:AGERANGE_MAX] intValue] ==0) {
//        max= 58;
//    }
//    else{
//        max = [[dictAge objectForKey:AGERANGE_MAX]intValue];
//    }
//    if ([[dictAge objectForKey:AGERANGE_MIN] intValue] ==0) {
//        min= 18;
//    }
//    else{
//        min =[[dictAge objectForKey:AGERANGE_MIN] intValue];
//        
//    }
//    NSString * email;
//    if ([[dictionary objectForKey:FACEBOOK_EMAIL] isEqualToString:@""]||[[dictionary objectForKey:FACEBOOK_EMAIL] length]==0 ||[dictionary objectForKey:FACEBOOK_EMAIL]==nil) {
//        
//        email = @"abc@gmail.com";
//    }
//    else
//    {
//        email = [dictionary objectForKey:FACEBOOK_EMAIL];
//    }
//    
//    
//    int Intested_in = 3;
//    
//    if (arrIntrest && ([arrIntrest count] > 0)) {
//        if ([[arrIntrest objectAtIndex:0] isEqualToString:@"female"]) {
//            Intested_in = 2;
//        }
//        else if ([[arrIntrest objectAtIndex:0] isEqualToString:@"male"])
//        {
//            Intested_in = 1;
//        }
//    }
//    
//    
//    [item setFbId:[dictionary objectForKey:FACEBOOK_ID]];
//	  [item setFirstname:[dictionary objectForKey:FACEBOOK_FIRSTNAME]];
//    [item setLastname:[dictionary objectForKey:FACEBOOK_LASTNAME]];
//    [item setAge:[NSNumber numberWithInt:age]];
//    [item setGender:[NSNumber numberWithInt:sex]];
//    [item setPrefsex:[NSNumber numberWithInt:Intested_in]];
//    [item setLowerage:[NSNumber numberWithInt:min]];
//    [item setMaxage:[NSNumber numberWithInt:max]];
//    [item setLikes:mutString];
//    [item setAbout:[dictionary objectForKey:FACEBOOK_BIO]];
//    [item setDob:BDAy];
//    [item setEmail:email];
    int age = age = [Helper getAge:[dictionary objectForKey:RPLoginDOB]];
    if (age ==0) {
        age =25;
    }

    
    
    
    NSLog(@"loginDictinary%@",dictionary);
    
   
    [item setFbId:[dictionary objectForKey:RPFBId]];
	[item setFirstname:[dictionary objectForKey:RPLoginFirstName]];
    [item setLastname:[dictionary objectForKey:RPLoginLastName]];
    [item setAge:[NSNumber numberWithInt:age]];
    [item setGender:[NSNumber numberWithInt:[[dictionary objectForKey:RPLoginSex] intValue]]];
    [item setPrefsex:[NSNumber numberWithInt:[[dictionary objectForKey:RPLoginPrefSex] intValue]]];
    [item setLowerage:[NSNumber numberWithInt:[[dictionary objectForKey:RPLoginPrefLowerAge] intValue]]];
    [item setMaxage:[NSNumber numberWithInt:[[dictionary objectForKey:RPLoginPrefUpperAge] intValue]]];
    [item setLikes:[dictionary objectForKey:RPLoginLikes]];
    [item setAbout:[dictionary objectForKey:RPLoginTagLine]];
    [item setDob:[dictionary objectForKey:RPLoginDOB]];
    [item setEmail:[dictionary objectForKey:RPLoginEmail]];
    
    // [item setThumnail:documentsPath];
    
    
    BOOL isSaved = [context save:&error];
	if (isSaved)
    {
        //		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Dish added to your favourite list" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //		[alertView show];
        //		[alertView release];
	}
	else
    {
        //		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Saving failed.Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //		[alertView show];
        //		[alertView release];
	}
    
}

-(void)makeDataBaseEntryForGetProfile:(NSDictionary*)dictionary
{
    //check if there is any images
    NSArray *images = dictionary[@"images"];
    if (images.count > 0) {
        if ([images[0] isKindOfClass:[NSNull class]]) {
            [delegate dataInsertedSucessfullyInDb:YES];
            return;
        }
    }
   
    
    [self deleteAllObjectFortable:@"UploadImages"];
    
    [self performSelectorOnMainThread:@selector(makeDataBaseEntryForUploadImages:) withObject:[dictionary objectForKey:@"images"] waitUntilDone:YES];
   // NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray * imageURLs = (NSArray*)[dictionary objectForKey:@"images"];
   // int __block count =0;
  
    for (int i = 0; i<imageURLs.count; i++)
    {
        
    [self saveImageToDocumentsDirectoryForLogin :[imageURLs objectAtIndex:i]:i];
        
        
    }
    
     [delegate dataInsertedSucessfullyInDb:YES];
   
   // NSMutableString* Images = [[NSMutableString alloc] init];
//    for (int i = 0; i<imageURLs.count; i++) {
//        //NSDictionary * dict = [imageURLs objectAtIndex:i];
//        NSString * imgpath ;//= [NSString stringWithFormat:@"imgpath_%d",i];
//        
//            //NSArray *imageName = [[dict objectForKey:@"src_big"] componentsSeparatedByString:@"/"];
//            imgpath = [NSString stringWithFormat:@"%@/%d.jpg",docDir,i];
//            NSURL *url = [NSURL URLWithString:[Helper removeWhiteSpaceFromURL:[imageURLs objectAtIndex:i]]];
//            
//            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:url
//                                                                options:0
//                                                               progress:^(NSUInteger receivedSize, long long expectedSize)
//             {
//                 // progression tracking code
//             }
//             
//             
//                                                              completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
//             {
//                 
//                 
//                 
//                 if (image && finished)
//                 {
//                     NSLog(@"image finished... %d",i);
//                      NSLog(@"image_finished_count%d",count);
//                     // do something with image
//                     
//                     data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
//                     
//                     
//                     if ([data writeToFile:imgpath atomically:YES]) {
//                         
//                        
//                         
//                        
//                         [self saveImage:@{@"fb":[url absoluteString], @"local":imgpath}];
//                        
//                         if (count==imageURLs.count-1)
//                         {
//                          
//                             NSLog(@"lastCount");
//                             
//                             [delegate dataInsertedSucessfullyInDb:YES];
//                             count =0;
//                       
//
//                             return ;
//                             
//                         }
//                         
//                         count++;
//                         
//                            NSLog(@"IncrementCount%d",count);
//                     }
//                     else{
//                         
//                             NSLog(@"image fail... %d",i);
//                            NSLog(@"image_fail_count%d",count);
//                         count++;
//                     }
//                     
//                     
//                     
//                     
//                 }
//                 
//                 
//             }];
//            
//            
//    }
    
      // }
        
//    BOOL isSaved = [context save:&error];
//	if (isSaved)
//    {
//        
//        //		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Dish added to your favourite list" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        //		[alertView show];
//        //		[alertView release];
//	}
//	else
//    {
//        //		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Saving failed.Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        //		[alertView show];
//        //		[alertView release];
//	}

    

    
    
    
}

- (void)removeImage:(NSString*)fileName {
    
    NSLog(@"remove path%@",fileName);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
   // NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:
                          //[NSString stringWithFormat:@"%@.jpg", fileName]];
    
    [fileManager removeItemAtPath: documentsDirectory error:NULL];
    NSLog(@"image removed: %@", documentsDirectory);
    
   // NSString *appFolderPath = [[NSBundle mainBundle] resourcePath];
   // NSLog(@"Directory Contents:\n%@", [fileManager directoryContentsAtPath: appFolderPath]);
}

- (void)imageDownloader:(SDWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image
{
    NSLog(@"finish");
}

-(void)saveImage:(NSDictionary*)dict
{
    NSLog(@"dict%@",dict);
    [self saveProfileImage:dict[@"local"] andFBURL:dict[@"fb"]];
}
-(void)deleteAllObjectFortable:(NSString*)tableName
{
    TinderAppDelegate* appDelegate =(TinderAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:[appDelegate managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray*fetchedObjects = [[appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *fetchedCategorList=[[NSMutableArray alloc]initWithArray:fetchedObjects];
    NSLog(@"%@",fetchedCategorList);
    
    for (NSManagedObject *managedObject in fetchedCategorList)
    {
    	[[appDelegate managedObjectContext] deleteObject:managedObject];
    	//DLog(@"%@ object deleted",entityDescription);
    }
    if (![[appDelegate managedObjectContext] save:&error]) {
    	//NSLog(@"Error deleting %@ - error:",error);
    }
    
}

-(void)makeDataBaseEntryForUploadImages:(NSArray *)array
{
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSError *error;
	TinderAppDelegate *appDelegate = (TinderAppDelegate *)[[UIApplication sharedApplication] delegate];
    
   
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSDictionary * dict = [ud objectForKey:@"FBUSERDETAIL"];
    for (int i = 0; i<array.count; i++) {
        UploadImages* item= [NSEntityDescription insertNewObjectForEntityForName:@"UploadImages" inManagedObjectContext:context];
        item.fbId = [dict objectForKey:FACEBOOK_ID];
        item.imageUrlFB = [array objectAtIndex:i];
            
  
        
    }
    
    BOOL isSaved = [context save:&error];
    NSLog(@"save%d",isSaved);
    if (isSaved)
    {
        //		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Dish added to your favourite list" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //		[alertView show];
        //		[alertView release];
    }
    else
    {
        //		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Saving failed.Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //		[alertView show];
        //		[alertView release];
    }
    
}
#pragma mark-
#pragma mark getDatabase Data

- (NSArray *)getLoginData;
{
    
    TinderAppDelegate *appDelegate = (TinderAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Login" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"resutl : %@",result);
    return result;
    
}
- (NSArray *)getImages
{
    TinderAppDelegate *appDelegate = (TinderAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UploadImages" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"resutl : %@",result);
    return result;
}
//- (GetProfile *)getProfileData
//{
//    TinderAppDelegate *appDelegate = (TinderAppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GetProfile" inManagedObjectContext:context];
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
//    [fetchRequest setEntity:entity];
//    
//    NSError *error;
//    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
//    NSLog(@"resutl : %@",result);
//    GetProfile * profile= nil;
//    if (result.count==0) {
//        NSLog(@",count is Zero");
//    }
//    else
//    {
//    profile = [result objectAtIndex:0];
//        
//    }
//    
//
//    
//    return profile;
//}

- (void)insertMessageForFirstlaunch:(NSArray *)messages uniqueId:(NSString *)uniqueId
{
    [self deleteAllObjectFortable:@"MessageTable"];
    if (messages.count > 0)
    {
        for (int i = 0; i < messages.count; i++) {
            TinderAppDelegate  *appDelegate =(TinderAppDelegate*)[[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context = [appDelegate managedObjectContext];
            MessageTable *messageTbl = [NSEntityDescription insertNewObjectForEntityForName:@"MessageTable" inManagedObjectContext:context];
            
            [messageTbl setFId:messages[i][@"sfid"]];
            [messageTbl setMessage:messages[i][@"msg"]];
            [messageTbl setName:messages[i][@"sname"]];
            [messageTbl setUniqueId:uniqueId];
            NSString  *dt = messages[i][@"date"];
            [messageTbl setMessageDate:messages[i][@"dt"]];
            [messageTbl setDate:[NSNumber numberWithDouble:dt.doubleValue]];
            [messageTbl setUniqueId:uniqueId];
            NSLog(@"doubleRId: %lld ",[messages[i][@"rfid"] longLongValue]);
            NSLog(@"doubleSId: %lld ",[messages[i][@"sfid"] longLongValue]);
           [messageTbl setReceiverId:[NSNumber numberWithLongLong:[messages[i][@"rfid"] longLongValue]]];
            [messageTbl setSenderId:[NSNumber numberWithLongLong:[messages[i][@"sfid"] longLongValue]]];
            
            
            NSError *error=nil;
            if(![[appDelegate managedObjectContext]save:&error])
            {
                NSLog(@"error ------->%@",error);
            }
            
        }
    }
    
    [delegate dataInsertedSucessfullyInDb:YES];
}
- (void)insertMessages:(NSMutableDictionary *)messages
{
    
    TinderAppDelegate *appDelegate =(TinderAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    MessageTable *messageTbl = [NSEntityDescription insertNewObjectForEntityForName:@"MessageTable" inManagedObjectContext:context];
    
    if (messages.count > 0)
    {
        [messageTbl setFId:[messages objectForKey:@"sfId"]];
        [messageTbl setMessage:[messages objectForKey:@"msg"]];
        [messageTbl setName:[messages objectForKey:@"sname"]];
        [messageTbl setUniqueId:[messages objectForKey:@"uniqueId"]];
        [messageTbl setMessageDate:[messages objectForKey:@"dt"]];
        NSString  *dt = messages[@"date"];
        [messageTbl setDate:[NSNumber numberWithDouble:dt.doubleValue]];
        [messageTbl setReceiverId:[NSNumber numberWithLongLong:[[messages objectForKey:@"ReceiverId"] longLongValue]]];
        [messageTbl setSenderId:[NSNumber numberWithLongLong:[[messages objectForKey:@"SenderId"] longLongValue]]];
        
        NSError *error=nil;
        if(![[appDelegate managedObjectContext]save:&error])
        {
            NSLog(@"error ------->%@",error);
        }
        
    }
    
}


- (void)insertMatchedUserList:(NSMutableArray *)mMatchedUser
{
    TinderAppDelegate *appDelegate =(TinderAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    [self deleteAllObjectFortable:@"MatchedUserList"];
    /*
    NSManagedObject *favorisObj = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"MatchedUserList"
                                   inManagedObjectContext:context];

    [context deleteObject:favorisObj];
*/
    
    if (mMatchedUser.count > 0)
    {
        for (int i = 0; i < mMatchedUser.count; i++) {
            MatchedUserList *matchedTable = [NSEntityDescription insertNewObjectForEntityForName:@"MatchedUserList" inManagedObjectContext:context];
            
            
            [matchedTable setFName:mMatchedUser[i][@"fName"]];
            [matchedTable setFId:mMatchedUser[i][@"fbId"]];
            if([mMatchedUser[i][@"flag"] isEqual: [NSNull null]])
            {
                [matchedTable setStatus:@"0"];
            }
            else
            {
                [matchedTable setStatus:mMatchedUser[i][@"flag"]];
            }
            [matchedTable setLastActive:mMatchedUser[i][@"ladt"]];
            NSLog(@"pPic%@",mMatchedUser[i][@"pPic"]);
            if (mMatchedUser[i][@"pPic"]) {
                [self saveImageToDocumentsDirectory:matchedTable :mMatchedUser[i][@"pPic"]];
            }else{
            [matchedTable setProficePic:@""];
            }
            NSError *error;
            if(![context save:&error])
            {
                NSLog(@"error ------->%@",error);
            }
        }
        
    }
    
    
    [delegate dataInsertedSucessfullyInDb:YES];
    
}

-(void)saveProfileImage:(NSString*)localPath andFBURL:(NSString*)fburl
{
    
    NSLog(@"path%@ : url%@ ",localPath,fburl);
    TinderAppDelegate *appDelegate = (TinderAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UploadImages" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"imageUrlFB = %@", fburl]];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
   
    
   
    
    if (result.count == 1) {
   
        UploadImages *item = [result objectAtIndex:0];
        item.imageUrlLocal = localPath;
        BOOL isSaved = [context save:&error];
        NSLog(@"isSaved %dsave local image copy",isSaved);
    
        
    }
    
    
    
}
/*
 - (NSString *) saveMatchedProfileImageToDocumentsDirectory :(NSString *)imageUrl
 {
 NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
 NSString * imgpath ;
 NSArray *imageName = [imageUrl componentsSeparatedByString:@"/"];
 imgpath = [NSString stringWithFormat:@"%@/%@",docDir,[imageName lastObject]];
 data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
 
 
 if ([data writeToFile:imgpath atomically:YES]) {
 
 NSLog(@"save");
 //[arr addObject:imgpath];
 
 }
 
 }
 */



- (void)saveImageToDocumentsDirectoryForLogin :(NSString *)imageUrl :(int)index
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * imgpath ;
   
    //NSArray *imageName = [imageUrl componentsSeparatedByString:@"/"];
    imgpath = [NSString stringWithFormat:@"%@/%d.jpg",docDir,index];
    NSData  *data = nil;
    NSURL *url = [NSURL URLWithString:[Helper removeWhiteSpaceFromURL:imageUrl]];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
 
  
     NSString *strPath =[[NSBundle mainBundle] pathForResource:@"pfImage" ofType:@"png"];
    [[NSUserDefaults standardUserDefaults] setObject:strPath forKey:@"FBPROFILEURL"];
  
    if ([data writeToFile:imgpath atomically:YES]) {
        
        switch (index) {
            case 0:
            {
                [[NSUserDefaults standardUserDefaults] setObject:imgpath forKey:@"FBPROFILEURL"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                 [self saveImage:@{@"fb":imageUrl, @"local":imgpath}];
                
                break;
            }
            case 1:
            {
                  [self saveImage:@{@"fb":imageUrl, @"local":imgpath}];
                break;
            }
            case 2:
            {
                  [self saveImage:@{@"fb":imageUrl, @"local":imgpath}];
                break;
            }
            case 3:
            {
                  [self saveImage:@{@"fb":imageUrl, @"local":imgpath}];
                break;
            }
            case 4:
            {
                [self saveImage:@{@"fb":imageUrl, @"local":imgpath}];
                break;
            }
                
            default:
                break;
        }
        
        NSLog(@"save ");
    }
    
}

- (void)saveImageToDocumentsDirectory:(MatchedUserList *)matchList :(NSString *)imageUrl
{
    if([imageUrl isEqual:[NSNull null]])
        imageUrl=@"";
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * imgpath ;
  
    NSArray *imageName = [imageUrl componentsSeparatedByString:@"/"];
    imgpath = [NSString stringWithFormat:@"%@/%@",docDir,[imageName lastObject]];
    matchList.proficePic = imgpath;
    NSData  *data = nil;
    NSFileManager *fm = [NSFileManager new];
    if ( [fm fileExistsAtPath:imgpath])
    {
        NSURL *url = [NSURL URLWithString:[Helper removeWhiteSpaceFromURL:imageUrl]];
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
        data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
 
        //do nothing
    }else{
        NSURL *url = [NSURL URLWithString:[Helper removeWhiteSpaceFromURL:imageUrl]];
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
        data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
    }
    if ([data writeToFile:imgpath atomically:YES]) {
         NSLog(@"save ");
    }
    
    
}


@end
