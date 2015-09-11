//
//  MenuViewController.m
//  Tinder
//
//  Created by Rahul Sharma on 29/11/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "MenuViewController.h"
#import "RoundedImageView.h"
#import "UploadImages.h"
#import "Constant.h"
#import "Helper.h"
#import "DataBase.h"
#import "ChatViewController.h"
#import "AppConstants.h"

@interface MenuViewController ()
{
     UIActionSheet *actionSheet;
    RoundedImageView *profileImageView;
}
@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad
{
    profileImageView = [[RoundedImageView alloc] initWithFrame:CGRectMake(0, 2, 50, 50)];
    //profileImageView.imageOffset = 2.5;
   
   
    NSDictionary * dictP =[[NSUserDefaults standardUserDefaults] objectForKey:@"FBUSERDETAIL"];
    NSArray * profileImage= [self getProfileImages:[dictP objectForKey:FACEBOOK_ID]];
    if (profileImage.count > 0) {
        profileImageView.image =[UIImage imageWithContentsOfFile:[(UploadImages*)[profileImage objectAtIndex:0] imageUrlLocal]];
    }
    else {
        profileImageView.image = [UIImage imageNamed:@"pfImage.png"];
    }
    
    
    
//     NSString *url = [ud objectForKey:@"FBPROFILEURL"];
//    if ([url hasPrefix:@"https://"]) {
//        profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[Helper removeWhiteSpaceFromURL:url]]]];
//    }
//    else {
//         profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[Helper removeWhiteSpaceFromURL:url]]]];
//    
//    }
    
    
    //Adding rounded image view to main view.
    [btnProfile addSubview:profileImageView];

   [[UIApplication sharedApplication] setStatusBarHidden:YES];
 
    self.view.backgroundColor = [Helper getColorFromHexString:@"#333333" :1.0];
    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
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
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"imageUrlLocal" ascending:YES]];
    
    NSError *error = nil;
    result = [context executeFetchRequest:fetchRequest error:&error];
    return  result;
}


#pragma  mark -Button Action Method
-(IBAction)btnAction:(id)sender{
    UIButton * btn =(UIButton*)sender;
    switch (btn.tag) {
        case PROFILE:
        {
            ProfileViewController *pvc;
            if(IS_IPHONE_5){
                      pvc = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
            }
            else{
                      pvc = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController_ip4" bundle:nil];
            }
            UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:pvc];
            [self.revealSideViewController popViewControllerWithNewCenterController:n
                                                                           animated:YES];
            [self.revealSideViewController setDelegate:pvc];
            PP_RELEASE(pvc);
            PP_RELEASE(n);

            break;
        }
        case HOME:
        {
          
            HomeViewController *c;
            if (IS_IPHONE_5) {
                c= [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            }
            else{
                c = [[HomeViewController alloc] initWithNibName:@"HomeViewController_ip4" bundle:nil];
            }
            c.didUserLoggedIn = YES;
            c._loadViewOnce = NO;
            UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
            [self.revealSideViewController popViewControllerWithNewCenterController:n
                                                                           animated:YES];
            PP_RELEASE(c);
            PP_RELEASE(n);

             //[self.revealSideViewController popViewControllerAnimated:YES];
            break;
        }
        case MESSAGE:
        {
            ChatViewController *menu=[[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
            [self.revealSideViewController pushViewController:menu onDirection:PPRevealSideDirectionRight withOffset:62 animated:YES];
            
            menu.needToCallWebservice = YES;
            PP_RELEASE(menu);
            break;
        }
        case SETTINGS:
        {
            SettingsViewController *c;
            if (IS_IPHONE_5) {
                c = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            }
            else{
                c = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController_ip4" bundle:nil];
            }
           
            UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
            [self.revealSideViewController popViewControllerWithNewCenterController:n
                                                                           animated:YES];
            [self.revealSideViewController setDelegate:c];

            PP_RELEASE(c);
            PP_RELEASE(n);
//            SettingsViewController *settings=[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
//            [self.revealSideViewController pushViewController:settings onDirection:PPRevealSideDirectionRight withOffset:0 animated:YES];
//            PP_RELEASE(settings);
            break;
        }
        case INVITE:
        {
            [self showActionSheet];
            
            break;
        }
            
        default:
            break;
    }
}

-(void)showActionSheet
{
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Invite" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Mail ",@"Message",nil];
    actionSheet.tag = 200;
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}
-(void) actionSheet:(UIActionSheet *)actSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actSheet.tag == 200) {
        if(buttonIndex == 0)
        {
            
            [self openMail];
            
        }
        else if(buttonIndex == 1)
        {
            [self sendMessage];
        }
        else if(buttonIndex == 2)
        {
           // [self shareOnTwitter];
            
        }
        else if(buttonIndex == 3)
        {
            //  [self postOnLinkedIn];
            
        }
        
    }
}

-(void)sendMessage
{
    
    
    MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
    
    messageVC.body = @"Enter a message";
    //messageVC.recipients = @[@"Telnumber"];
    messageVC.messageComposeDelegate = self;
    
    [self.navigationController presentViewController:messageVC animated:YES completion:nil];
    
  
}

#pragma mark - Mail Methods
    - (void)openMail
    {
        if ([MFMailComposeViewController canSendMail])
        {
            
            NSMutableDictionary* navBarTitleAttributes = [[UINavigationBar appearance] titleTextAttributes].mutableCopy;
            UIFont *navBarTitleFont = navBarTitleAttributes[UITextAttributeFont];
            navBarTitleAttributes[UITextAttributeFont] = [UIFont systemFontOfSize:navBarTitleFont.pointSize];
            [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleAttributes];
            MFMailComposeViewController *  mailer = [[MFMailComposeViewController alloc] init];
            
            mailer.mailComposeDelegate = self;
            
            [mailer setSubject:@"hello"];
            
            
            NSArray *toRecipents;
            NSMutableString* message =[[NSMutableString alloc] init];
            
            toRecipents = [NSArray arrayWithObject:@"info@flamer.in"];
            
            
            
            
            [mailer setMessageBody:message isHTML:NO];
            [mailer setToRecipients:toRecipents];
            
            [self presentViewController:mailer animated:YES completion:nil];
            //      [self presentModalViewController:mailer animated:YES];
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


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
   [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
        else if (result == MessageComposeResultSent)
            NSLog(@"Message sent");
            else
                NSLog(@"Message failed")  ;
}


    @end;
