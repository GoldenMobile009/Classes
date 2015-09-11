//
//  HomeViewController.h
//  Tinder
//
//  Created by Rahul Sharma on 24/11/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPRevealSideViewController.h"
#import "TinderAppDelegate.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import <FacebookSDK/FacebookSDK.h>
#import "TinderFBFQL.h"
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>



@class TinderAppDelegate;

@interface HomeViewController : UIViewController<PPRevealSideViewControllerDelegate,FBLoginViewDelegate, TinderFBFQLDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate>{
    
    TinderAppDelegate * appDelegate;
    IBOutlet  UIImageView *imgProfile;
    NSString * strProfileUrl;
    int flag;
    IBOutlet UIView *viewGetMatched;
    IBOutlet UIButton *btnInvite;
    IBOutlet UIView *viewItsMatched;
    IBOutlet UILabel *lblItsMatched;
    IBOutlet UILabel *lblItsMatchedSubText;
    IBOutlet UILabel *lblNoFriendAround;
 
   

}
@property(strong ,nonatomic) NSDictionary *dictLoginUsrdetail;
@property(strong ,nonatomic) NSMutableArray *arrFBImageUrl;
@property(strong ,nonatomic)  NSString * strProfileUrl;
@property(assign ,nonatomic)  int flag;

@property (strong, nonatomic) IBOutlet FBLoginView *loginView;
-(IBAction)openMail :(id)sender;
-(IBAction)btnActionForItsMatchedView :(id)sender;



//surender
@property(nonatomic,assign) BOOL didUserLoggedIn;
@property(nonatomic,assign) BOOL _loadViewOnce;

@end
