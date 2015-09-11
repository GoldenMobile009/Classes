//
//  TinderPreviewUserProfileViewController.m
//  Tinder
//
//  Created by Vinay Raja on 10/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "TinderPreviewUserProfileViewController.h"
#import "MyTableViewCell.h"
#import "AppConstants.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "RoundedImageView.h"
#import "TinderGenericUtility.h"
#import "Constant.h"
#import "Helper.h"

@interface TinderPreviewUserProfileViewController (){
    UITableView *friendsTableView;
    UITableView *interestsTableView;
    NSArray *imageArr;
    UIView *header_footer_view;
    NSArray * profileImage;
    
    IBOutlet UILabel *descView;
    
}

@property (nonatomic , strong) NSArray *friendsList;
@property (nonatomic , strong) NSArray *myInterestList;

@end

@implementation TinderPreviewUserProfileViewController
@synthesize lblNameAndAge;
@synthesize friendsList;
@synthesize myInterestList;
@synthesize userProfile;
@synthesize lblFriendTxt;
@synthesize lblNoOfFrnd;
@synthesize lblInterstTxt;
@synthesize lblNoOfIntrest;
@synthesize viewLoadFrom;
@synthesize lblAboutTTl;
@synthesize lblDistanceAway;
@synthesize lbllastActive;
@synthesize lblAboutUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)addLeftButton:(UINavigationItem*)naviItem
{
    //UIImage *imgButton = [UIImage imageNamed:@"chat_icon_off_line.png"];
	UIButton *rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[rightbarbutton setFrame:CGRectMake(0, 0, 60, 42)];
    [rightbarbutton setTitle:@"Done" forState:UIControlStateNormal];
    [rightbarbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightbarbutton.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:15];

    [rightbarbutton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    naviItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
}

-(void)addRightButton:(UINavigationItem*)naviItem
{
    UIImage *imgButton = [UIImage imageNamed:@"edit_close_btn.png"];
    UIButton *rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[rightbarbutton setFrame:CGRectMake(0, 0, imgButton.size.width, imgButton.size.height)];
    //[rightbarbutton setTitle:@"Like" forState:UIControlStateNormal];
    [rightbarbutton setImage:imgButton forState:UIControlStateNormal];
    //[rightbarbutton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
   // rightbarbutton.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:15];
    [rightbarbutton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *imgButton1 = [UIImage imageNamed:@"heart_btn.png"];
    UIButton *rightbarbutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
	[rightbarbutton1 setFrame:CGRectMake(0, 0, imgButton1.size.width, imgButton1.size.height)];
    //[rightbarbutton1 setTitle:@"Nope" forState:UIControlStateNormal];
    //[rightbarbutton1 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    //rightbarbutton1.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:15];
    [rightbarbutton1 setImage:imgButton1 forState:UIControlStateNormal];
    
    [rightbarbutton1 addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
  
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
    UIBarButtonItem *rightBtn1 = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton1];
    rightbarbutton.tag = 2;
    rightbarbutton1.tag = 1;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [fixedSpace setWidth:20];
    self.navigationItem.rightBarButtonItems = @[rightBtn1, fixedSpace, rightBtn];
   
}

-(IBAction)done:(id)sender
{
    
    int returnVal = [sender tag];
    
    UIViewController *vc = [[self.navigationController viewControllers] objectAtIndex:[[self.navigationController viewControllers] count] - 2];
    
    if (viewLoadFrom == HOME_CONTROLER) {
        
         [vc performSelector:@selector(donePreviewing:) withObject:@(returnVal) afterDelay:0.1];
         [self.navigationController popViewControllerAnimated:NO];
         self.navigationController.view.hidden = YES;
        self.pageCtrl.hidden = YES;
    }
    else{
        [self.navigationController popViewControllerAnimated:NO];
        self.pageCtrl.hidden = YES;
    }
 
}

- (void)viewDidLoad
{
    
    appDelegate =(TinderAppDelegate*) [[UIApplication sharedApplication]delegate];
   /***** navigation Item*****/
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setTitle:@"Profile"];
    [self addLeftButton:self.navigationItem];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:NO];
    self.pageCtrl = [[UIPageControl alloc]initWithFrame:CGRectMake(60, 20, 320-120, 27)];
    [self.navigationController.view addSubview:self.pageCtrl];

    
     lblNameAndAge . frame = CGRectMake(12, 4, 295, 30);
     lblDistanceAway = [[UILabel alloc]initWithFrame:CGRectMake(12, lblNameAndAge.frame.size.height+lblNameAndAge.frame.origin.y-3, 295,20 )];
     lbllastActive = [[UILabel alloc]initWithFrame:CGRectMake(12, lblDistanceAway.frame.size.height+lblDistanceAway.frame.origin.y-6, 250, 20)];
     lblAboutTTl = [[UILabel alloc]initWithFrame:CGRectMake(12, lbllastActive.frame.size.height+lbllastActive.frame.origin.y+10, 250, 25)];

   
    [self.bottomContainer addSubview:lblDistanceAway];
    [self.bottomContainer addSubview:lbllastActive];
    [self.bottomContainer addSubview:lblAboutTTl];
    
    self.pageCtrl.pageIndicatorTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"image_slider_off.png"]];
    self.pageCtrl.currentPageIndicatorTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"simage_slider_on.png"]];
    lblAboutUser = [[UITextView alloc]initWithFrame:CGRectMake(6, lblAboutTTl.frame.size.height+lblAboutTTl.frame.origin.y+4, 250, 54)];
    [self.bottomContainer addSubview:lblAboutUser];
    
    
    if (viewLoadFrom == HOME_CONTROLER) {
        
        [self addRightButton:self.navigationItem];
        [self getUserProfile];
        
        
        UIActivityIndicatorView *activityIndicator =[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.mainImageView.frame.size.width/2-20/2, self.mainImageView.frame.size.height/2-20/2, 20, 20)];
        [self.mainImageView addSubview:activityIndicator];
        
        activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
        [activityIndicator startAnimating];
        
        
        [self.mainImageView setImageWithURL:[NSURL URLWithString:userProfile[@"pPic"]]
                           placeholderImage:nil
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                      [activityIndicator stopAnimating];
                                  }];
        
        
    }
    else
    {
        [self.mainImageView  setImage:[UIImage imageWithContentsOfFile:[userProfile objectForKey:@"proficePic"]]];
        [self getUserProfile];
        
    }

    
    


    
     [TinderFBFQL executeFQlForMutualFriendForId:nil andFriendId:userProfile[@"fbId"] andDelegate:self];
    
    
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [self.mainImageView addGestureRecognizer:swipeLeft];
    [self.mainImageView addGestureRecognizer:swipeRight];
    
    // NSDictionary * dictProfile;
    
    
    lblAboutUser.backgroundColor = [UIColor clearColor];
    lblAboutUser.textColor = [Helper getColorFromHexString:@"#838383" :1.0];
    lblAboutUser.font = [UIFont fontWithName:HELVETICALTSTD_ROMAN size:13];
    CGRect frame1 = lblAboutUser.frame;
    frame1.size.height = lblAboutUser.contentSize.height;
    lblAboutUser.frame = frame1;
    lblAboutUser.frame = CGRectMake(6, lblAboutTTl.frame.size.height+lblAboutTTl.frame.origin.y-5, 295, lblAboutUser.frame.size.height);
    
    lblFriendTxt.frame = CGRectMake(12, lblAboutUser.frame.size.height+lblAboutUser.frame.origin.y+4, 118, 20);
    lblNoOfFrnd.frame = CGRectMake(lblFriendTxt.frame.origin.x+lblFriendTxt.frame.size.width, lblFriendTxt.frame.origin.y-3, 50, 20);
    
    
    [super viewDidLoad];
    

}

-(void)makeFrameForTable{
    // Do any additional setup after loading the view.
    
    friendsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lblFriendTxt.frame.origin.y+lblFriendTxt.frame.size.height+14,320 , 119) style:UITableViewStylePlain];
    friendsTableView.delegate = self;
    friendsTableView.dataSource = self;
    
    
    const CGFloat k90DegreesCounterClockwiseAngle = (CGFloat) -(90 * M_PI / 180.0);
    
    lblInterstTxt.frame = CGRectMake(12, friendsTableView.frame.origin.y+friendsTableView.frame.size.height+15, 118, 20);
    lblNoOfIntrest.frame = CGRectMake(lblInterstTxt.frame.origin.x+lblInterstTxt.frame.size.width, lblInterstTxt.frame.origin.y-3, 50, 20);
    
    CGRect frame = friendsTableView.frame;
    friendsTableView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, k90DegreesCounterClockwiseAngle);
    friendsTableView.frame = frame;
    friendsTableView.showsVerticalScrollIndicator = NO;
    friendsTableView.backgroundColor = [UIColor clearColor];
    friendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    friendsTableView.backgroundView = nil;
    [self.bottomContainer addSubview:friendsTableView];
    
    interestsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lblInterstTxt.frame.origin.y+lblInterstTxt.frame.size.height+14, 320, 119) style:UITableViewStylePlain];
    interestsTableView.delegate = self;
    interestsTableView.dataSource = self;
    
    
    frame = interestsTableView.frame;
    interestsTableView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, k90DegreesCounterClockwiseAngle);
    interestsTableView.frame = frame;
    interestsTableView.showsVerticalScrollIndicator = NO;
    interestsTableView.backgroundColor = [UIColor clearColor];
    interestsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    interestsTableView.backgroundView = nil;
    [self.bottomContainer addSubview:interestsTableView];
    
    
    if (IS_IPHONE_5) {
        self.mainScrollView.contentSize = CGSizeMake(320, self.mainImageView.frame.size.height + self.bottomContainer.frame.size.height + 84);
    }
    else{
        self.mainScrollView.contentSize = CGSizeMake(320, self.mainImageView.frame.size.height + self.bottomContainer.frame.size.height + 200);
        
    }
    
    
    self.mainScrollView.minimumZoomScale = 1.0f;
    self.mainScrollView.maximumZoomScale = 1.0f;
    self.mainScrollView.delegate = self;
    self.mainScrollView.bounces = YES;
    self.mainScrollView.bouncesZoom = NO;
    self.mainScrollView.alwaysBounceVertical = YES;
    
    header_footer_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 2)];
    header_footer_view.backgroundColor = [UIColor clearColor];
    
    
    [Helper setToLabel:lblNameAndAge Text:nil WithFont:HELVETICALTSTD_ROMAN FSize:22 Color:[Helper getColorFromHexString:@"#7c7c7c" :1.0]];
    [Helper setToLabel:lblFriendTxt Text:@"Shared Friends" WithFont:HELVETICALTSTD_ROMAN FSize:15 Color:[Helper getColorFromHexString:@"#7c7c7c" :1.0]];
    [Helper setToLabel:lblInterstTxt Text:@"Shared Intrests" WithFont:HELVETICALTSTD_ROMAN FSize:15 Color:[Helper getColorFromHexString:@"#7c7c7c" :1.0]];
}
-(void)loadImageForSharedFrnd :(NSArray*)arrayFrnd
{
    NSLog(@"frnd%@",arrayFrnd);
    self.friendsList = [[NSArray alloc] initWithArray:arrayFrnd];
    
    [Helper setToLabel:lblNoOfFrnd Text:[NSString stringWithFormat:@"(%d)",self.friendsList.count] WithFont:HELVETICALTSTD_LIGHT FSize:15 Color:[Helper getColorFromHexString:@"#7c7c7c" :1.0]];
    [friendsTableView reloadData];
    [TinderFBFQL executeFQlForMutualLikesForId:nil andFriendId:userProfile[@"fbId"] andDelegate:self];
    
}
-(void)loadImageForSharedIntrest:(NSArray*)arrayIntrst
{
     NSLog(@"intrest%@",arrayIntrst);
    [Helper setToLabel:lblNoOfIntrest Text:[NSString stringWithFormat:@"(%d)",arrayIntrst.count] WithFont:HELVETICALTSTD_LIGHT FSize:15 Color:[Helper getColorFromHexString:@"#7c7c7c" :1.0]];
    self.myInterestList = [[NSArray alloc] initWithArray:arrayIntrst];
    [interestsTableView reloadData];
 
}

-(void)getUserProfile
{
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
    [paramDict setObject:userProfile[@"fbId"]  forKey:RPUserFBId];
    
    NSLog(@"get user profile dict : %@", paramDict);
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    handler.requestType = eParseKey;
    NSMutableURLRequest * request = [Service parseMethod:MethodGetProfile withParams:paramDict];
    [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(userProfileResponse:)];
}

-(void)userProfileResponse:(NSDictionary*)response
{
    NSDictionary *dict = response[@"ItemsList"];
    
    if ([dict[@"errFlag"] integerValue] == 0) {
        
        NSLog(@"%@",response);
        
       
            if (dict[@"age"])
            {
                NSString *strAge=[dict valueForKey:@"age"];
                int age=[strAge intValue]+1;
                lblNameAndAge.text = [NSString stringWithFormat:@"%@, %d", dict[@"firstName"], age];
            }
            else {
                lblNameAndAge.text = dict[@"firstname"];
            }
            
           NSString* desc = flStrForObj(dict[@"persDesc"]);
            
            if (desc && [desc length] > 0) {
                [lblAboutUser setHidden:NO];
                [lblAboutTTl setHidden:NO];
                [lblAboutUser setText:desc];
                [self makeFrameForTable];
            }
            else {
                [lblAboutUser setHidden:YES];
                [lblAboutTTl setHidden:YES];
                lblFriendTxt.frame = CGRectMake(12, 75, 118, 20);
                lblNoOfFrnd.frame = CGRectMake(lblFriendTxt.frame.origin.x+lblFriendTxt.frame.size.width, lblFriendTxt.frame.origin.y-3, 50, 20);
                
                [self makeFrameForTable];
               //  friendsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lblFriendTxt.frame.origin.y+lblFriendTxt.frame.size.height+14,320 , 119) style:UITableViewStylePlain];
//                lblInterstTxt.frame = CGRectMake(12, friendsTableView.frame.origin.y+friendsTableView.frame.size.height+15, 118, 20);
//                lblNoOfIntrest.frame = CGRectMake(lblInterstTxt.frame.origin.x+lblInterstTxt.frame.size.width, lblInterstTxt.frame.origin.y-3, 50, 20);
//                friendsTableView.backgroundColor = [UIColor redColor];
//                interestsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lblInterstTxt.frame.origin.y+lblInterstTxt.frame.size.height+14, 320, 119) style:UITableViewStylePlain];
//                friendsTableView.backgroundColor = [UIColor redColor];
//                [friendsTableView reloadData];
//                [interestsTableView reloadData];

                
            }
        NSString *  strActiveText = [Helper ConverGMTtoLocal:dict[@"lastActive"]];
        NSLog(@"title Y%f",lblAboutTTl.frame.origin.y);
        
        NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
        CLLocationDistance distance;
        NSString *userLati=[dict valueForKey:@"lati"];
        NSString *userLongi=[dict valueForKey:@"long"];
       // userLati=@"20";
       // userLongi=@"73";
        CLLocation *locB = [[CLLocation alloc] initWithLatitude:[[pref objectForKey:@"curlati"] floatValue] longitude:[[pref objectForKey:@"curlongi"] floatValue]];
        CLLocation *locA = [[CLLocation alloc] initWithLatitude:[userLati floatValue] longitude:[userLongi floatValue]];
        distance=[locA distanceFromLocation:locB];
        int Km=distance/1000;
        
        [Helper setToLabel:lblDistanceAway Text:[NSString stringWithFormat:@"less than %d kelometer away",Km] WithFont:HELVETICALTSTD_ROMAN FSize:13 Color:[Helper getColorFromHexString:@"#5c5c5c" :1.0]];
        [Helper setToLabel:lbllastActive Text:[NSString stringWithFormat:@"active %@ hour ago",strActiveText] WithFont:HELVETICALTSTD_ROMAN FSize:13 Color:[Helper getColorFromHexString:@"#838383" :1.0]];
        [Helper setToLabel:lblAboutTTl Text:[NSString stringWithFormat:@"About %@",dict[@"firstName"]] WithFont:HELVETICALTSTD_ROMAN FSize:18 Color:[Helper getColorFromHexString:@"#7c7c7c" :1.0]];

//        NSArray *tmp = nil;
//        if ([profileImage count] > 0) {
//            tmp = profileImage;
//        }
        
       // NSArray  *images = dict[@"images"];
  
        
        profileImage = dict[@"images"];
        if (profileImage.count > 0) {
            if ([profileImage[0] isKindOfClass:[NSNull class]]) {
              
                return;
            }
        }
        //profileImage = [profileImage arrayByAddingObjectsFromArray:images];
        [self.pageCtrl setNumberOfPages:[profileImage count]];
        [self.pageCtrl setCurrentPage:0];

    }
}


- (void)executeFQlForFriend
{
    
    // Set up the query parameter
    NSString *query =
    @"SELECT uid, name, pic_square FROM user WHERE uid IN "
    @"(SELECT uid2 FROM friend WHERE uid1 = me() LIMIT 25)";
    
    
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
                              
                              if (error) {
                                  NSLog(@"Error: %@", [error localizedDescription]);
                              } else {
                                  
                                  // Get the friend data to display
                                  NSArray *friendInfo = (NSArray *) result[@"data"];
                                  NSLog(@"interst%@",friendInfo);
                                  
                                  self.friendsList = [[NSArray alloc] initWithArray:friendInfo];
                                  [friendsTableView reloadData];
                                  
                                  [self executeFQlForIntrest];
                                  
                                  
                                  
                              }
                          }];
    
    
}

- (void)executeFQlForIntrest
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict =[ud objectForKey:@"FBUSERDETAIL"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT pic_square,name from page where page_id IN (SELECT page_id FROM page_fan WHERE uid ='%@') LIMIT 5",[dict objectForKey:FACEBOOK_ID]];
    
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
                              if (error) {
                                  NSLog(@"Error: %@", [error localizedDescription]);
                              } else {
                                  // NSLog(@"Result: %@ %s", result, __func__);
                                  
                                  
                                  // Get the friend data to display
                                  NSArray *arrIntrest = (NSArray *) result[@"data"];
                                  NSLog(@"interst%@",arrIntrest);
                                  myInterestList = [[NSArray alloc] initWithArray:arrIntrest];
                                  [interestsTableView reloadData];
                                  
                                  
                                  
                              }
                          }];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    if ([tableView isEqual:friendsTableView]) {
        return self.friendsList.count;
    }
    else if([tableView isEqual:interestsTableView]) {
        
        return self.myInterestList.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    // [cell setImage:[UIImage imageNamed:[imageArr objectAtIndex:self.pageCtrl.currentPage+1]]];//[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[Helper removeWhiteSpaceFromURL:[imageArr objectAtIndex:indexPath.section]]]]]];
    
    NSDictionary *dictionary = nil;
    
    if ([tableView isEqual:friendsTableView])
    {
        dictionary = self.friendsList[indexPath.section];
        
        cell.lblName.text = dictionary[@"first_name"];
        NSURL *imageURL = [NSURL URLWithString:dictionary[@"pic_small"]];
        [cell.roundImageView setImageWithURL:imageURL
                            placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                       
                                       
                                   }];


        
    }
    else if([tableView isEqual:interestsTableView]) {
        
        dictionary = self.myInterestList[indexPath.section];
        
         cell.lblName.text = dictionary[@"name"];
        
        NSURL *imageURL = [NSURL URLWithString:dictionary[@"pic_square"]];
        
        [cell.roundImageView setImageWithURL:imageURL
                            placeholderImage:[UIImage imageNamed:@"default_interest.png"]
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                       
                                       
                                   }];


    }
    
   
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section   // custom view for header. will be adjusted to default or specified header height
{
    
    return header_footer_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section   // custom view for footer. will be adjusted to default or specified footer height
{
    
    
    return header_footer_view;
}


-(IBAction)handleSwipe:(UISwipeGestureRecognizer*)recognizer
{
    UIActivityIndicatorView *activityIndicator =[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.mainImageView.frame.size.width/2-20/2, self.mainImageView.frame.size.height/2-20/2, 20, 20)];
    [self.mainImageView addSubview:activityIndicator];
    
    activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [activityIndicator startAnimating];
     [activityIndicator hidesWhenStopped];
    
    NSLog(@"direction : %@", @(recognizer.direction));
    switch (recognizer.direction)
    {
        case UISwipeGestureRecognizerDirectionLeft:
        {
            if (self.pageCtrl.currentPage == [profileImage count] - 1){
                [activityIndicator stopAnimating];
                return;
            }
            else {
                NSString *url = [profileImage objectAtIndex:self.pageCtrl.currentPage+1];
                CATransition *animation = [CATransition animation];
                animation.duration = 0.5;
                animation.type = kCATransitionMoveIn;
                animation.subtype = kCATransitionFromRight;
                [self.mainImageView.layer addAnimation:animation forKey:@"imageTransition"];
                //self.mainImageView.image =[UIImage imageNamed:[imageArr objectAtIndex:self.pageCtrl.currentPage+1]];
                 //  self.mainImageView.image =[UIImage imageWithContentsOfFile:[profileImage objectAtIndex:self.pageCtrl.currentPage+1]];
                [self.mainImageView setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:nil
            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                [activityIndicator stopAnimating];
        
            }];
                self.pageCtrl.currentPage += 1;
                
            }
            
            break;
        }
        case UISwipeGestureRecognizerDirectionRight:
        {
            if (self.pageCtrl.currentPage == 0){
                [activityIndicator stopAnimating];
                return;
            }
         
            else {
                NSString *url = [profileImage objectAtIndex:self.pageCtrl.currentPage-1];
                CATransition *animation = [CATransition animation];
                animation.duration = 0.5;
                animation.type = kCATransitionMoveIn;
                animation.subtype = kCATransitionFromLeft;
                [self.mainImageView.layer addAnimation:animation forKey:@"imageTransition"];
//                 self.mainImageView.image =[UIImage imageWithContentsOfFile:[profileImage objectAtIndex:self.pageCtrl.currentPage-1]];
                // self.mainImageView.image = [UIImage imageNamed:[imageArr objectAtIndex:self.pageCtrl.currentPage-1]];
                [self.mainImageView setImageWithURL:[NSURL URLWithString:url]
                                   placeholderImage:nil
                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                          [activityIndicator stopAnimating];
                                     
                                          }];
                self.pageCtrl.currentPage -= 1;
                
                
            }
            
            break;
        }
        case UISwipeGestureRecognizerDirectionUp:
        case UISwipeGestureRecognizerDirectionDown:
            break;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView                                              // any offset changes
{
    if (scrollView != self.mainScrollView) {
        return;
    }
    
    if (scrollView.contentOffset.y < 0) {
        CGRect fr = [self.mainImageView frame];
        fr.origin.y = scrollView.contentOffset.y;
        fr.size.height = 320 + (-1 * scrollView.contentOffset.y);
        fr.origin.x = scrollView.contentOffset.y/2;
        fr.size.width = 320 + ((-1 * scrollView.contentOffset.y));
        self.mainImageView.frame = fr;
        
        
    }
    if (scrollView.contentOffset.y == 0) {
        self.mainImageView.frame = CGRectMake(0, 0, 320, 320);
    }
    
    
   // NSLog(@"frame : %@", [NSValue valueWithCGRect:self.mainImageView.frame]);

    
}

- (BOOL) pprevealSideViewController:(PPRevealSideViewController *)controller shouldDeactivateGesture:(UIGestureRecognizer*)gesture forView:(UIView*)view
{
    //    if ([view isEqual:self.mainImageView] || [view isEqual:friendsTableView] || [view isEqual:interestsTableView] || [view isKindOfClass:[RoundedImageView class]] || [[view superview] isEqual:friendsTableView] || [[view superview] isEqual:interestsTableView]) {
    //        return YES;
    //    }
    
    if ([view isEqual:self.mainImageView] || [view isKindOfClass:[UITableViewCell class]] || [view isKindOfClass:[RoundedImageView class]] || [NSStringFromClass([view class]) hasPrefix:@"UITableView"]) {
        return YES;
    }
    
    return NO;
}

@end
