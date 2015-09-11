
//
//  HomeViewController.m
//  Tinder
//
//  Created by Rahul Sharma on 24/11/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "HomeViewController.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "RoundedImageView.h"
#import "UploadImages.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "AppConstants.h"
#import "Login.h"
#import "TinderGenericUtility.h"
#import "TinderPreviewUserProfileViewController.h"

@interface HomeViewController ()
{
    
    BOOL inAnimation;
    
    CALayer *waveLayer;
    
    NSTimer *animateTimer;
    
    RoundedImageView *profileImageView;
    
    NSMutableArray * arr ;
    
    NSArray *  profileImg;
    
    CGPoint original;
    
    NSMutableArray *myProfileMatches;
    
    IBOutlet UIView *matchesView;
    IBOutlet UIView *visibleView1;
    IBOutlet UIView *visibleView2;
    
    IBOutlet UIImageView *mainImageView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *nameLabel2;
    IBOutlet UILabel *commonFriends;
    IBOutlet UILabel *picsCount;
    IBOutlet UILabel *commonInterest;
    
    
    IBOutlet UILabel *lblMutualFriend;
    IBOutlet UILabel *lblMutualLikes;
    IBOutlet UILabel *lblMutualFriend2;
    IBOutlet UILabel *lblMutualLikes2;
    
    CLLocationManager *clManager;
    NSTimer *locationUpdateTimer;
    
}

@property (nonatomic, strong, readonly) IBOutlet UIImageView *imgvw;
@property (nonatomic, strong) IBOutlet UILabel *decision;
@property (nonatomic, strong) IBOutlet UILabel *liked;
@property (nonatomic, strong) IBOutlet UILabel *nope;
@property (nonatomic, strong) IBOutlet UIButton *likedBtn;
@property (nonatomic, strong) IBOutlet UIButton *nopeBtn;
@property (nonatomic, strong) IBOutlet UILabel *lblNoOfImage;


@end

@implementation HomeViewController
@synthesize dictLoginUsrdetail;
@synthesize arrFBImageUrl;
@synthesize strProfileUrl;
@synthesize flag;
@synthesize loginView;
@synthesize imgvw;
@synthesize liked;
@synthesize nope;
@synthesize lblNoOfImage;
@synthesize didUserLoggedIn;
@synthesize _loadViewOnce;

//dispatch_queue_t backgroundQueue;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        // Custom initialization
    }
    return self;
}
#pragma mark -View cycle

- (void)viewDidLoad
{
    
    
    
    
    //    NSArray *familyNames = [UIFont familyNames];
	
    //	for( NSString *familyName in familyNames ){
    //		printf( "Family: %s \n", [familyName UTF8String] );
    //
    //		NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
    //		for( NSString *fontName in fontNames ){
    //			printf( "\tFont: %s \n", [fontName UTF8String] );
    //
    //		}
    //	}
    //    [NSThread detachNewThreadSelector:@selector(start) toTarget:self withObject:nil];
    
    self.loginView.readPermissions = @[@"user_photos"];
    arr = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.translucent = NO;
    appDelegate =(TinderAppDelegate*) [[UIApplication sharedApplication]delegate];
    self.navigationController.navigationBarHidden = NO;
    [appDelegate addBackButton:self.navigationItem];
    [self.navigationItem setTitle:@"Flamer"];
    [appDelegate addrightButton:self.navigationItem];
    
    [self.revealSideViewController setDirectionsToShowBounce: PPRevealSideDirectionLeft | PPRevealSideDirectionRight ];
    self.revealSideViewController.delegate = self;
    [super viewDidLoad];
    
    lblNoFriendAround.hidden = NO;
    btnInvite.hidden = YES;
    [Helper setButton:btnInvite Text:@"Invite your friends!" WithFont:SEGOUE_UI FSize:14 TitleColor:[UIColor grayColor] ShadowColor:nil];
    [btnInvite.titleLabel setTextAlignment:NSTextAlignmentCenter];
    btnInvite.titleEdgeInsets = UIEdgeInsetsMake(-6, 15.0, 0.0, 0.0);
    [Helper setToLabel:lblNoFriendAround Text:@"Finding People around you." WithFont:SEGOUE_UI FSize:17 Color:[UIColor blackColor]];
    lblNoFriendAround.textAlignment = NSTextAlignmentCenter;
    
    [imgvw.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [imgvw.layer setBorderWidth: 0.7];
    [mainImageView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [mainImageView.layer setBorderWidth: 0.7];
    
    
    if (IS_IPHONE_5) {
        profileImageView = [[RoundedImageView alloc] initWithFrame:CGRectMake(105, 170, 110, 110)];
    }
    else{
        profileImageView = [[RoundedImageView alloc] initWithFrame:CGRectMake(105, 130, 110, 110)];
    }
    
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    profileImageView.clipsToBounds = YES;
    profileImageView.image = [UIImage imageNamed:@"pfImage.png"];
    
    [self.view addSubview:profileImageView];
    
    
    
    // BOOL userPic = [[NSUserDefaults standardUserDefaults] boolForKey:@"UserProfilePic"];
    
    viewItsMatched.backgroundColor = [Helper getColorFromHexString:@"#000000" :1.0];
    inAnimation = NO;
    waveLayer=[CALayer layer];
    if (IS_IPHONE_5) {
        waveLayer.frame = CGRectMake(155, 220, 10, 10);
    }
    else
    {
        waveLayer.frame = CGRectMake(155, 180, 10, 10);
    }
    //waveLayer.borderColor =[UIColor colorWithRed:10 green:10 blue:10 alpha:1].CGColor;
    //waveLayer.backgroundColor = [UIColor colorWithRed:210 green:105 blue:30 alpha:1].CGColor;
    waveLayer.borderWidth =0.2;
    waveLayer.cornerRadius =5.0;
    [self.view.layer addSublayer:waveLayer];
    profileImageView.hidden = YES;
    [waveLayer setHidden:YES];
    [self.view bringSubviewToFront:profileImageView];
    
    
    //    if (!userPic)
    //    {
    //       // [[ProgressIndicator sharedInstance] showPIOnWindow:appDelegate.window withMessge:@"loading.."];
    //        [TinderFBFQL executeFQlForProfileImage:self];
    //
    //         profileImageURL = @"https://fbcdn-profile-a.akamaihd.net/static-ak/rsrc.php/v2/yL/r/HsTZSDw4avx.gif";
    //         NSUserDefaults * ud =[NSUserDefaults standardUserDefaults];
    //        [ud setObject:profileImageURL forKey:@"FBPROFILEURL"];
    //        //[self performSelectorInBackground:@selector(loadProfileImage:) withObject:profileImageURL];
    //    }
    //    else
    //    {
    //        NSUserDefaults * ud =[NSUserDefaults standardUserDefaults];
    //        profileImageURL = [ud objectForKey:@"FBPROFILEURL"];
    //        [self performSelectorInBackground:@selector(loadProfileImage:) withObject:profileImageURL];
    //
    //    }
    
    
    
    NSLog(@"addprogressindicator");
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Uploading profile.."];
    NSString *profileImageURL = nil;
    if (didUserLoggedIn)
    {
        
        [pi hideProgressIndicator];
        NSUserDefaults * ud =[NSUserDefaults standardUserDefaults];
        profileImageURL = [ud objectForKey:@"FBPROFILEURL"];
        [ud setBool:YES forKey:@"IsUploaded"];
        NSLog(@"rahul user logged In %d",[ud boolForKey:@"IsUploaded"]);
        [self performSelectorInBackground:@selector(loadProfileImage:) withObject:profileImageURL];
        
    }
    else
    {
        
        profileImageURL = @"https://fbcdn-profile-a.akamaihd.net/static-ak/rsrc.php/v2/yL/r/HsTZSDw4avx.gif";
        NSUserDefaults * ud =[NSUserDefaults standardUserDefaults];
        [ud setBool:NO forKey:@"IsUploaded"];
        NSLog(@"rahul user signup In %d",[ud boolForKey:@"IsUploaded"]);
        [ud setObject:profileImageURL forKey:@"FBPROFILEURL"];
        [TinderFBFQL executeFQlForProfileImage:self];
        
        
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //[self sendRequestForGetMatches];
    
    // profileImageView.backgroundImage = [UIImage imageNamed:@"map_boader.png"];
    
    //CGPoint touchPoint = profileImageView.center;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)start
{
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Uploading profile.."];
}
-(void)viewDidAppear:(BOOL)animated{
    
    
    PPRevealSideInteractions interContent = PPRevealSideInteractionContentView;
    self.revealSideViewController.panInteractionsWhenClosed = interContent;
    self.revealSideViewController.panInteractionsWhenOpened = interContent;
    NSLog(@"viewdidapper");
    
    if (!_loadViewOnce)
    {
        
        NSLog(@"load once");
        _loadViewOnce = YES;
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsUploaded"] ==YES) {
            
            
            [self performSelector:@selector(sendRequestForGetMatches) withObject:nil afterDelay:3];
        }
        else
        {
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsUploaded"];
        }
        
        
        
        ///do want you wanna to do.
    }
    
    [self performSelector:@selector(startAnimation) withObject:nil];
    
    
    
    
    [self performSelector:@selector(preloadLeft) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(preLoadRight) withObject:nil afterDelay:0.3];
    
}
-(void)preloadLeft
{
    
    MenuViewController *menu=[[MenuViewController alloc]initWithNibName:@"MenuViewController" bundle:nil];
    // [self.revealSideViewController pushViewController:menu onDirection:PPRevealSideDirectionLeft withOffset:62 animated:YES];
    [self.revealSideViewController preloadViewController:menu forSide:PPRevealSideDirectionLeft];
    PP_RELEASE(menu);
    
    //[self preLoadRight];
}
-(void)preLoadRight
{
    ChatViewController *menu = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
    menu.needToCallWebservice = NO;
    [self.revealSideViewController preloadViewController:menu forSide:PPRevealSideDirectionRight];
    PP_RELEASE(menu);
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    // ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    //[pi showPIOnView:self.view withMessage:@"Uploading profile.."];
    
    
    
    NSLog(@"viewwillappear");
    
    
}

-(void)threadAnimates
{
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Uploading profile.."];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -ForGetDBImage
-(NSArray*)getProfileImages :(NSString*)FBId
{
    NSLog(@"fbId %@",FBId);
    //TinderAppDelegate *appDelegate =(TinderAppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UploadImages" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *result=nil;
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"(fbId== %@)",
                              FBId];
    [fetchRequest setPredicate:predicate];
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"imageUrlLocal" ascending:YES]];
    
    NSError *error = nil;
    result = [context executeFetchRequest:fetchRequest error:&error];
    return  result;
}


#pragma mark-UploadImageRequest

-(void)uploadImage:(NSArray*)arrProfile
{
    if (arrProfile.count>0) {
        
        
        
        NSMutableString *strOtherImage = [[NSMutableString alloc]init];
        NSString * profile = nil;
        for (int k = 0; k < arrProfile.count; k++) {
            
            if (k == 0) {
                profile = arrProfile[k];
            }
            else{
                [strOtherImage appendString:[NSString stringWithFormat:@"%@,",arrProfile[k]]];
            }
            
        }
        
        NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
        NSString * strUUID = nil;
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            strUUID = [oNSUUID UUIDString];
        } else
        {
            strUUID = [oNSUUID UUIDString];
            
        }
        NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
        [paramDict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN"] forKey:RPSessionToken];
        [paramDict setObject:flStrForStr(strUUID)  forKey:RPDeviceId];
        [paramDict setObject:flStrForStr(profile)  forKey:RPUploadImageProfileImage];
        [paramDict setObject:flStrForStr(strOtherImage)  forKey:RPUploadImageOtherUrl];
        
        WebServiceHandler *handler = [[WebServiceHandler alloc] init];
        handler.requestType = eParseKey;
        NSMutableURLRequest * request = [Service parseUploadImages:paramDict];
        [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(UploadImagesResponse::)];
    }
    else{
        return;
    }
    
    
}

-(void)UploadImagesResponse:(NSDictionary*)_response :(NSArray*)arrUpload
{
    NSLog(@"response %@",_response);
    
    if (!_response) {
		NSLog(@"getSetsResponse: No Response");
	}
    
    if (_response == nil) {
        
        // surener : loop hole (call upload images again here)
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Connection Timeout." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
        alert.tag = 500;
        [alert show];
        
    }
    else
    {
        if (_response != nil)
        {
            
            NSDictionary *dict = [_response objectForKey:@"ItemsList"];
            NSLog(@"dict%@",dict);
            
            if ([[dict objectForKey:@"errFlag"] intValue]==0 && [[dict objectForKey:@"errNum"] intValue] == 18) {
                
                
                NSLog(@"upload success");
                
            }
            else
            {
                NSLog(@"upload not succes");
                
                [self uploadImage:arrUpload];
                
            }
            
            
            
        }
        
    }
    
    
}


#pragma mark- requestForGetMatches

-(void)sendRequestForGetMatches
{
    
    /// [[ProgressIndicator sharedInstance]hideProgressIndicator];
    
    NSLog(@"getmatches_calling");
    
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString * strUUID = nil;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        strUUID = [oNSUUID UUIDString];
    } else {
        strUUID = [oNSUUID UUIDString];
        
    }
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN"] forKey:RPSessionToken];
    [paramDict setObject:strUUID  forKey:RPDeviceId];
    NSLog(@"getmatch%@",paramDict);
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    handler.requestType = eParseKey;
    NSMutableURLRequest * request = [Service parseGetFindMatches:paramDict];
    [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(matchesResponse:)];
    
}

-(void)matchesResponse:(NSDictionary*)_response
{
    
    NSLog(@"match %@",_response);
    //[[ProgressIndicator sharedInstance] hideProgressIndicator];
    if (!_response) {
		NSLog(@"getSetsResponse: No Response");
	}
    //NSLog(@"response %@",_response);
    if (_response == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Connection Timeout." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
        alert.tag = 400;
        [alert show];
    }
    else
    {
        
        NSDictionary * dict = [_response objectForKey:@"ItemsList"];
        
        if ([dict[@"errNum"] integerValue] == 21 && [dict[@"errFlag"] integerValue] == 1) {
            
            [Helper setToLabel:lblNoFriendAround Text:@"There's no one new around you." WithFont:SEGOUE_UI FSize:17 Color:[UIColor blackColor]];
            btnInvite.hidden = NO;
            lblNoFriendAround = NO;
            
        }
        
        if ([dict[@"errNum"] integerValue] == 31 && [dict[@"errFlag"] integerValue] == 1) {
            
            [Helper setToLabel:lblNoFriendAround Text:@"There's no one new around you." WithFont:SEGOUE_UI FSize:17 Color :[UIColor blackColor]];
            btnInvite.hidden = NO;
            lblNoFriendAround = NO;
            
        }
        
        if ([dict[@"errNum"] integerValue] == 19 && [dict[@"errFlag"] integerValue] == 1) {
            
            [Helper setToLabel:lblNoFriendAround Text:@"Change any preferences to get match." WithFont:SEGOUE_UI FSize:17 Color :[UIColor blackColor]];
            
            btnInvite.hidden = NO;
            lblNoFriendAround = NO;
            
            //  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            //            NSArray *arrLog = [[DataBase sharedInstance] getLoginData];
            //
            //            Login *login = nil;
            //            if ([arrLog count] > 0) {
            //                login = [arrLog objectAtIndex:0];
            //            }
            //            else {
            //                return;
            //            }
            //
            //
            //            NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
            //            NSString * strUUID = nil;
            //            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            //
            //                strUUID = [oNSUUID UUIDString];
            //
            //            } else {
            //
            //                strUUID = [oNSUUID UUIDString];
            //
            //
            //            }
            //            //int distance = 100;
            //
            //            NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
            //            [paramDict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN"] forKey:RPSessionToken];
            //            [paramDict setObject:strUUID  forKey:RPDeviceId];
            //            [paramDict setObject:login.gender forKey:RPUpdatePreferedSex];
            //            [paramDict setObject:login.prefsex forKey:RPUpdatePreferedPrefSex];
            //            [paramDict setObject:login.lowerage forKey:RPUpdatePreferedLowerAge];
            //            [paramDict setObject:login.maxage forKey:RPUpdatePreferedUpperAge];
            //            [paramDict setObject:@(100) forKey:RPUpdatePreferedRadius];
            //
            //            WebServiceHandler *handler = [[WebServiceHandler alloc] init];
            //            handler.requestType = eParseKey;
            //            NSMutableURLRequest * request = [Service parseGetUpdatePrefrences:paramDict];
            //            [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(updatePreference:)];
            
        }
        else if ([dict[@"errNum"] integerValue] == 20 && [dict[@"errFlag"] integerValue] == 0)
        {
            NSArray *matches = dict[@"matches"];
            
            if ([matches count] > 0) {
                //[self performSelector:@selector(fetchMatchesData:) withObject:matches afterDelay:1];
                
                [self performSelectorOnMainThread:@selector(fetchMatchesData:) withObject:matches waitUntilDone:NO];
            }
        }
        else{
            [Helper setToLabel:lblNoFriendAround Text:@"There's no one new around you." WithFont:SEGOUE_UI FSize:17 Color :[UIColor blackColor]];
            btnInvite.hidden = NO;
            lblNoFriendAround = NO;
        }
    }
    ////[pi hideProgressIndicator];
}

-(void)fetchMatchesData:(NSArray*)matches
{
    
    NSLog(@"matchesCount %d",matches.count);
    //UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://fbcdn-profile-a.akamaihd.net/static-ak/rsrc.php/v2/yL/r/HsTZSDw4avx.gif"]]];
    
    int interest;
    myProfileMatches  = [[NSMutableArray alloc] initWithArray:matches];
    NSMutableArray *arrForFilter=[[NSMutableArray alloc]init];
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    
    NSString *strForiD=[pref objectForKey:@"fbidd"];
    for(int i=0;i<[myProfileMatches count];i++)
    {
        NSMutableDictionary *dict=[myProfileMatches objectAtIndex:i];
        NSString *str=[dict valueForKey:@"fbId"];
        if([str isEqualToString:strForiD])
        {
            [myProfileMatches removeObjectAtIndex:i];
        }
    }
    
    interest=[pref integerForKey:@"INTREST"];
    
    if(interest!=3)
    {
        for(int i=0;i<[myProfileMatches count];i++)
        {
            NSMutableDictionary *dict=[myProfileMatches objectAtIndex:i];
            NSString *str=[dict valueForKey:@"sex"];
            if(interest==[str intValue])
            {
                [arrForFilter addObject:dict];
            }
        }
        myProfileMatches  = [[NSMutableArray alloc] initWithArray:arrForFilter];
        
    }
    if(myProfileMatches.count>0)
    {
    NSMutableDictionary *dictForMutal=[myProfileMatches objectAtIndex:0];
    [TinderFBFQL executeFQlForMutualFriendForId:nil andFriendId:[dictForMutal valueForKey:@"fbId"] andDelegate:self];
    [TinderFBFQL executeFQlForMutualLikesForId:nil andFriendId:[dictForMutal valueForKey:@"fbId"] andDelegate:self];


    // NSLog(@"profilematch%@",myProfileMatches);
    // NSDictionary * dict =[myProfileMatches objectAtIndex:0];
    //[self performSelectorOnMainThread:@selector(executeFQl:) withObject:dict[@"fbId"] waitUntilDone:NO];
    
    for (NSDictionary *match in myProfileMatches) {
        
        if ([flStrForObj([match objectForKey:@"pPic"]) length] > 0) {
            [self imageDownloader:match[@"pPic"] forId:match[@"fbId"]];
        }
        else{
            [self imageDownloader:match[@"https://fbcdn-profile-a.akamaihd.net/static-ak/rsrc.php/v2/yL/r/HsTZSDw4avx.gif"] forId:match[@"fbId"]];
        }
    }
    }
    
}
-(void)executeFQl :(NSString *)FBId
{
    [TinderFBFQL executeFQlForMatchProfileForId:FBId andDelegate:self];
}
-(void)imageDownloader:(NSString*)url forId:(NSString*)fbid
{
    
    NSString *tmpDir = NSTemporaryDirectory();
    
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:url]
                                                        options:0
                                                       progress:^(NSUInteger receivedSize, long long expectedSize)
     {
         // progression tracking code
     }
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished)
         {
             // do something with image
             
             NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
             
             NSString *savePath = [tmpDir stringByAppendingPathComponent:fbid];
             
             
             [data writeToFile:[savePath stringByAppendingPathExtension:@"jpg"] atomically:YES];
             
             [self performSelectorOnMainThread:@selector(doneDownloadingImageFor:) withObject:fbid waitUntilDone:NO];
             //[self performSelector:@selector(doneDownloadingImageFor:) withObject:fbid afterDelay:1];
             
         }
     }];
}

-(void)doneDownloadingImageFor:(NSString*)fbid
{
    
    
    // NSLog(@"doneDownloadingImageFor");
    static NSInteger count = 0;
    
    count++;
    
    
    
    if (count != [myProfileMatches count])
    {
        lblNoFriendAround.hidden = YES;
        
        NSLog(@"loop");
        
        
        NSDictionary *match = [myProfileMatches objectAtIndex:0];
        mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        mainImageView.clipsToBounds = YES;
        
        NSString *savePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:match[@"fbId"]] stringByAppendingPathExtension:@"jpg"];
        
        NSLog(@"%@",savePath);
        
        mainImageView.image = [UIImage imageWithContentsOfFile:savePath];
        
        //[nameLabel setText:[NSString stringWithFormat:@"%@, %@", match[@"firstName"], match[@"age"]]];
        [Helper setToLabel:nameLabel Text:[NSString stringWithFormat:@"%@, %@", match[@"firstName"], match[@"age"]] WithFont:HELVETICALTSTD_ROMAN FSize:13 Color: WHITE_COLOR] ;
        [Helper setToLabel:commonFriends Text:@"0" WithFont:HELVETICALTSTD_LIGHT FSize:19 Color: WHITE_COLOR] ;
       // [Helper setToLabel:commonInterest Text:[NSString stringWithFormat:@"%@", match[@"sharedLikes"]] WithFont:HELVETICALTSTD_LIGHT FSize:19 Color: WHITE_COLOR] ;
        [Helper setToLabel:picsCount Text:[NSString stringWithFormat:@"0%@", match[@"imgCnt"]] WithFont:HELVETICALTSTD_LIGHT FSize:19 Color: WHITE_COLOR] ;
        picsCount.text=@"00";
        
        [waveLayer setHidden:YES];
        [profileImageView setHidden:YES];
        [btnInvite setHidden:YES];
        [lblNoFriendAround setHidden:YES];
        
        
        [matchesView setHidden:NO];
        [btnInvite setHidden:YES];
        
        
        original = visibleView1.center;
        visibleView1.hidden = NO;
        
        if (count > 1)
        {
            visibleView2.hidden = NO;
            imgvw.contentMode = UIViewContentModeScaleAspectFill;
            imgvw.clipsToBounds = YES;
            NSDictionary *match1 = [myProfileMatches objectAtIndex:1];
            NSString *savePath1 = [[NSTemporaryDirectory() stringByAppendingPathComponent:match1[@"fbId"]] stringByAppendingPathExtension:@"jpg"];
            
            imgvw.image = [UIImage imageWithContentsOfFile:savePath1];
            
            [Helper setToLabel:nameLabel2 Text:[NSString stringWithFormat:@"%@, %@", match1[@"firstName"], match1[@"age"]] WithFont:HELVETICALTSTD_ROMAN FSize:13 Color: WHITE_COLOR] ;
                //////////////
            [Helper setToLabel:lblMutualFriend2 Text:@"0" WithFont:HELVETICALTSTD_LIGHT FSize:19 Color: WHITE_COLOR] ;
            ////////////////////
            //[Helper setToLabel:lblMutualLikes2 Text:[NSString stringWithFormat:@"%@", match1[@"sharedLikes"]] WithFont:HELVETICALTSTD_LIGHT FSize:19 Color: WHITE_COLOR] ;
            [Helper setToLabel:lblNoOfImage Text:[NSString stringWithFormat:@"0%@", match1[@"imgCnt"]] WithFont:HELVETICALTSTD_LIGHT FSize:19 Color: WHITE_COLOR] ;
            
            //[self.view sendSubviewToBack:visibleView2];
        }
        else {
            visibleView2.hidden = YES;
        }
        
        count = 0;
        
    }
    
}

-(void) matchProfile:(NSDictionary*)data
{
    
}

-(void)updatePreference:(NSDictionary*)_response
{
    
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    NSLog(@"response %@",_response);
    if (_response == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Connection Timeout." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
        alert.tag = 400;
        [alert show];
    }
    else
    {
        if (_response != nil) {
            
            NSDictionary *dict = [_response objectForKey:@"ItemsList"];
            NSLog(@"%@",dict);
            
            if (dict[@"errFlag"] == 0) {
                [self performSelector:@selector(sendRequestForGetMatches) withObject:nil afterDelay:0];
            }
            
        }
        
        
    }
    
    //[pi hideProgressIndicator];
    
    
}

#pragma mar- actionForNopeAndLike

-(IBAction)pan:(UIPanGestureRecognizer*)gs
{
    
    CGPoint curLoc = visibleView1.center;//[gs locationInView:self.view];
    //    CGPoint touchLoc = CGPointZero;
    //    if ([gs numberOfTouches] > 0) {
    //        touchLoc = [gs locationOfTouch:0 inView:visibleView1.superview];
    //    }
    
    
    CGPoint translation = [gs translationInView:gs.view.superview];
    
    //NSLog(@"trans : %@", [NSValue valueWithCGPoint:translation]);
    float diff = 0;
    
    if (gs.state == UIGestureRecognizerStateBegan) {
    } else if (gs.state == UIGestureRecognizerStateChanged) {
        if (curLoc.x < original.x) {
            diff = original.x - curLoc.x;
            if (diff > 50)
                [nope setAlpha:1];
            else {
                [nope setAlpha:diff/50];
            }
            [liked setHidden:YES];
            [nope setHidden:NO];
            
        }
        else if (curLoc.x > original.x) {
            diff = curLoc.x - original.x;
            if (diff > 50)
                [liked setAlpha:1];
            else {
                [liked setAlpha:diff/50];
            }
            
            [liked setHidden:NO];
            [nope setHidden:YES];
        }
        
        gs.view.center = CGPointMake(gs.view.center.x + translation.x,
                                     gs.view.center.y + translation.y);
        [gs setTranslation:CGPointMake(0, 0) inView:self.view];
        
        
    }
    else if (gs.state == UIGestureRecognizerStateEnded) {
        
        if (![nope isHidden] || ![liked isHidden]) {
            
            [nope setHidden:YES];
            [liked setHidden:YES];
            [visibleView1 setHidden:YES];
            visibleView1.center = original;
            visibleView1.frame = visibleView2.frame;
            [visibleView1 setHidden:NO];
            diff = curLoc.x - original.x;
            
            if (abs(diff) > 50) {
                mainImageView.image = nil;
                mainImageView.image = imgvw.image;
                
                UIButton *btn = nil;
                if (diff > 0) {
                    btn = self.nopeBtn;
                }
                else {
                    btn = self.likedBtn;
                }
                
                self.decision.text = @"";
                
                [self performSelector:@selector(likeDislikeButtonAction:) withObject:btn];
            }
            
            
        }
    }
    
}

-(void)updateNextProfileView
{
    self.decision.hidden = YES;
    [myProfileMatches removeObjectAtIndex:0];

    if(myProfileMatches.count>0)
    {
    NSMutableDictionary *dictForMutal=[myProfileMatches objectAtIndex:0];
    [TinderFBFQL executeFQlForMutualFriendForId:nil andFriendId:[dictForMutal valueForKey:@"fbId"] andDelegate:self];
    [TinderFBFQL executeFQlForMutualLikesForId:nil andFriendId:[dictForMutal valueForKey:@"fbId"] andDelegate:self];
    }
    if ([myProfileMatches count] > 0) {
        NSDictionary *match = [myProfileMatches objectAtIndex:0];
        
        NSString *savePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:match[@"fbId"]] stringByAppendingPathExtension:@"jpg"];
        
        mainImageView.image = [UIImage imageWithContentsOfFile:savePath];
        
        [nameLabel setText:[NSString stringWithFormat:@"%@, %@", match[@"firstName"], match[@"age"]]];
        
        [waveLayer setHidden:YES];
        [profileImageView setHidden:YES];
        
        [matchesView setHidden:NO];
        
        
        original = visibleView1.center;
        
        if ([myProfileMatches count] > 1) {
            visibleView2.hidden = NO;
            
            NSDictionary *match1 = [myProfileMatches objectAtIndex:1];
            NSString *savePath1 = [[NSTemporaryDirectory() stringByAppendingPathComponent:match1[@"fbId"]] stringByAppendingPathExtension:@"jpg"];
            
            [nameLabel2 setText:[NSString stringWithFormat:@"%@, %@", match1[@"firstName"], match1[@"age"]]];
            
            
            imgvw.image = [UIImage imageWithContentsOfFile:savePath1];
            
            //[self.view sendSubviewToBack:visibleView2];
        }
        else {
            visibleView2.hidden = YES;
        }
        
    }
    else {
        [matchesView setHidden:YES];
        [btnInvite setHidden:NO];
        
        [waveLayer setHidden:NO];
        [profileImageView setHidden:NO];
        
        [self performSelector:@selector(startAnimation) withObject:nil];
        
    }
    
}

-(IBAction)likeDislikeButtonAction:(UIButton*)sender
{
    NSDictionary *profile = [myProfileMatches objectAtIndex:0];
    
    if (sender.tag == 300) { // Like
        [self performSelector:@selector(sendInviteAction:) withObject:@{@"fbid": profile[@"fbId"], @"action": [NSNumber numberWithInt:1]}];
    }
    else if (sender.tag == 200) { // Dislike
        [self performSelector:@selector(sendInviteAction:) withObject:@{@"fbid": profile[@"fbId"], @"action": [NSNumber numberWithInt:2]}];
    }
    
    if (self.decision.text.length > 0) {
        self.decision.hidden = NO;
        [self.view bringSubviewToFront:self.decision];
        if (sender.tag == 300) {
            self.decision.text = @"Liked";
            self.decision.textColor = [UIColor colorWithRed:0.001 green:0.548 blue:0.002 alpha:1.000];
            
        }
        else {
            self.decision.text = @"Noped";
            self.decision.textColor = [UIColor redColor];
        }
        [self performSelector:@selector(updateNextProfileView) withObject:nil afterDelay:3];
        
    }
    else {
        self.decision.text = @"Liked";
        
        [self performSelector:@selector(updateNextProfileView) withObject:nil afterDelay:0];
    }
}
-(void)loadImageForSharedFrnd :(NSArray*)arrayFrnd
{
    NSLog(@"frnd%@",arrayFrnd);
    commonFriends.text=[NSString stringWithFormat:@"%d",arrayFrnd.count];
    /*
    self.friendsList = [[NSArray alloc] initWithArray:arrayFrnd];
    
    [Helper setToLabel:lblNoOfFrnd Text:[NSString stringWithFormat:@"(%d)",self.friendsList.count] WithFont:HELVETICALTSTD_LIGHT FSize:15 Color:[Helper getColorFromHexString:@"#7c7c7c" :1.0]];
    [friendsTableView reloadData];
    [TinderFBFQL executeFQlForMutualLikesForId:nil andFriendId:userProfile[@"fbId"] andDelegate:self];
     */
    
}
-(void)loadImageForSharedIntrest:(NSArray*)arrayIntrst
{
    NSLog(@"intrest%@",arrayIntrst);
    commonInterest.text=[NSString stringWithFormat:@"%d",arrayIntrst.count];
    /*
    [Helper setToLabel:lblNoOfIntrest Text:[NSString stringWithFormat:@"(%d)",arrayIntrst.count] WithFont:HELVETICALTSTD_LIGHT FSize:15 Color:[Helper getColorFromHexString:@"#7c7c7c" :1.0]];
    self.myInterestList = [[NSArray alloc] initWithArray:arrayIntrst];
    [interestsTableView reloadData];
     */
    
}
-(IBAction)showUserProfile:(id)sender
{
    TinderPreviewUserProfileViewController *pc;
    if (IS_IPHONE_5) {
        pc = [[TinderPreviewUserProfileViewController alloc] initWithNibName:@"TinderPreviewUserProfileViewController" bundle:nil];
    }
    else{
        pc = [[TinderPreviewUserProfileViewController alloc] initWithNibName:@"TinderPreviewUserProfileViewController_ip4" bundle:nil];
        
    }
    
    
    pc.userProfile = [myProfileMatches objectAtIndex:0];
    pc.viewLoadFrom = HOME_CONTROLER;
    [self.navigationController pushViewController:pc animated:NO];
    
    //UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:pc];
    
    //    PP_RELEASE(navC);
    //    PP_RELEASE(pc);
    //[self presentViewController:pc animated:YES completion:^{
    // }];
}

-(void)donePreviewing:(NSNumber*)val
{
    NSLog(@"done previewing");
    
    if ([val integerValue] == 0) {
        return;
    }
    
    NSDictionary *profile = [myProfileMatches objectAtIndex:0];
    
    [self performSelector:@selector(sendInviteAction:) withObject:@{@"fbid": profile[@"fbId"], @"action": val}];
    
    [self performSelector:@selector(updateNextProfileView) withObject:nil afterDelay:0];
    
}

-(void)sendInviteAction:(NSDictionary*)params
{
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString * strUUID = nil;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        strUUID = [oNSUUID UUIDString];
    } else
    {
        strUUID = [oNSUUID UUIDString];
        
    }
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN"] forKey:RPSessionToken];
    [paramDict setObject:strUUID  forKey:RPDeviceId];
    [paramDict setObject:params[@"fbid"]  forKey:RPInviteActionFBId];
    [paramDict setObject:flStrForObj(params[@"action"])  forKey:RPInviteActionUserAction];
    
    NSLog(@"invite dict : %@", paramDict);
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    handler.requestType = eParseKey;
    NSMutableURLRequest * request = [Service parseInviteAction:paramDict];
    [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(inviteActionResponse:)];
}

-(void)inviteActionResponse:(NSDictionary*)response
{
    //viewItsMatched.hidden = NO;
    
    NSDictionary * dict = [response objectForKey:@"ItemsList"];
    
    if ([[dict objectForKey:@"errFlag"]integerValue] ==0 &&[[dict objectForKey:@"errNum"]integerValue] ==55) {
        viewItsMatched.hidden = NO;
        [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"ITSMATCH"] ;
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.view bringSubviewToFront:viewItsMatched];
        
        NSLog(@"itsmatch%@",dict);
        
        [Helper setToLabel:lblItsMatchedSubText Text:[NSString stringWithFormat:@"You and %@ have liked each other.",dict[@"uName"]] WithFont:HELVETICALTSTD_LIGHT FSize:14 Color:[UIColor whiteColor]];
        
        lblItsMatchedSubText.textAlignment= NSTextAlignmentCenter;
        
        RoundedImageView *userImg  = [[RoundedImageView alloc] initWithFrame:CGRectMake(45, 125, 110, 110)];
        
        RoundedImageView *FriendImg  = [[RoundedImageView alloc] initWithFrame:CGRectMake(155+20, 125, 110, 110)];
        
        
        NSDictionary * dictP =[[NSUserDefaults standardUserDefaults] objectForKey:@"FBUSERDETAIL"];
        NSArray * profileImage= [self getProfileImages:[dictP objectForKey:FACEBOOK_ID]];
        
        userImg.image =[UIImage imageWithContentsOfFile:[(UploadImages*)[profileImage objectAtIndex:0] imageUrlLocal]];
        
        UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(50/2-20/2, 46/2-20/2, 20, 20)];
        [FriendImg addSubview:activityIndicator];
        
        activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
        [activityIndicator startAnimating];
        
        
        // NSURL *urlImagePath=[NSURL fileURLWithPath:dict[@"pPic"]];
        FriendImg.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[Helper removeWhiteSpaceFromURL:dict[@"pPic"]]]]];
        [activityIndicator stopAnimating];
        
        
        
        
        //        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:urlImagePath
        //                                                            options:0
        //                                                           progress:^(NSUInteger receivedSize, long long expectedSize)
        //         {
        //             // progression tracking code
        //         }
        //                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
        //         {
        //             if (image && finished)
        //             {
        //                 [activityIndicator stopAnimating];
        //                 FriendImg.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"pPic"]]]]; // do something with image
        //
        //             }
        //             else
        //             {
        //                 [activityIndicator stopAnimating];
        //                 FriendImg.image=[UIImage imageNamed:@"pfImage.png"];
        //             }
        //         }];
        [viewItsMatched addSubview:userImg];
        [viewItsMatched addSubview:FriendImg];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
    }
    else{
        viewItsMatched.hidden = YES;
        lblNoFriendAround.hidden = NO;
        [Helper setToLabel:lblNoFriendAround Text:@"There's no one new around you." WithFont:SEGOUE_UI FSize:17 Color:[UIColor blackColor]];
        btnInvite.hidden = NO;
        
    }
    
    if (visibleView1.hidden == YES) {
        
        [Helper setToLabel:lblNoFriendAround Text:@"There's no one new around you." WithFont:SEGOUE_UI FSize:17 Color:[UIColor blackColor]];
        btnInvite.hidden = NO;
        lblNoFriendAround .hidden= NO;
        visibleView2.hidden = NO;
        
    }
}

-(void)loadProfileImage:(NSString*)url
{
    NSLog(@"got image");
    //    if (!url) {
    //        return;
    //    }
    
    NSDictionary * dictP =[[NSUserDefaults standardUserDefaults] objectForKey:@"FBUSERDETAIL"];
    NSArray * profileImage= [self getProfileImages:[dictP objectForKey:FACEBOOK_ID]];
    
    
    
    //if database has images
    if (profileImage.count > 0) {
        
        if ([[NSThread currentThread] isMainThread])
        {
            [self performSelector:@selector(startAnimation) withObject:nil];
        }
        else {
            
            [self performSelectorOnMainThread:@selector(startAnimation) withObject:nil waitUntilDone:NO];
            
        }
        
        profileImageView.image =[UIImage imageWithContentsOfFile:[(UploadImages*)[profileImage objectAtIndex:0] imageUrlLocal]];
        profileImageView.backgroundColor = [UIColor clearColor];
        
        [waveLayer setHidden:NO];
        [profileImageView setHidden:NO];
        
        
    }
    else {
        // execute images fql
        profileImageView.image = [UIImage imageNamed:@"pfImage.png"];
        NSLog(@"Database : Images not found run fql for images");
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi showPIOnView:self.view withMessage:@"Updating profile.."];
        [self performSelectorOnMainThread:@selector(runFql) withObject:nil waitUntilDone:NO];
        
    }
    
    
}
-(void)runFql
{
    [TinderFBFQL executeFQlForProfileImage:self];
}

-(void)doneDownloadingProfileImages
{
    NSLog(@"done");
    
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    if ([[NSThread currentThread] isMainThread])
    {
        
        [self performSelector:@selector(startAnimation) withObject:nil];
    }
    else {
        
        [self performSelectorOnMainThread:@selector(startAnimation) withObject:nil waitUntilDone:NO];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsUploaded"];
    [self performSelectorOnMainThread:@selector(sendRequestForGetMatches) withObject:nil waitUntilDone:YES];
    
}

-(void)doneLoadingProfileImage:(NSString*)profImg
{
    
    
    if ([[NSThread currentThread] isMainThread]) {
        
        [self performSelector:@selector(startAnimation) withObject:nil];
        
        profileImageView.image = nil;
        profileImageView.image = [UIImage imageWithContentsOfFile:profImg];
        [profileImageView setHidden:NO];
        [waveLayer setHidden:NO];
        
        [profileImageView setNeedsDisplay];
        
        
        NSUserDefaults * ud =[NSUserDefaults standardUserDefaults];
        [ud setObject:profImg forKey:@"FBPROFILEURL"];
        [ud synchronize];
        
    }
    else {
        [self performSelectorOnMainThread:_cmd withObject:profImg waitUntilDone:NO];
    }
    
    
}

-(void)waveAnimation:(CALayer*)aLayer
{
    //NSLog(@"layer : %@", aLayer);
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.duration = 3;
    transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transformAnimation.removedOnCompletion = YES;
    transformAnimation.fillMode = kCAFillModeRemoved;
    [aLayer setTransform:CATransform3DMakeScale( 10, 10, 1.0)];
    [transformAnimation setDelegate:self];
    
    CATransform3D xform = CATransform3DIdentity;
    xform = CATransform3DScale(xform, 40, 40, 1.0);
    //xform = CATransform3DTranslate(xform, 60, -60, 0);
    transformAnimation.toValue = [NSValue valueWithCATransform3D:xform];
    [aLayer addAnimation:transformAnimation forKey:@"transformAnimation"];
    
    
    UIColor *fromColor = [UIColor colorWithRed:255 green:120 blue:0 alpha:1];
    UIColor *toColor = [UIColor colorWithRed:255 green:120 blue:0 alpha:0.1];
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    colorAnimation.duration = 3;
    colorAnimation.fromValue = (id)fromColor.CGColor;
    colorAnimation.toValue = (id)toColor.CGColor;
    
    [aLayer addAnimation:colorAnimation forKey:@"colorAnimationBG"];
    
    
    UIColor *fromColor1 = [UIColor colorWithRed:0 green:255 blue:0 alpha:1];
    UIColor *toColor1 = [UIColor colorWithRed:0 green:255 blue:0 alpha:0.1];
    CABasicAnimation *colorAnimation1 = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    colorAnimation1.duration = 3;
    colorAnimation1.fromValue = (id)fromColor1.CGColor;
    colorAnimation1.toValue = (id)toColor1.CGColor;
    
    [aLayer addAnimation:colorAnimation1 forKey:@"colorAnimation"];
}


- (void)animationDidStart:(CAAnimation *)anim
{
    //NSLog(@"start anime %@", anim);
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //NSLog(@"stop anime %@ %d", anim, [anim isRemovedOnCompletion]);
    
    inAnimation = NO;
    
    [self performSelectorInBackground:@selector(startAnimation) withObject:nil];
    
}


-(void)startAnimation
{
    if ([waveLayer isHidden] || ![self.view window] || inAnimation == YES)
    {
        return;
    }
    
    inAnimation = YES;
    
    [self waveAnimation:waveLayer];
    
}

-(void)getLocation
{
    if (!clManager) {
        clManager = [[CLLocationManager alloc] init];
        clManager.delegate = self;
    }
    
    [clManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    [clManager startUpdatingLocation];
    
    
}

#pragma mark -
#pragma mark - LocationServiceDelegate
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"LocationDisabled"];
    [ud synchronize];
    CLLocation *location = [locations lastObject];
    NSLog(@"lat %f",location.coordinate.latitude);
    NSLog(@"log %f",location.coordinate.longitude);
    NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    NSString* log = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    [clManager stopUpdatingLocation];
    
    
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString * strUUID = nil;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        
        strUUID = [oNSUUID UUIDString];
        
    } else {
        
        strUUID = [oNSUUID UUIDString];
        
        
    }
    
    NSDictionary *dict = @{RPDeviceId:strUUID, RPSessionToken:flStrForStr([[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN"]), RPUploadLocationUserCurrentLongitute:flStrForStr(log),RPUploadLocationCurrentLattitude:flStrForStr(lat)};
    
    
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    handler.requestType = eParseKey;
    NSMutableURLRequest * request = [Service parseUpdateLocation:dict];;
    [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(updateLocation:)];
    
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"error %@",[error localizedDescription]);
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    //[pi hideProgressIndicator];
    
    
    // [Helper showAlertWithTitle:@"Location Services disabled" Message:@"App requires location services to find your current city weather.Please enable location services in Settings."];
}

-(void)updateLocation:(NSDictionary*)_response
{
    
    NSLog(@"response %@",_response);
    if (_response == nil) {
        
        NSLog(@"location err : %@", _response);
    }
    else
    {
        if (_response != nil) {
            
            NSDictionary *dict = [_response objectForKey:@"ItemsList"];
            NSLog(@"%@",dict);
            
            //rahul chnage 02/1
            
            //[self sendRequestForGetMatches];
        }
        
        
    }
}




- (BOOL) pprevealSideViewController:(PPRevealSideViewController *)controller shouldDeactivateGesture:(UIGestureRecognizer*)gesture forView:(UIView*)view
{
    if ([view isEqual:matchesView] ||
        [view isEqual:mainImageView] ||
        [view.superview isEqual:visibleView2] ||
        [view.superview isEqual:visibleView1] ||
        [view isEqual:visibleView1] ||
        [view isEqual:visibleView2] ||
        [view.superview isEqual:matchesView]) {
        return YES;
    }
    
    return NO;
}


#pragma mark - Mail Methods
-(IBAction)openMail :(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        
        NSMutableDictionary* navBarTitleAttributes = [[UINavigationBar appearance] titleTextAttributes].mutableCopy;
        UIFont *navBarTitleFont = navBarTitleAttributes[UITextAttributeFont];
        navBarTitleAttributes[UITextAttributeFont] = [UIFont systemFontOfSize:navBarTitleFont.pointSize];
        [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleAttributes];
        MFMailComposeViewController *  mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Flamer"];
        
        
        NSArray *toRecipents;
        NSMutableString* message =[[NSMutableString alloc] init];
        
        toRecipents = [NSArray arrayWithObject:@"info@flamer.in"];
        
        
        
        
        [mailer setMessageBody:message isHTML:NO];
        [mailer setToRecipients:toRecipents];
        
        [self presentViewController:mailer animated:YES completion:nil];
        //        [self presentModalViewController:mailer animated:YES];
        //            [self presentViewController:mailer animated:YES completion:^{ navBarTitleAttributes[UITextAttributeFont] = navBarTitleFont;
        //                [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleAttributes];
        //            }];
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0){
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MFMailComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed")  ;
}
-(IBAction)btnActionForItsMatchedView :(id)sender{
    
    UIButton * btn =(UIButton*)sender;
    if (btn.tag ==100) {
        viewItsMatched.hidden = YES;
    }
    else{
        ProgressIndicator * pi = [ProgressIndicator sharedInstance];
        [pi showPIOnView:viewItsMatched withMessage:@"Loading.."];
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSDictionary * dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"ITSMATCH"] ;
        
        
        NSString *imgpath = [NSString stringWithFormat:@"%@/image1.jpg",docDir];
        NSURL *url = [NSURL URLWithString:[Helper removeWhiteSpaceFromURL:dict[@"pPic"]]];
        
        
        //  NSError* error;
        
        
        
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:url
                                                            options:0
                                                           progress:^(NSUInteger receivedSize, long long expectedSize)
         {
             // progression tracking code
         }
                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             
             
             
             if (image && finished)
             {
                 
                 NSData* theData  = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
                 BOOL isWrite =[theData writeToFile:imgpath atomically:YES];
                 if (isWrite ==YES) {
                     NSLog(@"is write Enter");
                     //[pi hideProgressIndicator];
                     [[NSUserDefaults standardUserDefaults] setObject:imgpath forKey:@"PATH"];
                     [self performSelectorOnMainThread:@selector(pushToChatViewController:) withObject:dict waitUntilDone:YES];
                 }
                 else{
                     NSLog(@"error:%@",error);
                 }
                 
                 
             }
         }];
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
}


-(void)pushToChatViewController :(NSDictionary *)dict {
    
    NSMutableDictionary * dictChat = [[NSMutableDictionary alloc]init];
    JSDemoViewController *vc = [[JSDemoViewController alloc] init];
    NSString * strPath =[[NSUserDefaults standardUserDefaults] objectForKey:@"PATH"];
    vc.friendFbId = dict[@"uFbId"];
    vc.status = @"5";
    vc.ChatPersonNane =dict[@"uName"];
    vc.matchedUserProfileImagePath = strPath;
    [dictChat setValue:dict[@"uFbId"] forKey:@"fbId"];
    [dictChat setValue:@"5" forKey:@"status"];
    [dictChat setValue:dict[@"uName"] forKey:@"fName"];
    [dictChat setValue:strPath forKey:@"proficePic"];
    vc.dictUser = dictChat;
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.revealSideViewController popViewControllerWithNewCenterController:n
                                                                   animated:YES];
    [self.revealSideViewController.navigationController pushViewController:vc  animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 400) { //connection timeout error
        
    }
    
}
@end
