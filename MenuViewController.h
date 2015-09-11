//
//  MenuViewController.h
//  Tinder
//
//  Created by Rahul Sharma on 29/11/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "PPRevealSideViewController.h"
#import "ProfileViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>


@interface MenuViewController : UIViewController<PPRevealSideViewControllerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    IBOutlet UIButton *btnProfile;
}
-(IBAction)btnAction:(id)sender;
@end
