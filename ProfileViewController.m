//
//  ProfileViewController.m
//  Tinder
//
//  Created by Rahul Sharma on 03/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "ProfileViewController.h"
#import "MyTableViewCell.h"
#import "EditProfileViewController.h"
#import "UploadImages.h"
#import "AppConstants.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "RoundedImageView.h"
#import "Login.h"
#import "JSDemoViewController.h"
#import "TinderGenericUtility.h"

#import "DataBase.h"

@interface ProfileViewController (){
  UITableView *friendsTableView;
  UITableView *interestsTableView;
  NSArray *imageArr;
  UIView *header_footer_view;
  NSArray * profileImage;

}
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (nonatomic , strong) NSArray *friendsList;
@property (nonatomic , strong) NSArray *myInterestList;
@end

@implementation ProfileViewController
@synthesize lblNameAndAge;
@synthesize loginView;
@synthesize friendsList;
@synthesize myInterestList;
@synthesize isMessageController;
@synthesize lblFriend;
@synthesize lblIntrest;
@synthesize lblAboutUser;
@synthesize lblAboutUserTtl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)addrightButton:(UINavigationItem*)naviItem
{
   // UIImage *imgButton = [UIImage imageNamed:@"chat_icon_off_line.png"];
	UIButton *rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[rightbarbutton setFrame:CGRectMake(0, 0,60, 25)];
    [rightbarbutton setTitle:@"Edit" forState:UIControlStateNormal];
    [rightbarbutton addTarget:self action:@selector(editProfile) forControlEvents:UIControlEventTouchUpInside];
    naviItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
}

-(void)addBackToMessage:(UINavigationItem*)naviItem
{
    UIImage *imgButton = [UIImage imageNamed:@"chat_icon_off_line.png"];
	UIButton *rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[rightbarbutton setFrame:CGRectMake(0, 0, imgButton.size.width+20, imgButton.size.height)];
    [rightbarbutton setTitle:@"Done" forState:UIControlStateNormal];
    [rightbarbutton addTarget:self action:@selector(BackToMassageController:) forControlEvents:UIControlEventTouchUpInside];
    naviItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
}
-(void)BackToMassageController:(UIButton*)sender
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    //[self.parentViewController dismissModalViewControllerAnimated:YES];
}
-(void)editProfile
{
    
    EditProfileViewController *editPC;
    if (IS_IPHONE_5) {
      editPC = [[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil];
    }
    else{
      editPC = [[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController_ip4" bundle:nil];
    }
   
    
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:editPC];

    //[self.mainImageView.layer setAnchorPoint:CGPointMake(5,5)];

    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         self.mainImageView.transform=CGAffineTransformConcat(CGAffineTransformMakeTranslation(-50, -100), CGAffineTransformMakeScale(0.8, 0.6));
                         

                     }
                     completion:^(BOOL finished) {
                         self.mainImageView.transform = CGAffineTransformIdentity;
                         [self presentViewController:navC animated:NO completion:nil];
                         [editPC setUpImages:profileImage];
                     }];

    
}

- (void)viewDidLoad
{
    
    [self.navigationItem setTitle:@"Profile"];
    
   //[self.revealSideViewController setDirectionsToShowBounce: PPRevealSideDirectionNone];
    
    appDelegate =(TinderAppDelegate*) [[UIApplication sharedApplication]delegate];

    self.navigationController.navigationBarHidden = NO;
    
    [Helper setToLabel:lblNameAndAge Text:nil WithFont:HELVETICALTSTD_ROMAN FSize:22 Color:[Helper getColorFromHexString:@"#7c7c7c" :1.0]];
    [Helper setToLabel:lblFriend Text:@"Friends" WithFont:HELVETICALTSTD_ROMAN FSize:15 Color:[Helper getColorFromHexString:@"#7c7c7c" :1.0]];
    [Helper setToLabel:lblIntrest Text:@"Intrests" WithFont:HELVETICALTSTD_ROMAN FSize:15 Color:[Helper getColorFromHexString:@"#7c7c7c" :1.0]];
    [Helper setToLabel:lblAboutUserTtl Text:nil WithFont:HELVETICALTSTD_ROMAN FSize:15 Color:[Helper getColorFromHexString:@"#5c5c5c" :1.0]];
    [Helper setToLabel:lblAboutUser Text:nil WithFont:HELVETICALTSTD_ROMAN FSize:9 Color:[Helper getColorFromHexString:@"#838383" :1.0]];
    
    
    if (isMessageController) {
        isMessageController= NO;
       // [self addrightButton:self.navigationItem];
        [self addBackToMessage:self.navigationItem];
    }
    else{
        [self addrightButton:self.navigationItem];
        [appDelegate addBackButton:self.navigationItem];
  
    }
    
    self.pageCtrl = [[UIPageControl alloc]initWithFrame:CGRectMake(50, 20, 320-100, 33)];
    [self.navigationController.view addSubview:self.pageCtrl];
    
     self.pageCtrl.pageIndicatorTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"image_slider_off.png"]];
     self.pageCtrl.currentPageIndicatorTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"simage_slider_on.png"]];

 
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:NO];
    
    
    NSUserDefaults * ud =[NSUserDefaults standardUserDefaults];
    NSDictionary * dictP =[ud objectForKey:@"FBUSERDETAIL"];

    profileImage= [self getProfileImages:[dictP objectForKey:FACEBOOK_ID]];
    NSLog(@"profileImagecount%@",profileImage);
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImageView.clipsToBounds = YES;
  
    if ([profileImage count] > 0)
    {
        self.mainImageView.image =[UIImage imageWithContentsOfFile:[(UploadImages*)[profileImage objectAtIndex:0] imageUrlLocal]];

    }
    else{
        self.mainImageView.image = [UIImage imageNamed:@"pfImage.png"];
    }
  
    Login *user = [self getUserProfile:[dictP objectForKey:FACEBOOK_ID]];
    
    
    if (!user)
    {
        int age = 0;
        
        NSString  *BDAy = [Helper getBirthDate:[dictP objectForKey:FACEBOOK_BIRTHDAY]];
        
        if (BDAy.length ==0 || [BDAy isEqualToString:@""] || BDAy == nil) {
            BDAy  =@"0000-00-00";
            age = 23;
        }
        else{
            
            age = [Helper getAge:[dictP objectForKey:FACEBOOK_BIRTHDAY]];
            
        }

       lblNameAndAge.text = [NSString stringWithFormat:@"%@, %d",[dictP objectForKey:FACEBOOK_FIRSTNAME],age ];
    }
    else{

    if (user.age.integerValue != -1)
    {
        lblNameAndAge.text = [NSString stringWithFormat:@"%@, %@", user.firstname, user.age];
    }
    else {
        lblNameAndAge.text = [NSString stringWithFormat:@"%@", user.firstname];
    }
        
    }
    
    NSString *desc =  flStrForObj([dictP objectForKey:@"Description"]);
    
    if ([desc length] > 0) {
        self.lblAboutUserTtl.text =[NSString stringWithFormat:@"About %@",[dictP objectForKey:FACEBOOK_FIRSTNAME]];
        self.lblAboutUser.text = desc;
        self.lblAboutUser.hidden = NO;
         lblFriend.frame = CGRectMake(12, 110, 320-66, 22);
        
        
    }
    else {
        
       lblFriend.frame = CGRectMake(12, 33, 320-66, 22);
        self.lblAboutUser.hidden = YES;
        self.lblAboutUserTtl.hidden = YES;

    }

    
    [self executeFQlForFriend];
    
    
  
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [self.mainImageView addGestureRecognizer:swipeLeft];
    [self.mainImageView addGestureRecognizer:swipeRight];
    
   // NSDictionary * dictProfile;
    
    
    

    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   
    friendsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lblFriend.frame.origin.y+lblFriend.frame.size.height+9, 320, 119) style:UITableViewStylePlain];
    friendsTableView.delegate = self;
    friendsTableView.dataSource = self;

 
    
    const CGFloat k90DegreesCounterClockwiseAngle = (CGFloat) -(90 * M_PI / 180.0);
    
    CGRect frame = friendsTableView.frame;
    friendsTableView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, k90DegreesCounterClockwiseAngle);
    friendsTableView.frame = frame;
    friendsTableView.showsVerticalScrollIndicator = NO;
    friendsTableView.backgroundColor = [UIColor clearColor];
    friendsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    friendsTableView.backgroundView = nil;
    [self.bottomContainer addSubview:friendsTableView];
    
    
    lblIntrest.frame = CGRectMake(12, friendsTableView.frame.origin.y+friendsTableView.frame.size.height+10, 320-24, 22);
    
    interestsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lblIntrest.frame.origin.y+lblIntrest.frame.size.height, 320, 119) style:UITableViewStylePlain];
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
    
    
    
    [self.pageCtrl setNumberOfPages:[profileImage count]];
    [self.pageCtrl setCurrentPage:0];
    [self.view bringSubviewToFront:self.pageCtrl];
    if (IS_IPHONE_5) {
    self.mainScrollView.contentSize = CGSizeMake(320, self.mainImageView.frame.size.height + self.bottomContainer.frame.size.height + 90);

    }
    else{
         self.mainScrollView.contentSize = CGSizeMake(320, self.mainImageView.frame.size.height + self.bottomContainer.frame.size.height + 165);
    }
    
    
    self.mainScrollView.minimumZoomScale = 1.0f;
    self.mainScrollView.maximumZoomScale = 1.0f;
    self.mainScrollView.delegate = self;
    self.mainScrollView.bounces = YES;
    self.mainScrollView.bouncesZoom = NO;
    self.mainScrollView.alwaysBounceVertical = YES;
    
    header_footer_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 2)];
    header_footer_view.backgroundColor = [UIColor clearColor];
    
   
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
   // NSUserDefaults * ud =[NSUserDefaults standardUserDefaults];
   // NSDictionary * dictP =[ud objectForKey:@"FBUSERDETAIL"];
    
    
    
}

-(NSArray*)getProfileImages :(NSString*)FBId
{
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

-(Login*)getUserProfile:(NSString*)FBId
{
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Login" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *result=nil;
    
    NSError *error = nil;
    result = [context executeFetchRequest:fetchRequest error:&error];
    
    
    
    
    return  [result count]>0?[result objectAtIndex:0]:nil;
    
}

- (void)executeFQlForFriend
{
    
    // Set up the query parameter
    NSString *query =
    @"SELECT uid, name, pic_square FROM user WHERE uid IN "
    @"(SELECT uid2 FROM friend WHERE uid1 = me())";
    
    
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
                                // NSLog(@"interst%@",friendInfo);
                                  
                                  self.friendsList = [[NSArray alloc] initWithArray:friendInfo];
                                  lblFriend.text=[NSString stringWithFormat:@"Friends %d",self.friendsList.count];
                                  [friendsTableView reloadData];
                                  
                                  [self executeFQlForIntrest];
                                  
                        
                                 
                              }
                          }];
    

}

- (void)executeFQlForIntrest
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict =[ud objectForKey:@"FBUSERDETAIL"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT pic_square,name from page where page_id IN (SELECT page_id FROM page_fan WHERE uid ='%@')",[dict objectForKey:FACEBOOK_ID]];
    
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
                                 // NSLog(@"interst%@",arrIntrest);
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
    
    if ([tableView isEqual:friendsTableView]) {
        dictionary = self.friendsList[indexPath.section];
       
    }
    else if([tableView isEqual:interestsTableView]) {
       
        dictionary = self.myInterestList[indexPath.section];
    }
    
    cell.lblName.text = dictionary[@"name"];
    
    UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(50/2-20/2, 46/2-20/2, 20, 20)];
    [cell.imageView addSubview:activityIndicator];
    // activityIndicator.backgroundColor=[UIColor greenColor];
    activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [activityIndicator startAnimating];
 if([tableView isEqual:friendsTableView]) {
     NSURL *imageURL = [NSURL URLWithString:dictionary[@"pic_square"]];
     
     
     
     [cell.roundImageView setImageWithURL:imageURL
                         placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    
                                    
                                }];
     
 }
 else if ([tableView isEqual:interestsTableView]){
     NSURL *imageURL = [NSURL URLWithString:dictionary[@"pic_square"]];
     
     
     
     [cell.roundImageView setImageWithURL:imageURL
                         placeholderImage:[UIImage imageNamed:@"default_interest.png"]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    
                                    
                                }];
 }

    
   
//    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:imageURL
//                                                        options:0
//                                                       progress:^(NSUInteger receivedSize, long long expectedSize)
//                                                            {
//                                                                 [activityIndicator startAnimating];
//                                                                // progression tracking code
//                                                            }
//                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
//                                                            {
//                                                                if (image && finished)
//                                                                {
//                                                                    // do something with image
//                                                                    [cell setImage:image];
//                                                                    [activityIndicator stopAnimating];
//                                                                }
//                                                                else{
//                                                                    
//                                                                }
//                                                            }];
    
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
 
    NSLog(@"direction : %@", @(recognizer.direction));
    switch (recognizer.direction)
    {
        case UISwipeGestureRecognizerDirectionLeft:
        {
            if (self.pageCtrl.currentPage == [profileImage count] - 1)
                return;
            else {
               UploadImages * Upload = [profileImage objectAtIndex:self.pageCtrl.currentPage+1];
                CATransition *animation = [CATransition animation];
                animation.duration = 0.5;
                animation.type = kCATransitionMoveIn;
                animation.subtype = kCATransitionFromRight;
                [self.mainImageView.layer addAnimation:animation forKey:@"imageTransition"];
                self.mainImageView.image =[UIImage imageWithContentsOfFile:Upload.imageUrlLocal];
//                 self.mainImageView.image =[UIImage imageWithContentsOfFile:[profileImage objectAtIndex:self.pageCtrl.currentPage+1]];
                 self.pageCtrl.currentPage += 1;
                
               //NSLog(@"image = %@", Upload.imageUrlLocal);
            }
            
            break;
        }
        case UISwipeGestureRecognizerDirectionRight:
        {
            if (self.pageCtrl.currentPage == 0)
                return;
            else {
                  UploadImages * Upload = [profileImage objectAtIndex:self.pageCtrl.currentPage-1];
                CATransition *animation = [CATransition animation];
                animation.duration = 0.5;
                animation.type = kCATransitionMoveIn;
                animation.subtype = kCATransitionFromLeft;
                [self.mainImageView.layer addAnimation:animation forKey:@"imageTransition"];
               // self.mainImageView.image = [UIImage imageNamed:[imageArr objectAtIndex:self.pageCtrl.currentPage-1]];
                   self.mainImageView.image =[UIImage imageWithContentsOfFile:Upload.imageUrlLocal];
//                self.mainImageView.image =[UIImage imageWithContentsOfFile:[profileImage objectAtIndex:self.pageCtrl.currentPage-1]];

                self.pageCtrl.currentPage -= 1;
                
                //NSLog(@"image = %@", Upload.imageUrlLocal);

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
