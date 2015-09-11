//
//  EditProfileViewController.m
//  Tinder
//
//  Created by Vinay Raja on 05/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "EditProfileViewController.h"
#import "AppConstants.h"
#import "AlbumViewController.m"
#import "UploadImages.h"
#import "Constant.h"
#import "TinderGenericUtility.h"

@interface EditProfileViewController ()
{
    CGAffineTransform appliedTransform;
    CGAffineTransform identityTransform;
    
    UIImageView *clickedImgView, *exchangedView;
    
    NSMutableArray *imageViews;
    NSMutableArray *originalFrames;
    
    NSInteger myIndex, emptyIndex;
    
    BOOL disabePan;
    
    int selectedImageTag;
    
    UIButton *selectedBtn;
    
    IBOutlet UITextView *descView;
}
@end

@implementation EditProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setUpImages:(NSArray*)images
{
    imageViews = [[NSMutableArray alloc] init];
    originalFrames = [[NSMutableArray alloc] init];
    
    NSUInteger idx = 10;
    for (UploadImages *imgObj in images) {
        [(UIImageView*)[self.view viewWithTag:idx] setImage:[UIImage imageWithContentsOfFile:imgObj.imageUrlLocal]];
        [imageViews addObject:(UIImageView*)[self.view viewWithTag:idx]];
        idx++;
    }

    
    [imageViews sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [@([(UIImageView*)obj1 tag]) compare:@([(UIImageView*)obj2 tag])];
    }];
    
    [imageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *vw = (UIImageView*)obj;
        [originalFrames addObject:[NSValue valueWithCGRect:vw.frame]];
        
    }];
    
    myIndex = -1;
    emptyIndex = -1;
    
    disabePan = YES;
    
    clickedImgView = nil;
    exchangedView = nil;
    
    //[self sendRequestForEditProfile];
    
    [self addSingleTapGestureOnImageViews];
    
    [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *imgv = (UIImageView*)obj;
            
            UIButton *btn = (UIButton *)[self.view viewWithTag:imgv.tag+100];
            [imgv addSubview:btn];
            btn.frame = CGRectMake(imgv.bounds.size.width - 22, imgv.bounds.size.height - 22, 30, 30);
            btn.tag = 100;
            
            if (imgv.image) {
                [btn setTitle:@"X" forState:UIControlStateNormal];
                 [btn setBackgroundImage:[UIImage imageNamed:@"delete_icon.png"] forState:UIControlStateNormal];
            }
            else {
                [btn setTitle:@"+" forState:UIControlStateNormal];
                [selectedBtn setBackgroundImage:[UIImage imageNamed:@"add_image.png"] forState:UIControlStateNormal];
            }
        }
    }];

    
}

-(IBAction)addDeletePics:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
   // if ([btn.titleLabel.text isEqualToString:@"X"]) {
     if ([btn.titleLabel.text isEqualToString:@"X"]) {
        [(UIImageView*)[btn superview] setImage:nil];
        [btn setTitle:@"+" forState:UIControlStateNormal];
        [selectedBtn setBackgroundImage:[UIImage imageNamed:@"add_image.png"] forState:UIControlStateNormal];
        [imageViews removeObject:btn.superview];
        [originalFrames removeObject:[NSValue valueWithCGRect:btn.superview.frame]];
    }
    else
    {
        [btn setTitle:@"X" forState:UIControlStateNormal];
          [btn setBackgroundImage:[UIImage imageNamed:@"delete_icon.png"] forState:UIControlStateNormal];
        

        selectedImageTag = btn.superview.tag;
        selectedBtn = btn;
        [self checkFacebookSession];
    }
}


-(void)addrightButton:(UINavigationItem*)naviItem
{
    //UIImage *imgButton = [UIImage imageNamed:@"chat_icon_off_line.png"];
	UIButton *rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[rightbarbutton setFrame:CGRectMake(0, 0, 75, 23)];
    [rightbarbutton setTitle:@"Done" forState:UIControlStateNormal];
    [rightbarbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbarbutton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
    [[rightbarbutton titleLabel] setFont:[UIFont fontWithName:HELVETICALTSTD_LIGHT size:15.0]];

    [rightbarbutton addTarget:self action:@selector(doneEditing) forControlEvents:UIControlEventTouchUpInside];
    naviItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
    
    
    
}

-(void)doneEditing
{
    
    NSString *desc = [descView text];
    NSUserDefaults * ud =[NSUserDefaults standardUserDefaults];
    NSDictionary * dictP =[ud objectForKey:@"FBUSERDETAIL"];
    
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:dictP];
    
    [d setObject:desc forKey:@"Description"];
    
    [ud setObject:d forKey:@"FBUSERDETAIL"];
    [ud synchronize];
    
    [self performSelector:@selector(sendRequestForEditProfile) withObject:nil afterDelay:1];
    
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         self.view.transform= CGAffineTransformMakeScale(1.3, 1.5);
                         
                         
                     }
                     completion:^(BOOL finished) {
                         self.view.transform = CGAffineTransformIdentity;
                         [self dismissViewControllerAnimated:NO completion:nil];
                     }];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    selectedBtn = nil;

    [self.navigationItem setTitle:@"Edit"];
    [self addrightButton:self.navigationItem];
    
    NSUserDefaults * ud =[NSUserDefaults standardUserDefaults];
    NSDictionary * dictP =[ud objectForKey:@"FBUSERDETAIL"];
    
    NSString *desc =  flStrForObj([dictP objectForKey:@"Description"]);
    
    if ([desc length] > 0) {
        [descView setText:desc];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (selectedBtn) {
        UIImageView *iv = (UIImageView*)selectedBtn.superview;
        if (!iv.image) {
           // [selectedBtn setTitle:@"+" forState:UIControlStateNormal];
            [selectedBtn setBackgroundImage:[UIImage imageNamed:@"add_image.png"] forState:UIControlStateNormal];
            selectedBtn = nil;
        }
    }
    [super viewWillAppear:animated];
}


#pragma mark - Single Tap Gesture 
-(void)addSingleTapGestureOnImageViews {
    
 
    
    for (int i = 10; i <= 15; i++) {
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        singleTapGesture.numberOfTapsRequired = 1;
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:i];
        [imageView addGestureRecognizer:singleTapGesture];
    }
       
    
    
    
}
-(void)handleSingleTapGesture:(UIGestureRecognizer*)gestureRecognizer {
    
    UIImageView *imageView = (UIImageView*)gestureRecognizer.view;
    
    if (imageView.image == nil) {
        NSLog(@"image is not present on imageView");
        selectedImageTag = imageView.tag;
        [self checkFacebookSession];
    }
    else {
        NSLog(@"image is  present on imageView");
    }
}
#pragma mark -EditProfileRequest

-(void)sendRequestForEditProfile{
    
   // NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    //NSDictionary * dict= [ud objectForKey:@"FBUSERDETAIL"];
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    
    
    NSString * strUUID;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        strUUID = [oNSUUID UUIDString];
        
    } else {
        
        strUUID = [oNSUUID UUIDString];
        
    }
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN"] forKey:RPSessionToken];
    [paramDict setObject:strUUID  forKey:RPDeviceId];
    [paramDict setObject:flStrForStr(descView.text) forKey:RPEditUserProfilePersonalDescription];
    
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    handler.requestType = eParseKey;
    NSMutableURLRequest * request = [Service parseEditProfile:paramDict];
    [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(EditprofileResponse:)];
}

-(void)EditprofileResponse:(NSDictionary*)_response
{
    // NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    
    
    if (!_response) {
		NSLog(@"getSetsResponse: No Response");
	}
    NSLog(@"response %@",_response);
    if (_response == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Connection Timeout." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
        alert.tag = 400;
        [alert show];
    }
    else
    {
        if (_response != nil) {
            
          //  NSDictionary *dict = [_response objectForKey:@"ItemsList"];
            
            
            
        }
        
        
    }
    [pi hideProgressIndicator];
    
   // [self performSelectorInBackground:@selector(executeFQlForFriend) withObject:nil];
   // [self performSelectorInBackground:@selector(executeFQlForIntrest) withObject:nil];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)findAndSetMyIndex
{
    myIndex = [imageViews indexOfObject:clickedImgView];
}

-(UIImageView*)imageViewForIndex:(NSInteger)index
{
    return [imageViews objectAtIndex:index];
}

-(CGRect)frameOfImageView:(UIImageView*)imgVw
{
    NSInteger idx = [imageViews indexOfObject:imgVw];
    
    CGRect frame = [[originalFrames objectAtIndex:idx] CGRectValue];
    
    return frame;
}

-(CGRect)frameOfImageViewAtIndex:(NSInteger)idx
{
    CGRect frame = [[originalFrames objectAtIndex:idx] CGRectValue];
    
    return frame;
}

-(UIImageView*)imageViewFoPoint:(UIPanGestureRecognizer*)pgr
{
    NSInteger __block index = -1;
    [imageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj != clickedImgView) {
            UIImageView *vw = (UIImageView*)obj;
            if ( [vw pointInside:[pgr locationInView:vw] withEvent:nil]) {
                *stop = YES;
                index = idx;
            }
        }
    }];
    
    // NSLog(@"index = :%d", index);
    if (index >= 0) {
        UIImageView *vw = [imageViews objectAtIndex:index];
        
        return vw;
    }
    
    return nil;
}

-(NSInteger)indexOfImageView:(UIImageView*)imgVw
{
    return [imageViews indexOfObject:imgVw];
}

-(IBAction)longPress:(UILongPressGestureRecognizer*)longpg
{
    UIImageView *imgvw = (UIImageView*)longpg.view;
    if (imgvw.image == nil || disabePan == NO) {
        return;
    }
    
    clickedImgView = imgvw;
    [self.view bringSubviewToFront:clickedImgView];
    
    identityTransform = clickedImgView.transform;
    [self findAndSetMyIndex];
    
    switch (imgvw.tag) {
        case 10:
        {
            
            CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            transformAnimation.duration = 0.2;
            transformAnimation.delegate = self;
            CATransform3D xform = CATransform3DIdentity;
            xform = CATransform3DScale(xform, 0.5, 0.5, 1.0);
            transformAnimation.toValue = [NSValue valueWithCATransform3D:xform];
            
            [imgvw.layer addAnimation:transformAnimation forKey:@"transformAnimation"];
            
            
            
            
        }
            break;
            
        default:
        {
            CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            transformAnimation.duration = 0.2;
            transformAnimation.delegate = self;
            CATransform3D xform = CATransform3DIdentity;
            xform = CATransform3DScale(xform, 1.1, 1.1, 1.0);
            transformAnimation.toValue = [NSValue valueWithCATransform3D:xform];
            
            [imgvw.layer addAnimation:transformAnimation forKey:@"transformAnimation"];
        }
            break;
    }
    
    disabePan = NO;
    
}

- (void)animationDidStart:(CAAnimation *)anim
{
    //NSLog(@"start");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // NSLog(@"end %d", clickedImgView.tag);
    if (clickedImgView.tag == 10) {
        clickedImgView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }
    else {
        clickedImgView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }
    appliedTransform = clickedImgView.transform;
    
}

-(IBAction)panGest:(UIPanGestureRecognizer*)pangr
{
    
    if (disabePan) {
        return;
    }
    
    
    CGPoint translation = [pangr translationInView:self.view];
    
    clickedImgView.transform = CGAffineTransformConcat(appliedTransform, CGAffineTransformMakeTranslation(translation.x, translation.y));
    
    UIImageView *sView = [self imageViewFoPoint:pangr];
    if (sView) {
        //NSLog(@"replace this %d", sView.tag);
        
        
        {
            CGRect saveFrame = sView.frame;
            [UIView animateWithDuration:1
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 CGRect frame = [self frameOfImageView:clickedImgView];
                                 sView.frame = frame;
                                 
                                 UIButton *btn = (UIButton *)[sView viewWithTag:100];
                                 btn.frame = CGRectMake(sView.bounds.size.width - 22, sView.bounds.size.height - 22, 30, 30);


                             }
                             completion:^(BOOL finished) {
                                 
                             }];
            
            [originalFrames replaceObjectAtIndex:myIndex withObject:[NSValue valueWithCGRect:saveFrame]];
            [originalFrames replaceObjectAtIndex:[self indexOfImageView:sView] withObject:[NSValue valueWithCGRect:sView.frame]];
            exchangedView = sView;
            
        }
        

        int tag = clickedImgView.tag;
        clickedImgView.tag = sView.tag;
        sView.tag = tag;
        

        
        
    }
    
    // NSLog(@"state : %d", pangr.state);
    
    if (pangr.state == UIGestureRecognizerStateEnded || pangr.state == UIGestureRecognizerStateCancelled) {
        
        clickedImgView.transform = CGAffineTransformMakeScale(1, 1);
        clickedImgView.transform = identityTransform;
        clickedImgView.frame = [self frameOfImageView:clickedImgView];
        UIButton *btn = (UIButton *)[clickedImgView viewWithTag:100];
        btn.frame = CGRectMake(clickedImgView.bounds.size.width - 22, clickedImgView.bounds.size.height - 22, 30, 30);

        clickedImgView = nil;
        myIndex = -1;
        emptyIndex = -1;
        disabePan = YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}



#pragma mark - Facebook Methods

- (void)checkFacebookSession{
    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Please wait.."];
    
    // FBSample logic
    // if the session is open, then load the data for our view controller
    if (!FBSession.activeSession.isOpen) {
        
        NSArray *permission = @[@"user_photos",@"friends_photos",@"read_stream"];
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:permission
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          } else if (session.isOpen) {
                                              
                                              [self getFacebookAlbums];
                                              
                                          }
                                      }];
      
    }
    else {
        [self getFacebookAlbums];
    }
    
}


-(void)getFacebookAlbums {
    
    
    
    
    //NSString *owerid = @"100001626260831";
    
    NSDictionary * dictP =[[NSUserDefaults standardUserDefaults] objectForKey:@"FBUSERDETAIL"];

    NSString *owerid = [dictP objectForKey:FACEBOOK_ID];

    
    NSString *query = [NSString stringWithFormat:@"{'query1':'select aid, cover_pid,photo_count, name from album where owner = %@ ORDER BY cover_pid', 'query2' : 'select pid, src_small from photo where pid in (SELECT cover_pid from album where owner =%@) ORDER BY pid',}",owerid,owerid];
    
    
    
    // Set up the query parameter
    NSDictionary *queryParam =
    [NSDictionary dictionaryWithObjectsAndKeys:query, @"q", nil];
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              
                              ProgressIndicator *pi = [ProgressIndicator sharedInstance];
                              [pi hideProgressIndicator];
                              
                              if (error) {
                                  
                                  NSLog(@"erro %@",[error localizedDescription]);
                                  
                              } else {
                                  
                                  NSLog(@"result %@",result);
                                  [self parseAlbums:result];
                                  
                              }
                          }];
    
}

-(void)parseAlbums:(id)response {
    
 
    
    NSArray *albums = response[@"data"][0][@"fql_result_set"] ;
    NSArray *albumsCoverPics = response[@"data"][1][@"fql_result_set"];
    
    AlbumViewController *aVC = [[AlbumViewController alloc] init];
    aVC.albumArray = albums;
    aVC.albumCoverPicsArray = albumsCoverPics;
    aVC.target = self;
    aVC.selector = @selector(croppedFacebookImage:);
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:aVC];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
    

    
}

-(void)croppedFacebookImage:(UIImage*)croppedImage {
    NSLog(@"croppedImage");
    UIImageView *imageView = (UIImageView*)[self.view viewWithTag:selectedImageTag];
    imageView.image = croppedImage;

    if (!selectedBtn) {
        selectedBtn = (UIButton*)[(UIImageView*)[self.view viewWithTag:selectedImageTag] viewWithTag:100];
    }
    
   // [selectedBtn setTitle:@"X" forState:UIControlStateNormal];
    
    [selectedBtn setBackgroundImage:[UIImage imageNamed:@"delete_icon.png"] forState:UIControlStateNormal];
    selectedBtn = nil;
    [imageViews insertObject:imageView atIndex:selectedImageTag-10];
    [originalFrames insertObject:[NSValue valueWithCGRect:imageView.frame] atIndex:selectedImageTag-10];
    
}

- (void) animateTextView:(BOOL) up
{
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationDuration: 0.3f];
    
    CGRect frame = self.view.frame;
    if (up) {
        self.view.frame = CGRectMake(0, frame.origin.y - 216, frame.size.width, frame.size.height);
    }
    else {
        self.view.frame = CGRectMake(0, frame.origin.y + 216, frame.size.width, frame.size.height);
    }
    [UIView commitAnimations];
    
    
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self animateTextView:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //[self animateTextView:NO];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        [self animateTextView:NO];// Return FALSE so that the final '\n' character doesn't get added
        return NO;
        
        
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

@end
