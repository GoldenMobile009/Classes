//
//  TinderPreviewUserProfileViewController.h
//  Tinder
//
//  Created by Vinay Raja on 10/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TinderAppDelegate.h"
#import "TinderFBFQL.h"
#import "AppConstants.h"

@interface TinderPreviewUserProfileViewController :UIViewController<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate,FBLoginViewDelegate,PPRevealSideViewControllerDelegate,TinderFBFQLDelegate>
{
    TinderAppDelegate * appDelegate;
    
}
@property (nonatomic, strong) IBOutlet UIPageControl *pageCtrl;
@property (nonatomic, strong) IBOutlet UIImageView *mainImageView;
@property (nonatomic, strong) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, strong) IBOutlet UIView *bottomContainer;
@property (nonatomic, strong) IBOutlet UILabel *lblNameAndAge;
@property (nonatomic, strong) IBOutlet UILabel *lblFriendTxt;
@property (nonatomic, strong) IBOutlet UILabel *lblNoOfFrnd;
@property (nonatomic, strong) IBOutlet UILabel *lblInterstTxt;
@property (nonatomic, strong) IBOutlet UILabel *lblNoOfIntrest;
@property (nonatomic, strong) IBOutlet UILabel *lbllastActive;
@property (nonatomic, strong) IBOutlet UILabel *lblDistanceAway;
@property (nonatomic, strong) IBOutlet UILabel *lblAboutTTl;
@property (nonatomic, strong) IBOutlet UITextView *lblAboutUser;
@property (nonatomic, strong) NSDictionary *userProfile;
@property (nonatomic, assign) int viewLoadFrom;

@end
