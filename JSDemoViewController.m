//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSMessagesViewController
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//  http://opensource.org/licenses/MIT
//



#import "JSDemoViewController.h"
#import "Helper.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "WebServiceHandler.h"
#import "DBHandler.h"
#import "MessageTable.h"
#import "MatchedUserList.h"
#import "TinderAppDelegate.h"
#import "DataBase.h"
#import "UploadImages.h"
#import "ProfileViewController.h"
#import "TinderPreviewUserProfileViewController.h"
#import "Constant.h"
#import "AppConstants.h"

#define kSubtitleJobs @"Jobs"
#define kSubtitleWoz @"Steve Wozniak"
#define kSubtitleCook @"Mr. Cook"
#define HOST @"http://108.166.190.172:81/tinderClone/"

@implementation JSDemoViewController
{
    NSTimer *timer;
    
}
@synthesize mResponseDict;
@synthesize mResponseArray;
@synthesize currentMessage;
@synthesize customSlidingView;
@synthesize friendFbId;
@synthesize status;
@synthesize dataBase;
@synthesize ChatPersonNane;
@synthesize matchedUserProfileImagePath;
@synthesize dictUser;
//@synthesize delegate1;
- (void)viewDidDisappear:(BOOL)animated
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:kPushDidReceive object:nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    /*
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    timer = [NSTimer timerWithTimeInterval:10.0 target:self selector:@selector(myTimerAction) userInfo:nil repeats:YES];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
    [runloop addTimer:timer forMode:UITrackingRunLoopMode];
*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventListenerDidReceiveChatNotification:) name:kPushDidReceive object:nil];
    self.delegate = self;
    self.dataSource = self;
    [super viewDidLoad];
    NSUserDefaults * ud =[NSUserDefaults standardUserDefaults];
    NSDictionary * dictP =[ud objectForKey:@"FBUSERDETAIL"];
    self.userFbId= [dictP objectForKey:FACEBOOK_ID];
    
   

    NSArray * arrProfile = [self getProfileImages:self.userFbId];
   // UploadImages * uploadImage = [arrProfile objectAtIndex:0];
   // self.mainImageView.image =[UIImage imageWithContentsOfFile:[(UploadImages*)[arrProfile objectAtIndex:0] imageUrlLocal]];

    if(arrProfile.count>0)
    {
    if ([(UploadImages*)[arrProfile objectAtIndex:0] imageUrlLocal]==nil) {
        NSString *url = [ud objectForKey:@"FBPROFILEURL"];
        
        if ([url hasPrefix:@"https://"]) {
            //profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        }
        else {
            //profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:url]]];
        }
    }
    else{
        strProfile = [(UploadImages*)[arrProfile objectAtIndex:0] imageUrlLocal];
    }
    }
    
    //self.title = [NSString stringWithFormat:@"                                                     %@",ChatPersonNane];
    
   
   // self.userFbId = @"100000545736199";
  
    
    self.messageInputView.textView.placeHolder = @"New Message";
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
   // self.messages = [[NSMutableArray alloc]init];
    
   // self.timestamps = [[NSMutableArray alloc]init];
    
  //  self.subtitles = [[NSMutableArray alloc]init];
    
    
    self.mResponseArray = [[NSMutableArray alloc]init];
    
    /*
    self.avatars = [[NSDictionary alloc] initWithObjectsAndKeys:
                    [JSAvatarImageFactory avatarImageNamed:@"demo-avatar-jobs" style:JSAvatarImageStyleFlat shape:JSAvatarImageShapeCircle], kSubtitleJobs,
                    [JSAvatarImageFactory avatarImageNamed:@"demo-avatar-woz" style:JSAvatarImageStyleFlat shape:JSAvatarImageShapeCircle], kSubtitleWoz,
                    [JSAvatarImageFactory avatarImageNamed:@"demo-avatar-cook" style:JSAvatarImageStyleFlat shape:JSAvatarImageShapeCircle], kSubtitleCook,
                    nil];
     */
    
    /* add sliding view to self.view */
    self.customSlidingView = [[UIView alloc]initWithFrame:CGRectMake(0, -44, 320, 46)];
    self.customSlidingView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tab.png"]];
    [self.view addSubview:self.customSlidingView];
    
    
    [self addrightButton:self.navigationItem];
    [self addBack:self.navigationItem];
    
    UIImage * imgblock = [UIImage imageNamed:@"block_icon.png"];
   // UIImage * imgUnblock = [UIImage imageNamed:@"unblock_icon.png"];
    buttonBlockUser = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBlockUser.frame = CGRectMake(250, 5, imgblock.size.width, imgblock.size.height);
    [Helper setButton:buttonBlockUser Text:nil WithFont:nil FSize:12.0 TitleColor:nil ShadowColor:nil];
    [buttonBlockUser addTarget:self action:@selector(buttonBlockTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.customSlidingView addSubview:buttonBlockUser];

    
    /* add button to customSlidingview */
    UIImage * imgShowProfile = [UIImage imageNamed:@"show_profile.png"];
    UIButton *buttonShowProfile = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonShowProfile.frame = CGRectMake(30, 5, imgShowProfile.size.width, imgShowProfile.size.height);
    [buttonShowProfile setBackgroundImage:imgShowProfile forState:UIControlStateNormal];
    [buttonShowProfile addTarget:self action:@selector(showProfile) forControlEvents:UIControlEventTouchUpInside];
    
    [Helper setButton:buttonShowProfile Text:nil WithFont:nil FSize:12.0 TitleColor:nil ShadowColor:nil];
    [self.customSlidingView addSubview:buttonShowProfile];
    
     UIImage * imgFlag = [UIImage imageNamed:@"flag_icon.png"];
    UIButton *buttonFlagReport = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonFlagReport.frame = CGRectMake(140, 5, imgFlag.size.width, imgFlag.size.height);
    [buttonFlagReport setBackgroundImage:imgFlag forState:UIControlStateNormal];
    [Helper setButton:buttonFlagReport Text:nil WithFont:nil FSize:12.0 TitleColor:nil ShadowColor:nil];
    [buttonFlagReport addTarget:self action:@selector(buttonReportTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.customSlidingView addSubview:buttonFlagReport];
    
    
    
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstLaunchOver"] == NO || [[NSUserDefaults standardUserDefaults]boolForKey:@"isComeFromBackground"] == YES) {
        /* call only for first launch */
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isComeFromBackground"];
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstLaunchOver"] == NO) {
              [self deleteAllDbObject];
        }
      
        ProgressIndicator *pi =[ProgressIndicator sharedInstance];
        [pi showPIOnView:self.view withMessage:@"loading..."];
        WebServiceHandler *serviceHandler = [[WebServiceHandler alloc]init];
        serviceHandler.delegate = self;
        [serviceHandler webserviceRequestAndResponse:nil serviceType:3 facebookId:self.friendFbId];
        
    }
    else{
        NSLog(@"unID:%@%@",self.userFbId,self.friendFbId);
        
    
       
//        NSArray *storedMessages = [DBHandler dataFromTable:@"MessageTable" condition:[NSString stringWithFormat:@"senderId = %@ OR receiverId = %@",[NSNumber numberWithLongLong:self.friendFbId.longLongValue],[NSNumber numberWithLongLong:self.friendFbId.longLongValue]] orderBy:nil ascending:NO];
//        if (storedMessages.count > 0) {
//            for (int i = 0; i < 10; i++) {
//                MessageTable *msgTable = storedMessages[i];
//                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//                [dict setValue:msgTable.message forKey:@"msg"];
//                [dict setValue:msgTable.uniqueId forKey:@"uniqueId"];
//                [dict setValue:msgTable.name forKey:@"sname"];
//                [dict setValue:msgTable.date.stringValue forKey:@"date"];
//                [dict setValue:msgTable.messageDate forKey:@"dt"];
//                [dict setValue:msgTable.fId forKey:@"sfId"];
//               // NSLog(@"message :%@ Time:%@ MessageDate:%@" ,msgTable.message, msgTable.date.stringValue,msgTable.messageDate);
//                [self.mResponseArray addObject:dict];
//            }
//            
//            
//        }
    }
  
    
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(buttonBackPressed:)];
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor clearColor];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonItemStylePlain target:self action:@selector(buttonSliderPressed:)];
//     self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
//    self.navigationItem.rightBarButtonItem.tag = 100;
}
-(void)myTimerAction
{
    /*
    WebServiceHandler *serviceHandler = [[WebServiceHandler alloc]init];
    serviceHandler.delegate = self;
    [serviceHandler webserviceRequestAndResponse:nil serviceType:3 facebookId:self.friendFbId];
     */
}
-(void)addrightButton:(UINavigationItem*)naviItem
{
    // UIImage *imgButton = [UIImage imageNamed:@"chat_icon_off_line.png"];
	UIButton *rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[rightbarbutton setFrame:CGRectMake(0, 0,60, 25)];
    [rightbarbutton setTitle:@"More" forState:UIControlStateNormal];
    rightbarbutton.tag=100;
    [rightbarbutton addTarget:self action:@selector(buttonSliderPressed:) forControlEvents:UIControlEventTouchUpInside];
    naviItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
}

-(void)addBack:(UINavigationItem*)naviItem
{
    UIImage *imgButton = [UIImage imageNamed:@"chat_icon_off_line.png"];
	UIButton *rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[rightbarbutton setFrame:CGRectMake(0, 0, imgButton.size.width+20, imgButton.size.height)];
    [rightbarbutton setTitle:@"Back" forState:UIControlStateNormal];
    [rightbarbutton addTarget:self action:@selector(buttonBackPressed:) forControlEvents:UIControlEventTouchUpInside];
    naviItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
}

-(void)showProfile
{
    TinderPreviewUserProfileViewController *pc ;
    
    if (IS_IPHONE_5) {
        pc = [[TinderPreviewUserProfileViewController alloc] initWithNibName:@"TinderPreviewUserProfileViewController" bundle:nil];
    }
    else{
        pc = [[TinderPreviewUserProfileViewController alloc] initWithNibName:@"TinderPreviewUserProfileViewController_ip4" bundle:nil];
        
    }
    
    pc.userProfile = dictUser;
    pc.viewLoadFrom =CHAT_CONTROLER;
    buttonUserTitle.hidden = YES;
    buttonUserPic.hidden = YES;
    [self.navigationController pushViewController:pc animated:NO];
    
//    ProfileViewController *m = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
//    m.isMessageController =YES;
//    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:m];
//    if (PPSystemVersionGreaterOrEqualThan(5.0)) [self presentModalViewController:n animated:YES];
//    else [self.revealSideViewController presentModalViewController:n animated:YES];
//    
//    PP_RELEASE(m);
//    PP_RELEASE(n);

   
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    buttonUserPic = [UIButton buttonWithType:UIButtonTypeCustom];
//    buttonUserPic.frame= CGRectMake(110, 2, 43,43);
//    UIImage *matchedPersonImageOnNavigationBar=[JSAvatarImageFactory avatarImageNamed:self.matchedUserProfileImagePath style:JSAvatarImageStyleFlat shape:JSAvatarImageShapeCircle];
//    [buttonUserPic setBackgroundImage:matchedPersonImageOnNavigationBar forState:UIControlStateNormal];
//    [buttonUserPic addTarget:self action:@selector(buttonUserProfileTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.view addSubview:buttonUserPic];
//    
//    buttonUserTitle = [UIButton buttonWithType:UIButtonTypeCustom];
//    buttonUserTitle.frame= CGRectMake(buttonUserPic.frame.origin.x+buttonUserPic.frame.size.width-2, 5, 100,30);
//    // UIImage *matchedPersonImageOnNavigationBar=[JSAvatarImageFactory avatarImageNamed:self.matchedUserProfileImagePath style:JSAvatarImageStyleFlat shape:JSAvatarImageShapeCircle];
//    //[buttonUserPic setBackgroundImage:matchedPersonImageOnNavigationBar forState:UIControlStateNormal];
//    [buttonUserTitle setTintColor:[UIColor whiteColor]];
//    [buttonUserTitle setTitle:ChatPersonNane forState:UIControlStateNormal];
//    [buttonUserTitle addTarget:self action:@selector(buttonUserProfileTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.view addSubview:buttonUserTitle];
//}
- (void) viewDidAppear:(BOOL)animated
{
    NSArray *storedMessages = [DBHandler dataFromTable:@"MessageTable" condition:[NSString stringWithFormat:@"senderId = %@ OR receiverId = %@",[NSNumber numberWithLongLong:self.friendFbId.longLongValue],[NSNumber numberWithLongLong:self.friendFbId.longLongValue]] orderBy:nil ascending:NO];
    if (storedMessages.count > 0) {
        for (int i = 0; i < storedMessages.count; i++) {
            MessageTable *msgTable = storedMessages[i];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:msgTable.message forKey:@"msg"];
           // [dict setValue:msgTable.uniqueId forKey:@"uniqueId"];
            [dict setValue:msgTable.name forKey:@"sname"];
            [dict setValue:msgTable.date.stringValue forKey:@"date"];
            [dict setValue:msgTable.messageDate forKey:@"dt"];
            [dict setValue:msgTable.fId forKey:@"sfId"];
            // NSLog(@"message :%@ Time:%@ MessageDate:%@" ,msgTable.message, msgTable.date.stringValue,msgTable.messageDate);
            [self.mResponseArray addObject:dict];
        }
        
        
    }
    [self.tableView reloadData];
    
    
    buttonUserPic = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonUserPic.frame= CGRectMake(110, 2, 43,43);
    UIImage *matchedPersonImageOnNavigationBar=[JSAvatarImageFactory avatarImageNamed:self.matchedUserProfileImagePath style:JSAvatarImageStyleFlat shape:JSAvatarImageShapeCircle];
    [buttonUserPic setBackgroundImage:matchedPersonImageOnNavigationBar forState:UIControlStateNormal];
    [buttonUserPic addTarget:self action:@selector(buttonUserProfileTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:buttonUserPic];
    
    buttonUserTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonUserTitle.frame= CGRectMake(buttonUserPic.frame.origin.x+buttonUserPic.frame.size.width-16, 9, 100,30);
    // UIImage *matchedPersonImageOnNavigationBar=[JSAvatarImageFactory avatarImageNamed:self.matchedUserProfileImagePath style:JSAvatarImageStyleFlat shape:JSAvatarImageShapeCircle];
    //[buttonUserPic setBackgroundImage:matchedPersonImageOnNavigationBar forState:UIControlStateNormal];
    [buttonUserTitle setTintColor:[UIColor whiteColor]];
    [buttonUserTitle setTitle:ChatPersonNane forState:UIControlStateNormal];
    [buttonUserTitle addTarget:self action:@selector(buttonUserProfileTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:buttonUserTitle];
}

- (void) viewWillDisappear:(BOOL)animated
{
    NSLog(@"currentMessage%@",self.currentMessage);
    
   // if (self.currentMessage != nil &&![self.currentMessage isEqualToString:@"(null)"]&& self.currentMessage.length >0) {
       // NSString *str = [NSString stringWithFormat:@"%@:%@",self.currentMessage,self.friendFbId];
      //  [delegate1 setLastMessageText:str];
    //}
    buttonUserPic.hidden = YES;
    buttonUserTitle.hidden = YES;
    
}



-(NSArray*)getProfileImages :(NSString*)FBId
{
    TinderAppDelegate *appDelegate =(TinderAppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UploadImages" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *result=nil;
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"(fbId== %@)",
                              FBId];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    result = [context executeFetchRequest:fetchRequest error:&error];
    
    
    
    
    return  result;
}

#pragma mark -Custom Methods

- (NSDate *) stringFromDate :(NSString *)strDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:strDate];
    /*
    NSDateFormatter *dateParser = [[NSDateFormatter alloc] init];
    [dateParser setDateFormat:@"dd-MMM-yyy"];
    NSString *stringDate= [dateParser stringFromDate:date];
    NSDate *messageDate = [dateParser dateFromString:stringDate];
     */
    return date;
    
}
- (NSString *) convertGmtToLocal:(NSString *)stringTime
{
    NSString *dateString = @"2013-12-04 11:10:27 GMT";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"EN"]];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *localDateString = [dateFormatter stringFromDate:date];
    NSDate *lacalDate = [dateFormatter dateFromString:localDateString];
    NSDateFormatter *dateParser = [[NSDateFormatter alloc] init];
    [dateParser setDateFormat:@"dd-MMM-yyy"];
    NSString *chatLocalDateString = [dateParser stringFromDate:lacalDate];
    NSLog(@"Chat date :%@",chatLocalDateString);
    return chatLocalDateString;
}
- (void)eventListenerDidReceiveChatNotification:(NSNotification *)notif
{
    NSDictionary *userInfo=notif.userInfo;
    NSDictionary  *aps = [userInfo objectForKey:@"aps"];
       NSLog(@"the aps is %@",aps);
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isComeFromBackground"] == YES) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isComeFromBackground"];
        
        ProgressIndicator *pi =[ProgressIndicator sharedInstance];
        [pi showPIOnView:self.view withMessage:@"loading..."];
        WebServiceHandler *serviceHandler = [[WebServiceHandler alloc]init];
        serviceHandler.delegate = self;
        [serviceHandler webserviceRequestAndResponse:nil serviceType:3 facebookId:[aps objectForKey:@"sfId"]];
    }else{
    
   
 
    //NSString *alert = [aps objectForKey:@"alert"];
    //NSLog(@"the chat alert is %@",alert);
    
    if( !mResponseArray ){
        mResponseArray = [[NSMutableArray alloc]init];
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSArray * arraps = [[aps objectForKey:@"alert"] componentsSeparatedByString:@":"];
    [dict setValue:[arraps objectAtIndex:1] forKey:@"msg"];
    [dict setValue:[aps objectForKey:@"sFid"] forKey:@"sfId"];
    // int uniqueId = self.userFbId.intValue + self.friendFbId.intValue;
    [dict setValue:[NSString stringWithFormat:@"%@%@",self.userFbId,self.friendFbId] forKey:@"uniqueId"];
    [dict setValue:[aps objectForKey:@"sname"] forKey:@"sname"];
    // NSString *date = [self convertGmtToLocal:[aps objectForKey:@"dt"]];
    [dict setValue:[aps objectForKey:@"sFid"] forKey:@"SenderId"];
     [dict setValue:self.userFbId forKey:@"ReceiverId"];
    //ReceiverId
    //SenderId
    [dict setValue:[Helper getCurrentTime] forKey:@"dt"];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    [dict setValue:[NSNumber numberWithDouble:interval] forKey:@"date"];
   // NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
   // [dict setValue:[NSNumber numberWithDouble:interval] forKey:@"dt"];
    //[dict setValue:[Helper getCurrentDate] forKey:@"date"];
    [mResponseArray addObject:dict];
    
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:mResponseArray.count-1 inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    if (!dataBase) {
        dataBase = [[DataBase alloc]init];
    }
    [dataBase insertMessages:dict];
    }
}



- (void)buttonBackPressed:(UIBarButtonItem *)sender
{
    
         //done button
    self.navigationItem.rightBarButtonItem.title =@"Back";
    self.navigationItem.rightBarButtonItem.tintColor =[UIColor whiteColor];
   
   
    HomeViewController *c;
    if (IS_IPHONE_5) {
        c = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    }
    else{
        c = [[HomeViewController alloc] initWithNibName:@"HomeViewController_ip4" bundle:nil];
    }
    c.didUserLoggedIn = YES;
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
    [self.revealSideViewController popViewControllerWithNewCenterController:n
                                                                   animated:YES];
    PP_RELEASE(c);
    PP_RELEASE(n);

    
   // CGRect rect = CGRectMake(0, -44, customSlidingView.frame.size.width, customSlidingView.frame.size.height);
//    rect.origin.y = 0;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.2];
//    [customSlidingView setFrame:rect];
//    [UIView commitAnimations];
}


#pragma mark - UIButton Action
- (void)buttonSliderPressed:(UIBarButtonItem *)sender
{
    UIImage * imgblock = [UIImage imageNamed:@"block_icon.png"];
    UIImage * imgUnblock = [UIImage imageNamed:@"unblock_icon-1.png"];
    
    
    
    
    if (sender.tag == 100) {  //sliding is not done
        sender.tag = 200;       //done button

       
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"BLOCK"]==YES)
        {
            [buttonBlockUser setBackgroundImage:imgblock forState:UIControlStateNormal];
        }else{
            [buttonBlockUser setBackgroundImage:imgUnblock forState:UIControlStateNormal];
        }

        
        
        CGRect rect = CGRectMake(0, -44, customSlidingView.frame.size.width, customSlidingView.frame.size.height);
        rect.origin.y = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [customSlidingView setFrame:rect];
        [UIView commitAnimations];
    }else{
        sender.tag = 100; //More button
        
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"BLOCK"]==YES)
        {
            [buttonBlockUser setBackgroundImage:imgblock forState:UIControlStateNormal];
        }else{
            [buttonBlockUser setBackgroundImage:imgUnblock forState:UIControlStateNormal];
        }

        CGRect rect = CGRectMake(0, 0, customSlidingView.frame.size.width, customSlidingView.frame.size.height);
        rect.origin.y = -44;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [customSlidingView setFrame:rect];
        [UIView commitAnimations];
    }
}

- (void) buttonUserProfileTapped :(UIButton *)sender
{
    TinderPreviewUserProfileViewController *pc ;
    
    if (IS_IPHONE_5) {
        pc = [[TinderPreviewUserProfileViewController alloc] initWithNibName:@"TinderPreviewUserProfileViewController" bundle:nil];
    }
    else{
        pc = [[TinderPreviewUserProfileViewController alloc] initWithNibName:@"TinderPreviewUserProfileViewController_ip4" bundle:nil];
        
    }

    pc.userProfile = dictUser;
    pc.viewLoadFrom =CHAT_CONTROLER;
    buttonUserTitle.hidden = YES;
    buttonUserPic.hidden = YES;
    [self.navigationController pushViewController:pc animated:NO];


}
- (void) buttonBlockTapped:(UIButton *)sender{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"BLOCK"]==YES)
    {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Are you sure you want to Unblock this user?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alertView.tag =100;
        [alertView show];

            }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Are you sure you want to block this user?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alertView.tag =200;
        [alertView show];

        }
    

    
   
}

- (void) buttonReportTapped:(UIButton *)sender{
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    //NSData *imgData=UIImagePNGRepresentation(qrimgvew.image);
    [controller setSubject:@"Invite to join TinderClone!"];
    [controller setMessageBody:@"Please download the Tinderclone App from www.TinderClone.com" isHTML:NO];
    NSMutableArray *emails = [[NSMutableArray alloc] initWithObjects:@"gaurav@roadyo.net", nil];
    [controller setToRecipients:[NSArray arrayWithArray:(NSArray *)emails]];
    if (controller) [self presentViewController:controller animated:YES completion:nil];
}

-(void)deleteAllDbObject
{
    TinderAppDelegate *appDelegate =(TinderAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MessageTable" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray*fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *fetchedCategorList=[[NSMutableArray alloc]initWithArray:fetchedObjects];
    
    for (NSManagedObject *managedObject in fetchedCategorList)
    {
    	[context deleteObject:managedObject];
    	//DLog(@"%@ object deleted",entityDescription);
    }
    if (![context save:&error]) {
    	//NSLog(@"Error deleting %@ - error:",error);
    }
    
    
}

#pragma mark - Messages view delegate: OPTIONAL
-(void) moveSlidingViewToDefaultFrame{
    UIBarButtonItem * btn = self.navigationItem.rightBarButtonItem;
    
        if (btn.tag == 200) {
            [self buttonSliderPressed:btn];
        }

}

#pragma mark - Messages view delegate: REQUIRED

- (void)didSendText:(NSString *)text
{
    self.currentMessage = text;
    
    if (self.status.intValue ==  4) { // Blocked
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Do you want to unblock user?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = 100;
        [alert show];
    }else{
        NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
        NSDictionary * dictUser1 =[ud objectForKey:@"FBUSERDETAIL"];
     
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:text forKey:@"msg"];
        [dict setValue:self.userFbId forKey:@"sfId"];
        [dict setValue:self.userFbId forKey:@"SenderId"];
        [dict setValue:self.friendFbId forKey:@"ReceiverId"];
        [dict setValue:[dictUser1 objectForKey:FACEBOOK_FIRSTNAME] forKey:@"sname"];
        [dict setValue:[NSString stringWithFormat:@"%@%@",self.userFbId,self.friendFbId] forKey:@"uniqueId"];
        [dict setValue:[Helper getCurrentTime] forKey:@"dt"];
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
        [dict setValue:[NSNumber numberWithDouble:interval] forKey:@"date"];
        if (!self.mResponseArray) {
            self.mResponseArray = [[NSMutableArray alloc]init];
        }
        [mResponseArray addObject:dict];
         NSLog(@"dict :%@",dict);
        [self.tableView beginUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:mResponseArray.count-1 inSection:0];
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        
        
        WebServiceHandler *serviceHandler = [[WebServiceHandler alloc]init];
        serviceHandler.delegate = self;
        [serviceHandler webserviceRequestAndResponse:text serviceType:2 facebookId:self.friendFbId];
        
        
        
        if (!dataBase) {
            dataBase = [[DataBase alloc]init];
        }
        [dataBase insertMessages:dict];
        
        [self finishSend];
        [self scrollToBottomAnimated:YES];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"no of row :%d",self.mResponseArray.count);
    return self.mResponseArray.count;
}


- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   // NSLog(@"messageTypeForRowAtIndexPath :%d",indexPath.row);

    NSString  *senderId = mResponseArray[indexPath.row][@"sfId"];
    
    if ([senderId isEqualToString:self.userFbId]) {
        
        return  JSBubbleMessageTypeOutgoing;
    }else{
        
        return JSBubbleMessageTypeIncoming;
    }
    
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type
                       forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *senderId = mResponseArray[indexPath.row][@"sfId"];
    if ([senderId isEqualToString:self.userFbId]) {
        
        return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                          color:[UIColor js_iOS7lightGrayColor]];
    }
    
    
    return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                      color:[UIColor js_iOS7blueColor]];
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyEveryThree;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyAll;
}

- (JSMessagesViewSubtitlePolicy)subtitlePolicy
{
    return JSMessagesViewSubtitlePolicyAll;
}

- (JSMessageInputViewStyle)inputViewStyle
{
    return JSMessageInputViewStyleFlat;
}

#pragma mark - Messages view delegate: OPTIONAL

//
//  *** Implement to customize cell further
//
- (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
  //  NSLog(@"configureCell");
    if([cell messageType] == JSBubbleMessageTypeOutgoing) {
        [cell.bubbleView setTextColor:[UIColor whiteColor]];
        
        
    }
    if(cell.timestampLabel) {
        cell.timestampLabel.textColor = [UIColor lightGrayColor];
        cell.timestampLabel.shadowOffset = CGSizeZero;
    }
    
    if(cell.subtitleLabel) {
        cell.subtitleLabel.textColor = [UIColor lightGrayColor];
    }
}

//  *** Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

//  *** Implement to use a custom send button
//
//  The button's frame is set automatically for you
//
//  - (UIButton *)sendButtonForInputView
//

//  *** Implement to prevent auto-scrolling when message is added
//
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}

#pragma mark - Messages view data source: REQUIRED

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"text:%@",mResponseArray[indexPath.row][@"msg"]);
    return mResponseArray[indexPath.row][@"msg"];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // NSLog(@"date :%@",mResponseArray[indexPath.row][@"dt"]);
    
   // NSDate *date = [self stringFromDate:mResponseArray[indexPath.row][@"dt"]];
    return [NSDate date];
    
    
}



- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString  *senderId = mResponseArray[indexPath.row][@"sfId"];
    UIImage *img = Nil;
  //  UIImage *imgP = [UIImage imageWithContentsOfFile:strProfile];
    if ([senderId isEqualToString:self.userFbId]) {
        
        img =  [JSAvatarImageFactory avatarImageNamed:strProfile style:JSAvatarImageStyleFlat shape:JSAvatarImageShapeCircle];
       // img = imgP;
    }else{
        img =  [JSAvatarImageFactory avatarImageNamed:matchedUserProfileImagePath style:JSAvatarImageStyleFlat shape:JSAvatarImageShapeCircle];
    }
   return [[UIImageView alloc] initWithImage:img];
    
}


- (NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // return mResponseArray[indexPath.row][@"sname"];
    return Nil;
}

//#pragma mark -UIScrollViewDelegate

//- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    UIBarButtonItem * btn = self.navigationItem.rightBarButtonItem;
//    
//    if (btn.tag == 200) {
//        [self buttonSliderPressed:btn];
//    }
//    
//}


#pragma mark - Webservice response Delegate

- (void)getServiceResponseDelegate:(NSDictionary *)responseDict serviceType:(int)type error:(NSError *)error
{
    ProgressIndicator *pi =[ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    
    if (error == nil) {
        
        if ([[responseDict objectForKey:@"errFlag"]intValue] == 0) {
            [self deleteAllDbObject];
            NSLog(@"success");
            if (type == 3) {   // getMessage History response
               [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstLaunchOver"];
                NSArray *arrayResponse = [[responseDict objectForKey:@"chat"] mutableCopy];
                
                if (!dataBase) {
                    dataBase = [[DataBase alloc]init];
                    [self deleteAllDbObject];

                }
                if (arrayResponse.count > 0) {
                    NSString *uniqueId =[NSString stringWithFormat:@"%@%@",self.userFbId,self.friendFbId];
                    dataBase.delegate = self;
                    [self deleteAllDbObject];
                    [dataBase insertMessageForFirstlaunch:arrayResponse uniqueId:uniqueId];
                    //[self.tableView reloadData];
                }
                
                
            }else if (type == 4 || type == 5) {  //blockUser or UnblockUser Response
                /* update MatchedUserList Table in database  */
                
                TinderAppDelegate *appDelegate = (TinderAppDelegate *)[[UIApplication sharedApplication] delegate];
                NSManagedObjectContext *context = [appDelegate managedObjectContext];
                NSArray *blockedUserProfile = [DBHandler dataFromTable:@"MatchedUserList" condition:[NSString stringWithFormat:@"fId == %@",self.friendFbId] orderBy:nil ascending:NO];
                if (blockedUserProfile.count > 0) {
                    MatchedUserList *matchedUser = [blockedUserProfile objectAtIndex:0];
                    if (type == 4) {
                        matchedUser.status = @"4"; //blocking user
                        self.status = @"4";
                    }else{
                        matchedUser.status = @"3"; // unblocking user
                        self.status = @"3";
                    }
                    
                    NSError *error;
                    if ( [context save:&error]) {
                        
                    }
                    
                    
                }
            }
        }
    }else{
        NSLog(@"error");
    }
}

- (void)dataInsertedSucessfullyInDb:(BOOL)success
{
    if (!mResponseArray) {
        mResponseArray = [[NSMutableArray alloc]init];
    }
    
    //NSString *str =[NSString stringWithFormat:@"%@%@",self.userFbId,self.friendFbId];
   // NSArray *storedMessages = [DBHandler dataFromTable:@"MessageTable" condition:[NSString stringWithFormat:@"uniqueId LIKE '%@'",str] orderBy:nil ascending:NO];
       NSArray *storedMessages = [DBHandler dataFromTable:@"MessageTable" condition:[NSString stringWithFormat:@"senderId = %@ OR receiverId = %@",[NSNumber numberWithLongLong:self.friendFbId.longLongValue],[NSNumber numberWithLongLong:self.friendFbId.longLongValue]] orderBy:@"messageDate" ascending:YES];
    if (storedMessages.count > 0) {
        for (int i = 0; i < storedMessages.count; i++) {
            MessageTable *msgTable = storedMessages[i];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:msgTable.message forKey:@"msg"];
            [dict setValue:msgTable.uniqueId forKey:@"uniqueId"];
            [dict setValue:msgTable.name forKey:@"sname"];
            [dict setValue:msgTable.messageDate forKey:@"dt"];
            [dict setValue:msgTable.date.stringValue forKey:@"date"];
            [dict setValue:msgTable.fId forKey:@"sfId"];
             [dict setValue:msgTable.senderId.stringValue forKey:@"SenderId"];
             [dict setValue:msgTable.receiverId.stringValue forKey:@"ReceiverId"];
           
            [self.mResponseArray addObject:dict];
        }
        
        
    }
    NSLog(@"arrValue after inserted in Db :%@",self.mResponseArray);
    [self.tableView reloadData];
    
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    WebServiceHandler *webserviceHandler = [[WebServiceHandler alloc]init];
    webserviceHandler.delegate = self;
    NSUserDefaults *userDeafults = [NSUserDefaults standardUserDefaults];
    if(buttonIndex == 1){
        
       
        if (alertView.tag == 100) {
            // unblock user
            [userDeafults setBool:NO forKey:@"BLOCK"];
            [buttonBlockUser setBackgroundImage:[UIImage imageNamed:@"unblock_icon-1.png"] forState:UIControlStateNormal];
           ;
            
            [webserviceHandler webserviceRequestAndResponse:nil serviceType:5 facebookId:self.friendFbId];
        
        }
        else
        {/*block user service call */
        
          
           [buttonBlockUser setBackgroundImage:[UIImage imageNamed:@"block_icon.png"] forState:UIControlStateNormal];
            UIBarButtonItem * btn = self.navigationItem.rightBarButtonItem;
            if (btn.tag == 200) {
               
                [self buttonSliderPressed:btn];
            }
             [userDeafults setBool:YES forKey:@"BLOCK"];
            [webserviceHandler webserviceRequestAndResponse:nil serviceType:4 facebookId:self.friendFbId];
            
        }
        
        [userDeafults synchronize];
    }
}
#pragma mark- MailDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
