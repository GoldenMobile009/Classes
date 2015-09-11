 //
//  ChatViewController.m
//  Tinder
//
//  Created by Rahul Sharma on 29/11/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "ChatViewController.h"
#import "ProfileMatchedCell.h"
#import "DBHandler.h"
#import "MatchedUserList.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "JSDemoViewController.h"
#import "ProgressIndicator.h"
#import "MessageTable.h"
@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize tblView;
@synthesize matchedUserLists;
@synthesize needToCallWebservice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [Helper getColorFromHexString:@"#333333" :1.0];
    
    NSLog(@"viewdidload");
    self.title = @"Matched List";
//    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstLaunchForMatchedList"] == NO) {
//        
//        
//        ProgressIndicator *progress = [ProgressIndicator sharedInstance];
//        [progress showPIOnView:self.view withMessage:@"loading"];
//        
//        WebServiceHandler *webservicehandler = [[WebServiceHandler alloc]init];
//        webservicehandler.delegate = self;
//        
//        [webservicehandler webserviceRequestAndResponse:nil serviceType:1 facebookId:nil];
//        //[self deleteAllDbObject];
//    }else{
//        self.matchedUserLists = (NSMutableArray *)[DBHandler dataFromTable:@"MatchedUserList" condition:nil orderBy:nil ascending:NO];
//        // [self.tblView reloadData];
//    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated {
    
    //self.matchedUserLists = [[NSMutableArray alloc]init];
    
    if (needToCallWebservice) {
        //if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstLaunchForMatchedList"] == NO) {
        
        if ( [[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstSignupOrLogin"] == YES) {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFirstSignupOrLogin"];
            [self deleteAllDbObject];
        }
        
            ProgressIndicator *progress = [ProgressIndicator sharedInstance];
            [progress showPIOnView:self.view withMessage:@"loading"];
            
            WebServiceHandler *webservicehandler = [[WebServiceHandler alloc]init];
            webservicehandler.delegate = self;
            
            [webservicehandler webserviceRequestAndResponse:nil serviceType:1 facebookId:nil];
            
          
    
}

//        else
//        {
//            
//            self.matchedUserLists = (NSMutableArray *)[DBHandler dataFromTable:@"MatchedUserList" condition:nil orderBy:nil ascending:NO];
//            // [self.tblView reloadData];
//        }
   // }

//    }
//        else{
//            self.matchedUserLists = (NSMutableArray *)[DBHandler dataFromTable:@"MatchedUserList" condition:nil orderBy:nil ascending:NO];
//            // [self.tblView reloadData];
//        }
    
   

}
-(void)deleteAllDbObject
{
    TinderAppDelegate *appDelegate =(TinderAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MatchedUserList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray*fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *fetchedCategorList=[[NSMutableArray alloc]initWithArray:fetchedObjects];
    
    for (NSManagedObject *managedObject in fetchedCategorList) {
    	[context deleteObject:managedObject];
    	//DLog(@"%@ object deleted",entityDescription);
    }
    if (![context save:&error]) {
    	//NSLog(@"Error deleting %@ - error:",error);
    }
    
    
}

#pragma mark - Other Method
- (void)dataInsertedSucessfullyInDb:(BOOL)success
{
    NSLog(@"dataInsertedSucessfullyInDb");
   /*check for Firstlaunch of App */
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstLaunchForMatchedList"];
    [self.matchedUserLists removeAllObjects];
    
    self.matchedUserLists = (NSMutableArray *)[DBHandler dataFromTable:@"MatchedUserList" condition:nil orderBy:nil ascending:NO];
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    
    [pi hideProgressIndicator];
    [self.tblView reloadData];
}
- (void)setLastMessageText:(NSString *)text{
    NSLog(@"text:%@",text);
    
    [[NSUserDefaults standardUserDefaults]setValue:text forKey:@"LASTMESSAGETEXT"];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count :%d",self.matchedUserLists.count);
    return [self.matchedUserLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"CellIdentifier";
	
	ProfileMatchedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
        cell = [[ProfileMatchedCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		[cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    NSLog(@"count cellForRowAtIndexPath:%d",self.matchedUserLists.count);
    
    
    MatchedUserList *matchedUserList = [self.matchedUserLists objectAtIndex:indexPath.row];
    cell.labelFirstName.text = matchedUserList.fName;
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSDictionary * dictFb = [ud objectForKey:@"FBUSERDETAIL"];
    
    
   NSArray *storedMessages = [DBHandler dataFromTable:@"MessageTable" condition:[NSString stringWithFormat:@"senderId = %@ AND receiverId = %@",[NSNumber numberWithLongLong:[[dictFb objectForKey:FACEBOOK_ID] longLongValue]],[NSNumber numberWithLongLong:matchedUserList.fId.longLongValue]] orderBy:nil ascending:NO];
    
  
    
//    NSDictionary * dict = [self.matchedUserLists objectAtIndex:indexPath.row];
//    cell.labelFirstName.text = [dict objectForKey:@"fName"];
    
//    NSString *lastMessageInfo =[[NSUserDefaults standardUserDefaults]valueForKey:@"LASTMESSAGETEXT"];
//    if (lastMessageInfo != nil) {
//        NSArray *arrayInfo = [lastMessageInfo componentsSeparatedByString:@":"];
//        if (arrayInfo.count) {
//            NSString *strMessage = [arrayInfo objectAtIndex:0];
//            NSString *StrFid = [arrayInfo objectAtIndex:1];
//            
//            if (StrFid.longLongValue == matchedUserList.fId.longLongValue) {
//              
//                cell.labelLastMessage.text = strMessage;
//            }
//        }
//    }
    if (storedMessages.count > 0)
    {
        MessageTable *msg = [storedMessages lastObject];
        
        cell.labelLastMessage.text = msg.message;
    }
  
    
    
    UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(50/2-20/2, 46/2-20/2, 20, 20)];
    [cell.thumbNailImage addSubview:activityIndicator];
    // activityIndicator.backgroundColor=[UIColor greenColor];
    activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [activityIndicator startAnimating];
    
    NSURL *urlImagePath=[NSURL fileURLWithPath:matchedUserList.proficePic];
    [cell.thumbNailImage setImageWithURL:urlImagePath
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                 [activityIndicator stopAnimating];
                                   
                               }];

  
    
//    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:urlImagePath
//                                                        options:0
//                                                       progress:^(NSUInteger receivedSize, long long expectedSize)
//     {
//         // progression tracking code
//     }
//                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
//     {
//         if (image && finished)
//         {
//             [activityIndicator stopAnimating];
//             cell.thumbNailImage.image =image; // do something with image
//         }
//         else{
//             [activityIndicator stopAnimating];
//              cell.thumbNailImage.image=[UIImage imageNamed:@"a.png"];
//         }
//     }];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
   // dict = [self.matchedUserLists objectAtIndex:indexPath.row];
    MatchedUserList *matchedUserList = [self.matchedUserLists objectAtIndex:indexPath.row];
    JSDemoViewController *vc = [[JSDemoViewController alloc] init];
   vc.friendFbId = matchedUserList.fId;
   // vc.delegate1 = self;
    NSLog(@"status:%@",matchedUserList.status);
    vc.status = matchedUserList.status;
    vc.ChatPersonNane =matchedUserList.fName;
    vc.matchedUserProfileImagePath = matchedUserList.proficePic;
    [dict setValue:matchedUserList.fId forKey:@"fbId"];
    [dict setValue:matchedUserList.status forKey:@"status"];
    [dict setValue:matchedUserList.fName forKey:@"fName"];
    [dict setValue:matchedUserList.proficePic forKey:@"proficePic"];
    vc.dictUser = dict;
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:vc];
   [self.revealSideViewController popViewControllerWithNewCenterController:n
                                                                   animated:YES];
    
    
    //[self.revealSideViewController.navigationController pushViewController:vc  animated:YES];
}
#pragma mark - WebServiceResponse Delegate
- (void)getServiceResponseDelegate:(NSDictionary *)responseDict serviceType:(int)type error:(NSError *)error
{
    NSLog(@"getServiceResponseDelegate");
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    if (error == nil) {
        
        NSLog(@"resposse%@",responseDict);
        
        if ([[responseDict objectForKey:@"errFlag"]intValue] == 0) {
            
            NSLog(@"success");
            if (type == 1) {   // matched list response
                
                if( !self.matchedUserLists ){
                    self.matchedUserLists = [[NSMutableArray alloc]init];
                }
                self.matchedUserLists = [[responseDict objectForKey:@"likes"] mutableCopy];
                
                NSLog(@"matched list %@",self.matchedUserLists);
                
                DataBase *insertDatatoDb = [[DataBase alloc]init];
                insertDatatoDb.delegate = self;
                [insertDatatoDb insertMatchedUserList:self.matchedUserLists];
                
                
            }
        }
        else if ([[responseDict objectForKey:@"errFlag"]intValue] == 1)
        {
            //[Helper showAlertWithTitle:@"Message" Message:[responseDict objectForKey:@"errMsg"]];
            self.matchedUserLists = [[NSMutableArray alloc]init];
            
            self.matchedUserLists = (NSMutableArray *)[DBHandler dataFromTable:@"MatchedUserList" condition:nil orderBy:nil ascending:NO];
            
            if (self.matchedUserLists.count > 0) {
                [self.tblView reloadData];
            }
            
            NSLog(@"matchedUserList :%@",self.matchedUserLists);
            
            
        }
        
    }else{
        
        NSLog(@"error");
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
