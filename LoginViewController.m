//
//  LoginViewController.m
//  Tinder
//
//  Created by Rahul Sharma on 24/11/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "LoginViewController.h"
#import "TinderAppDelegate.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import <AddressBook/AddressBook.h>
#import "AppConstants.h"
#import "TinderGenericUtility.h"
#import "ChatViewController.h"
#import "TinderFBFQL.h"
#import "Helper.h"
#import "ProgressIndicator.h"
#import "Constant.h"
#import "Service.h"


@interface LoginViewController ()<TinderFBFQLDelegate>
//@property (strong, nonatomic) IBOutlet UIButton *authButton;
@property (strong, nonatomic) IBOutlet UIButton *reauthButton;
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (nonatomic ,strong) NSMutableDictionary *paramDict;
@end

@implementation LoginViewController
@synthesize authButton;
@synthesize loggedInUserID;
@synthesize lblHeading;
@synthesize scrollView;
@synthesize pageControl;
@synthesize paramDict;
@synthesize imgShadow;


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
    
  
    self.navigationController.navigationBarHidden = YES;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"TOKEN"])
    {
        [self authButtonAction:self];
        [super viewDidLoad];
        return;
    }
    
    CGRect screen =[[ UIScreen mainScreen]bounds];
    
  /* Configure Help screens */
    colors = [[NSArray alloc]init];
    if (screen.size.height==568) {
        
           colors = [NSArray arrayWithObjects:[UIImage imageNamed:@"background_screen_three_vt_txt.png"], [UIImage imageNamed:@"background_screen_one_vt_txt.png"],[UIImage imageNamed:@"background_screen_two_vt_screen.png"], nil];
    }
    else{
          colors = [NSArray arrayWithObjects:[UIImage imageNamed:@"profile_signup_screen.png"], [UIImage imageNamed:@"itamactch_signup_screen.png"],[UIImage imageNamed:@"chat_signup_screen.png"], nil];
 
    }
     self.scrollView.delegate = self;
     self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * colors.count, self.scrollView.frame.size.height);

   
    for (int i = 0; i < colors.count; i++) {
      
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
      
        
        frame.size = self.scrollView.frame.size;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
        imgView.image = [colors objectAtIndex:i];
        
        [self.scrollView addSubview:imgView];
        
      
    }
    
    [scrollView setPagingEnabled:YES];
    [self.scrollView setScrollEnabled:YES];

    pageControl.pageIndicatorTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"slider_indicator_off.png"]];
    pageControl.currentPageIndicatorTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"slider_indicator_on.png"]];


    

    
/*Make custom Info and Facebook Buttons*/
    [Helper setButton:btnInfo Text:@"We'll never post anything to facebook." WithFont:SEGOUE_UI FSize:10 TitleColor:[UIColor grayColor] ShadowColor:nil];
    authButton = [UIButton buttonWithType:UIButtonTypeCustom];
    authButton = [[UIButton alloc]initWithFrame:CGRectMake(42, 8, 236, 45)];
    [authButton setBackgroundImage:[UIImage imageNamed:@"fb_btn_txt.png"] forState:UIControlStateNormal];
    [authButton addTarget:self action:@selector(authButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewInfo addSubview:authButton];
    
    [super viewDidLoad];
    
    
   
}
- (IBAction)changePage:(id)sender {
    NSLog(@"pageControl position %d", [self.pageControl currentPage]);
    //Call to remove the current view off to the left
    int page = self.pageControl.currentPage;
    
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    PPRevealSideInteractions interContent = PPRevealSideInteractionNone;
    self.revealSideViewController.panInteractionsWhenClosed = interContent;
    self.revealSideViewController.panInteractionsWhenOpened = interContent;

}

-(void)getLocation
{
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    
    if (![CLLocationManager locationServicesEnabled]) {
        
        [pi hideProgressIndicator];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"LocationDisabled"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [Helper showAlertWithTitle:@"Location Services disabled" Message:@"App requires location services to find your current city weather.Please enable location services in Settings."];
    }

    else{
            clManager = [[CLLocationManager alloc] init];
            clManager.delegate = self;
            [clManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
            [clManager startUpdatingLocation];
        
    }
    
    
}

/*
 * Configure the logged in versus logged out UI
 */

#pragma mark - Action methods

- (IBAction)authButtonAction:(id)sender
{
    TinderAppDelegate *appDelegate = (TinderAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (FBSession.activeSession.isOpen)
    {
      NSLog(@"alreadyopen");
        [appDelegate closeSession];
        [self openSessionWithAllowLoginUI:NO];
        
    } else
    {
        NSLog(@"openwithui");
       [self openSessionWithAllowLoginUI:YES];
    }
    
    
}
#pragma mark-scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.scrollView.frame.size.width;
     // you need to have a **iVar** with getter for scrollView
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}
/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
   // NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Logging In.."];
   

    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                
                [self getFacebookUserDetails];
                
//                // We have a valid session
//                //NSLog(@"User session found");
//                [FBRequestConnection
//                 startForMeWithCompletionHandler:^(FBRequestConnection *connection,
//                                                   NSDictionary<FBGraphUser> *user,
//                                                   NSError *error) {
//                     
//                    
//                     if (!error) {
//                     
//                         self.loggedInUserID = user.id;
//                
//                NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
//                NSString * strURL =@"https://graph.facebook.com/me?fields=bio,id,birthday,email,gender,first_name,age_range,hometown,last_name,name,relationship_status,quotes,about,location,likes,interested_in";
//                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&access_token=%@",strURL,fbAccessToken]]
//                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
//                                              timeoutInterval:10];
//                
//                [request setHTTPMethod: @"GET"];
//                NSURLResponse *response;
//                NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//                NSString *strResponse = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
//                NSDictionary *JSON =
//                [NSJSONSerialization JSONObjectWithData: [strResponse dataUsingEncoding:NSUTF8StringEncoding]
//                                                options: NSJSONReadingMutableContainers
//                                                  error: nil];
//                
//                NSLog(@"facebookdetail%@",JSON);
//                
//                if (JSON == nil) {
//                    
//                    [Helper showAlertWithTitle:@"Message" Message:@"Please try again"];
//                  
//                }
//                else
//                {
//                    [self parseLogin: JSON];
//                    [ud setObject:JSON forKey:@"FBUSERDETAIL"];
//                    
//                }
//                
                
                
//
//                     }
//                 }];
            }
            break;
        case FBSessionStateClosed:
        {
            [pi hideProgressIndicator];
        }
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            [pi hideProgressIndicator];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        
        [pi hideProgressIndicator];
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            @"user_photos",
                            @"user_birthday",
                            @"user_relationship_details",
                            nil];
  
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                    }];
}


-(void)getFacebookUserDetails
{
    
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    NSString * strURL =@"https://graph.facebook.com/me?fields=bio,id,birthday,email,gender,first_name,age_range,hometown,last_name,name,relationship_status,quotes,about,location,likes,interested_in";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&access_token=%@",strURL,fbAccessToken]]
                                      cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                  timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *strResponse = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: [strResponse dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: nil];
    
    NSLog(@"facebookdetail%@",JSON);
    
    if (JSON == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 202;
        [alert show];
        
    }
    else
    {
        [self parseLogin:JSON];
        [ud setObject:JSON forKey:UDFacebookDetail];
        
    }
}

#pragma mark -  login Parse methods

-(void)parseLogin :(NSDictionary*)FBUserDetailDict
{
    int interest=3;
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    [pref setInteger:interest forKey:@"INTREST"];
    [pref setObject:[FBUserDetailDict valueForKey:@"id"] forKey:@"fbidd"];
   [self getLocation];

    NSString * strUUID;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        
        NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
        strUUID = [oNSUUID UUIDString];
        
    } else {
        NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
        strUUID = [oNSUUID UUIDString];
        // strUUID = [[UIDevice currentDevice] uniqueIdentifier];
        // Load resources for iOS 7 or later
        
    }
    
    int sex ;
    if ([[FBUserDetailDict objectForKey:@"gender"] isEqualToString:@"female"]) {
        sex= FEMALE;
    }
    else{
        
        sex=MALE;
    }
    
    NSString  *BDAy = [Helper getBirthDate:[FBUserDetailDict objectForKey:FACEBOOK_BIRTHDAY]];
    NSLog(@"%@",BDAy);
    
    if (BDAy.length ==0 || [BDAy isEqualToString:@""] || BDAy == nil) {
        BDAy  =@"0000-00-00";
    }
    else{
        BDAy = [Helper getBirthDate:[FBUserDetailDict objectForKey:FACEBOOK_BIRTHDAY]];
    }
    NSLog(@"Bday%@",BDAy);
    
    
    NSDictionary * dictLike = [FBUserDetailDict objectForKey:FACEBOOK_LIKES];
    
    NSMutableString* mutString = [[NSMutableString alloc] init];
    NSArray * arrLike = [dictLike objectForKey:@"data"];
    NSLog(@"like count%d",arrLike.count);
    
    for (int k=0; k<arrLike.count; k++) {
        NSDictionary *  dict = [arrLike objectAtIndex:k];
        [mutString appendString:[NSString stringWithFormat:@"%@,",[dict objectForKey:@"id"]]];
    }
    
    
    
    NSDictionary  * dictLocation =[FBUserDetailDict objectForKey:FACEBOOK_LOCATION];
    NSDictionary  * dictAge =[FBUserDetailDict objectForKey:FACEBOOK_AGERANGE];
    NSArray * arrIntrest = [FBUserDetailDict objectForKey:FACEBOOK_INTRESTED_IN];
    int min;
    int max;
    if ([[dictAge objectForKey:AGERANGE_MAX] intValue] ==0) {
        max= 58;
    }
    else{
        max = [[dictAge objectForKey:AGERANGE_MAX]intValue];
    }
    if ([[dictAge objectForKey:AGERANGE_MIN] intValue] ==0) {
        min= 18;
    }
    else{
        min =[[dictAge objectForKey:AGERANGE_MIN] intValue];
        
    }
    NSString * email;
    if ([[FBUserDetailDict objectForKey:FACEBOOK_EMAIL] isEqualToString:@""]||[[FBUserDetailDict objectForKey:FACEBOOK_EMAIL] length]==0 ||[FBUserDetailDict objectForKey:FACEBOOK_EMAIL]==nil) {
        
        email = @"abc@gmail.com";
    }
    else
    {
        email = [FBUserDetailDict objectForKey:FACEBOOK_EMAIL];
    }
    
    
    int Intested_in = 3;
    
    if (arrIntrest && ([arrIntrest count] > 0)) {
        if ([[arrIntrest objectAtIndex:0] isEqualToString:@"female"]) {
            Intested_in = 2;
        }
        else if ([[arrIntrest objectAtIndex:0] isEqualToString:@"male"])
        {
            Intested_in = 1;
        }
    }
    
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"UserProfilePic"]) {
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"UserProfilePic"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
  NSString *strPushToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"DeviceToken"];
    
    if (!([strPushToken length] > 0)) {
        strPushToken = @"6gfghfgjhgjhgkhgkkhkhk";
    }
    
    NSLog(@"%@",strPushToken);
    NSString *strQBId = @"456";
    
    if (!([lat length] > 0) || !([log length] > 0)) {
        lat = @"22.3000";
        log = @"70.7833";
    }
   
    paramDict = [[NSMutableDictionary alloc] init];

    [paramDict setObject:flStrForObj([FBUserDetailDict objectForKey:FACEBOOK_FIRSTNAME])forKey:RPLoginFirstName];
    [paramDict setObject:flStrForObj([FBUserDetailDict objectForKey:FACEBOOK_LASTNAME]) forKey:RPLoginLastName];
    [paramDict setObject:flStrForObj([FBUserDetailDict objectForKey:FACEBOOK_ID])        forKey:RPFBId];
    [paramDict setObject:flStrForObj(email)  forKey:RPLoginEmail];
    [paramDict setObject:flStrForInt(sex) forKey:RPLoginSex];
    [paramDict setObject:flStrForObj([dictLocation objectForKey:LOCATION_NAME])          forKey:RPLoginCity];
    [paramDict setObject:flStrForObj([dictLocation objectForKey:LOCATION_NAME])          forKey:RPLoginCountry];
    [paramDict setObject:flStrForStr(lat)    forKey:RPLoginCurrentLatitude];
    [paramDict setObject:flStrForStr(log)    forKey:RPLoginCurrentLongitude];
    [paramDict setObject:flStrForObj([FBUserDetailDict objectForKey:FACEBOOK_BIO])       forKey:RPLoginTagLine];
    [paramDict setObject:flStrForObj([FBUserDetailDict objectForKey:FACEBOOK_BIO])       forKey:RPLoginPersonalDescription];
    [paramDict setObject:flStrForObj(BDAy )  forKey:RPLoginDOB];
    [paramDict setObject:flStrForInt(Intested_in)                                         forKey:RPLoginPrefSex];
    [paramDict setObject:flStrForInt(min)                                                 forKey:RPLoginPrefLowerAge];
    [paramDict setObject:flStrForInt(max)                            forKey:RPLoginPrefUpperAge];
    [paramDict setObject:flStrForInt(100)                            forKey:RPLoginRadius];
    [paramDict setObject:flStrForStr(mutString)                      forKey:RPLoginLikes];
    [paramDict setObject:flStrForStr(strUUID)      forKey:RPDeviceId];
    [paramDict setObject:flStrForObj(strPushToken) forKey:RPLoginPushToken];
    [paramDict setObject:flStrForStr(strQBId)      forKey:RPLoginQBId];
    [paramDict setObject:flStrForInt(1)  forKey:RPLoginDeviceType];
    [paramDict setObject:flStrForInt(1)  forKey:RPLoginAuthType];
    
    
    //save facebook user detail here
    
  
    NSLog(@"login%@",paramDict);
    
    [[NSUserDefaults standardUserDefaults] setObject:paramDict forKey:UDLoginRequest];
    
    [self sendLoginRequest];
    
    
}

-(void)sendLoginRequest{
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:UDLoginRequest];
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    handler.requestType = eParseKey;
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"LocationDisabled"] intValue] == 1) {
        NSMutableURLRequest * request = [Service parseLogin:dict];
        
        [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(loginResponse:)];
    }
}

-(void)loginResponse:(NSDictionary*)_response
{

    NSLog(@"response %@",_response);
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    
    DataBase * data =[DataBase sharedInstance];
    [self deleteAllObjectFortable:@"Login"];
    
    //surender:  change flow here pass the saved dictionary after parsing
    [data makeDataBaseEntryForLogin:[ud objectForKey:UDLoginRequest]];

    
    if (!_response) {
		NSLog(@"getSetsResponse: No Response");
	}

    if (_response == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Connection Timeout." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
        alert.tag = 400;
        [alert show];
        [pi hideProgressIndicator];

    }
    else
    {
        if (_response != nil) {
            
            NSDictionary *dict = [_response objectForKey:@"ItemsList"];
            
            NSString * strProfile = dict[@"profilePic"];
            [ud setObject:dict[@"expiryLocal"] forKey:@"JOINED"];

            //NSLog(@"srt %@ %d",strProfile , strProfile.length);
            
            if (![strProfile isEqual:[NSNull null]]){//[strProfile rangeOfString:@"http"].location != NSNotFound) {
                
                strProfile =[dict objectForKey:@"profilePic"];
            }
            else {
                strProfile = @"https://fbcdn-profile-a.akamaihd.net/static-ak/rsrc.php/v2/yL/r/HsTZSDw4avx.gif";
            }
            
            // User is not in database so signup user with server
            if ([[dict objectForKey:@"errFlag"]intValue] == 0 && [[dict objectForKey:@"errNum"]intValue] == 3){
                
               // [pi hideProgressIndicator];
                NSLog(@"Signup");
                [ud setBool:NO forKey:@"UserProfilePic"];
                [ud setBool:YES forKey:@"isFirstSignupOrLogin"];
                [ud setObject:[dict objectForKey:@"token"] forKey:@"TOKEN"];
                [ud synchronize];
                HomeViewController *home;
                if (IS_IPHONE_5)
                {
                    home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
                }
                else{
                    home = [[HomeViewController alloc] initWithNibName:@"HomeViewController_ip4" bundle:nil];
                }
                //[pi showPIOnWindow:[[UIApplication sharedApplication]keyWindow] withMessge:@"loading..." ];
                NSMutableArray *navigationarray = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
                [navigationarray removeAllObjects]; //this just for remove all view controller from navigation stack..
                [navigationarray addObject:home];
                
                home.didUserLoggedIn = NO;
                home._loadViewOnce = NO;
                
                home.strProfileUrl = strProfile;
                [ud setObject:dict[@"joined"] forKey:@"JOINED"];
                [self.navigationController setViewControllers:navigationarray animated:YES];
                
            
                
                
            }
            
            else if ([[dict objectForKey:@"errFlag"]intValue] ==0 && [[dict objectForKey:@"errNum"]intValue] == 2){  // Loggin user
                
                [ud setBool:YES forKey:@"isFirstSignupOrLogin"];
                [ud setBool:YES forKey:@"UserProfilePic"];
                [ud setObject:[dict objectForKey:@"token"] forKey:@"TOKEN"];
                [ud setObject:dict[@"expiryLocal"] forKey:@"JOINED"];
                //[ud setObject:dict[@"joined"] forKey:@"JOINED"];
                [ud setObject:strProfile forKey:@"FBPROFILEURL"];
                [ud synchronize];
                [self deleteAllObjectFortable:@"GetProfile"];
                [self sendRequestForViewProfile];
                             
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Login Failed!" delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
                alert.tag = 400;
                [alert show];
                [pi hideProgressIndicator];

            }
            
            
        }
        
        
    }
    
      [self updateLocation];
}


-(void)sendRequestForViewProfile
{
    
    NSDictionary * dictFB = [[NSUserDefaults standardUserDefaults]objectForKey:@"FBUSERDETAIL"];
    
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString * strUUID = nil;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        strUUID = [oNSUUID UUIDString];
    } else {
        strUUID = [oNSUUID UUIDString];
        
    }
    
    paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN"] forKey:RPSessionToken];
    [paramDict setObject:strUUID  forKey:RPDeviceId];
    [paramDict setObject:[dictFB objectForKey:FACEBOOK_ID]  forKey:RPUserFBId];
    NSLog(@"get user profile dict : %@", paramDict);
    [self requestForViewProfile];
    

}
-(void)requestForViewProfile
{
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    handler.requestType = eParseKey;
    NSMutableURLRequest * request = [Service parseMethod:MethodGetProfile withParams:paramDict];
    [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(profileResponse:)];
}



-(void)profileResponse :(NSDictionary*)_response
{
    
    NSLog(@"%@",_response);
    
     ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    if (!_response) {
		NSLog(@"getSetsResponse: No Response");
	}
    NSLog(@"response %@",_response);
    if (_response == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Connection Timeout." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
        alert.tag = 401;
        [alert show];
    }
    else
    {
        
        NSDictionary * dict = [_response objectForKey:@"ItemsList"];
        
        if ([dict[@"errNum"] integerValue] == 39 && [dict[@"errFlag"] integerValue] == 1) {
            
            NSLog(@"unable to find profile");
            
            //surender :loop hole 
        }
        if ([dict[@"errNum"] integerValue] == 49 && [dict[@"errFlag"] integerValue] == 1) {
            
            
            NSLog(@"unable to find profile");
            
            [Helper showAlertWithTitle:@"message" Message:dict[@"errMsg"]];
            [pi hideProgressIndicator];
            
            //surender :loop hole
        }

        
        if ([dict[@"errNum"] integerValue] == 40 && [dict[@"errFlag"] integerValue] == 0) {
            
            DataBase * data = [DataBase sharedInstance];
            data.delegate = self;
            [data makeDataBaseEntryForGetProfile:dict];
        }
        
        
    }
    
    
}

#pragma mark - DataBase Delegate

-(void)dataInsertedSucessfullyInDb:(BOOL)success
{
    
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    if (success) {
        
       
       
        HomeViewController *home ;

        home._loadViewOnce = NO;
        
        NSLog(@"enter in login %d",success);

        if (IS_IPHONE_5) {
            home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            home.didUserLoggedIn = YES;
            home._loadViewOnce = NO;
        }
        else{
            home = [[HomeViewController alloc] initWithNibName:@"HomeViewController_ip4" bundle:nil];
            home.didUserLoggedIn = YES;
            home._loadViewOnce = NO;
        }
        NSMutableArray *navigationarray = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [navigationarray removeAllObjects]; //this just for remove all view controller from navigation stack..
        [navigationarray addObject:home];
        [self.navigationController setViewControllers:navigationarray animated:YES];
        
    }
    else {
//        [pi hideProgressIndicator];
//        [pi showMessage:@"Updating profile" On:self.view];
//        [TinderFBFQL executeFQlForProfileImage:self];
    }
    
   
    
}
//-(void)doneDownloadingProfileImages {
//    
//    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
//    HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
//    NSMutableArray *navigationarray = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
//    [navigationarray removeAllObjects]; //this just for remove all view controller from navigation stack..
//    [navigationarray addObject:home];
//    home.didUserLoggedIn = YES;
//    [self.navigationController setViewControllers:navigationarray animated:YES];
//    [pi hideProgressIndicator];
//}
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
    
    for (NSManagedObject *managedObject in fetchedCategorList) {
    	[[appDelegate managedObjectContext] deleteObject:managedObject];
    	//DLog(@"%@ object deleted",entityDescription);
    }
    if (![[appDelegate managedObjectContext] save:&error]) {
    	//NSLog(@"Error deleting %@ - error:",error);
    }
    
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
    lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    log = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    [ud setObject:lat forKey:@"curlati"];
    [ud setObject:log forKey:@"curlongi"];
    [clManager stopUpdatingLocation];

    
}
-(void)updateLocation{
    
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString * strUUID = nil;

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        
        strUUID = [oNSUUID UUIDString];
        
    } else {
        
        strUUID = [oNSUUID UUIDString];
        
        
    }
    NSLog(@"deviceId:%@",strUUID);
    NSDictionary *dict = @{RPDeviceId:strUUID, RPSessionToken:flStrForStr([[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN"]), RPUploadLocationUserCurrentLongitute:flStrForStr(log),RPUploadLocationCurrentLattitude:flStrForStr(lat)};
    
    
    NSLog(@"updateLoc%@",dict);
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
    [pi hideProgressIndicator];
    
    
   [Helper showAlertWithTitle:@"Location Services disabled" Message:@"App requires location services to find your current city weather.Please enable location services in Settings."];
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
            
            
        }
        
        
    }
}
-(IBAction)btnInfoClicked:(id)sender
{
 

    UIImageView * imgLine;
  // [self.view bringSubviewToFront:viewInfo];
    UIButton * btn = (UIButton*)sender;
    switch (btn.tag) {
        case 10:
        {
        
            
            CGRect rect = viewInfo.frame;
            rect.origin.y = 0;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
            [viewInfo setFrame:rect];
            [UIView commitAnimations];
                      // CGRect rect1 = authButton.frame;
           // rect1.origin.y = 100;
            //[authButton setFrame:rect1];
          
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:0.0];
//            [authButton setFrame:rect1];
//            [UIView commitAnimations];
            authButton.frame= CGRectMake(42, 60, 236, 45);
          

            
            UIImage * image = [UIImage imageNamed:@"privacy_horizantal_line.png"];
            UIImage * imageDot = [UIImage imageNamed:@"bullet_icon.png"];
            
             imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(20, authButton.frame.origin.y+90, image.size.width, image.size.height)];
            imgLine.image =image;
            
            [viewInfo addSubview:imgLine];
            
            UILabel * lblHead = [[UILabel alloc]initWithFrame:CGRectMake(0, imgLine.frame.origin.y+imgLine.frame.size.height+30,320,25)];
            
            [Helper setToLabel:lblHead Text:@"We take your privacy seriously" WithFont:SEGOUE_BOLD FSize:18 Color:[Helper getColorFromHexString:@"#4c4c4c" :1]];
            lblHead.textAlignment =NSTextAlignmentCenter;
            [viewInfo addSubview:lblHead];
            
            UILabel * lblLine1 = [[UILabel alloc]initWithFrame:CGRectMake(55, lblHead.frame.origin.y+lblHead.frame.size.height+15,265,36)];
                     lblLine1.numberOfLines = 3;
            [Helper setToLabel:lblLine1 Text:@"We will naver post anything to Facebook" WithFont:SEGOUE_UI FSize:13 Color:[Helper getColorFromHexString:@"#4c4c4c" :1]];
            [viewInfo addSubview:lblLine1];
            
            UILabel * lblLine2 = [[UILabel alloc]initWithFrame:CGRectMake(55, lblLine1.frame.origin.y+lblLine1.frame.size.height+15,265,36)];
                     lblLine2.numberOfLines = 3;
            [Helper setToLabel:lblLine2 Text:@"Other users will never know if you've liked them unless they like u back" WithFont:SEGOUE_UI FSize:13 Color:[Helper getColorFromHexString:@"#4c4c4c" :1]];
            [viewInfo addSubview:lblLine2];
            
            UILabel * lblLine3 = [[UILabel alloc]initWithFrame:CGRectMake(55, lblLine2.frame.origin.y+lblLine2.frame.size.height+15,265,36)];
                lblLine3.numberOfLines = 3;
            [Helper setToLabel:lblLine3 Text:@"Other user cannot contact you unless you've already been matched" WithFont:SEGOUE_UI FSize:13 Color:[Helper getColorFromHexString:@"#4c4c4c" :1]];
            [viewInfo addSubview:lblLine3];
            
            UILabel * lblLine4 = [[UILabel alloc]initWithFrame:CGRectMake(55, lblLine3.frame.origin.y+lblLine3.frame.size.height+15,265,36)];
            lblLine4.numberOfLines = 3;
        
            [Helper setToLabel:lblLine4 Text:@"Your location will never be shown to other users" WithFont:SEGOUE_UI FSize:13 Color:[Helper getColorFromHexString:@"#4c4c4c" :1]];
            [viewInfo addSubview:lblLine4];
            
            
            UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(26, lblLine1.frame.origin.y+15, imageDot.size.width, imageDot.size.height)];
            img1.image =imageDot;
           [viewInfo addSubview:img1];
            
            UIImageView * img2 = [[UIImageView alloc]initWithFrame:CGRectMake(26, lblLine2.frame.origin.y+10, imageDot.size.width, imageDot.size.height)];
            img2.image =imageDot;
            [viewInfo addSubview:img2];
            UIImageView * img3 = [[UIImageView alloc]initWithFrame:CGRectMake(26, lblLine3.frame.origin.y+10, imageDot.size.width, imageDot.size.height)];
            img3.image =imageDot;
            [viewInfo addSubview:img3];
             UIImageView * img4 = [[UIImageView alloc]initWithFrame:CGRectMake(26, lblLine4.frame.origin.y+10, imageDot.size.width, imageDot.size.height)];
            img4.image =imageDot;
            [viewInfo addSubview:img4];


            btnClose.hidden = NO;
            btnInfo.hidden = YES;
            imgLine.hidden = NO;
            scrollView.hidden = YES;
            pageControl.hidden = YES;
            imgShadow.hidden = YES;
          
            
        break;
        }
        case 11:
        {
            scrollView.hidden = NO;
            pageControl.hidden = NO;
            imgShadow.hidden = NO;
            CGRect screen = [[UIScreen mainScreen]bounds];
            CGRect rect = viewInfo.frame;
            
            if (screen.size.height==568) {
                  rect.origin.y = 468;
            }
            else{
               rect.origin.y = 399;
            }
          
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
            [viewInfo setFrame:rect];
            [UIView commitAnimations];
            
            CGRect rect1 = authButton.frame;
            rect1.origin.y = 8;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.0];
            [authButton setFrame:rect1];
            [UIView commitAnimations];

            btnClose.hidden = YES;
            btnInfo.hidden = NO;
            imgLine.hidden = YES;
           

            
            
            break;
        }
            
        default:
            break;
    }
    
  
  
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 400) { //connection timeout error
        [self sendLoginRequest];
    }
    else if(alertView.tag == 401) { // connection timeout for view profile
        
        [self requestForViewProfile];
    }
    else if (alertView.tag == 202) {
        
        [self getFacebookUserDetails];
    }
}
@end
