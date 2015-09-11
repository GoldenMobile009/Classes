//
//  ProfileViewController.h
//  Tinder
//
//  Created by Rahul Sharma on 03/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TinderAppDelegate.h"


@interface ProfileViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate,FBLoginViewDelegate,PPRevealSideViewControllerDelegate>
{
    TinderAppDelegate * appDelegate;

    
}
@property (nonatomic, strong) IBOutlet UIPageControl *pageCtrl;
@property (nonatomic, strong) IBOutlet UIImageView *mainImageView;
@property (nonatomic, strong) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, strong) IBOutlet UIView *bottomContainer;
@property (nonatomic, strong) IBOutlet UILabel *lblNameAndAge;
@property (nonatomic, strong) IBOutlet UILabel *lblAboutUser;
@property (nonatomic, strong) IBOutlet UILabel *lblAboutUserTtl;
@property (nonatomic, strong) IBOutlet UILabel *lblFriend;
@property (nonatomic, strong) IBOutlet UILabel *lblIntrest;
;

@property (nonatomic, assign) BOOL isMessageController;


@end
