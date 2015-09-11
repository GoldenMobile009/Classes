//
//  LoginViewController.h
//  Tinder
//
//  Created by Rahul Sharma on 24/11/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import"DataBase.h"

@class TinderAppDelegate;
@interface LoginViewController : UIViewController<CLLocationManagerDelegate,UIScrollViewDelegate,DataInsertedSuccessfullyDelegate>
{
    IBOutlet UILabel *lblHeading;
    NSString *lat;
    NSString *log;
    CLLocationManager *clManager;
    NSMutableArray * arrImages;
    UIScrollView* scrollView;
    UIPageControl* pageControl;
    NSArray *colors;
    NSArray *profileImg;
    IBOutlet UIButton *btnInfo;
    IBOutlet UIButton *btnClose;
    IBOutlet UIView *viewInfo;

}
@property (strong, nonatomic) IBOutlet UIButton *authButton;
@property (strong, nonatomic)  IBOutlet UILabel *lblHeading;;
@property (strong, nonatomic) NSString *loggedInUserID;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;
@property (nonatomic, retain) IBOutlet UIImageView * imgShadow;
- (IBAction)changePage:(id)sender;
-(IBAction)btnInfoClicked:(id)sender;
-(void)getLocation;



@end
