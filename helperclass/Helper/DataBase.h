//
//  DataBase.h
//  Restaurant
//
//  Created by 3Embed on 27/09/12.
//
//

#import <Foundation/Foundation.h>
#import "SDWebImageDownloader.h"
//#import"GetProfile.h"

@protocol DataInsertedSuccessfullyDelegate <NSObject>

- (void)dataInsertedSucessfullyInDb:(BOOL)success;

@end

@interface DataBase : NSObject
@property(nonatomic,assign)id <DataInsertedSuccessfullyDelegate>delegate;
+ (id)sharedInstance;
-(void)makeDataBaseEntryForLogin:(NSDictionary *)dictionary;
-(void)makeDataBaseEntryForUploadImages:(NSArray *)array;
-(void)makeDataBaseEntryForGetProfile:(NSDictionary*)dictionary;


- (void)insertMessageForFirstlaunch:(NSArray *)messages uniqueId:(NSString *)uniqueId;
- (void)insertMessages:(NSMutableDictionary *)messages;
- (void)insertMatchedUserList:(NSMutableArray *)mMatchedUser;
-(void)deleteAllObjectFortable:(NSString*)tableName;
- (void)saveImageToDocumentsDirectoryForLogin :(NSString *)imageUrl :(int)index;




- (NSArray *)getLoginData;
- (NSArray *)getImages;
//- (GetProfile *)getProfileData;

-(void)saveProfileImage:(NSString*)localPath andFBURL:(NSString*)fburl;


@end
