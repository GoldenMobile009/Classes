//
//  SettingsViewController.m
//  Tinder
//
//  Created by Rahul Sharma on 30/11/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "SettingsViewController.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import "RangeSlider.h"
#import "AppConstants.h"
#import "LoginViewController.h"
#import "Helper.h"
#import "Constant.h"
#import "ProgressIndicator.h"
#import "Service.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize lblDistance;

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
    
    
    self.navigationController.navigationBar.translucent = NO;
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    CGRect screen = [[UIScreen mainScreen]bounds];
    if (IS_IPHONE_5) {
         scrollview.frame = CGRectMake(0, 44, 320, screen.size.height);
    }
   
    
    appDelagte =(TinderAppDelegate*) [[UIApplication sharedApplication]delegate];
    self.navigationController.navigationBarHidden = NO;
    [appDelagte addBackButton:self.navigationItem];
    [self.navigationItem setTitle:@"Settings"];
    [appDelagte addrightButton:self.navigationItem];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:NO];
    
    // ui settings
    
    [Helper setToLabel:lblDistance Text:@"I Am :" WithFont:HELVETICALTSTD_LIGHT FSize:19 Color:BLACK_COLOR];
    [Helper setToLabel:lblShowMe Text:@"Show Me :" WithFont:HELVETICALTSTD_LIGHT FSize:19 Color:BLACK_COLOR];
    [Helper setToLabel:lblLimitSearch Text:@"Limit Search To :" WithFont:HELVETICALTSTD_LIGHT FSize:19 Color:BLACK_COLOR];
    [Helper setToLabel:lblShowAges Text:@"Show Ages :" WithFont:HELVETICALTSTD_LIGHT FSize:19 Color:BLACK_COLOR];
    [Helper setToLabel:lblMen Text:@"Men" WithFont:HELVETICALTSTD_LIGHT FSize:19 Color:[Helper getColorFromHexString:@"#999999" :1.0]];
    [Helper setToLabel:lblWomen Text:@"Women" WithFont:HELVETICALTSTD_LIGHT FSize:19 Color:[Helper getColorFromHexString:@"#999999" :1.0]];
    [Helper setToLabel:lblDistanceTxt Text:nil WithFont:HELVETICALTSTD_LIGHT FSize:19 Color:[Helper getColorFromHexString:@"#999999" :1.0]];
    [Helper setToLabel:lblAgeMin Text:Nil WithFont:HELVETICALTSTD_ROMAN FSize:19 Color:BLACK_COLOR];
    [Helper setToLabel:lblDistance Text:nil WithFont:HELVETICALTSTD_ROMAN FSize:19 Color:BLACK_COLOR];
    [Helper setButton:btncontactUs Text:@"Contact Us" WithFont:HELVETICALTSTD_LIGHT FSize:15 TitleColor:[Helper getColorFromHexString:@"#999999" :1.0] ShadowColor:nil];
    [Helper setButton:btnLogout Text:@"Log Out" WithFont:HELVETICALTSTD_LIGHT FSize:15 TitleColor:[Helper getColorFromHexString:@"#999999" :1.0] ShadowColor:nil];
    [Helper setButton:btnSubmitt Text:@"Update" WithFont:HELVETICALTSTD_LIGHT FSize:15 TitleColor:[Helper getColorFromHexString:@"#999999" :1.0] ShadowColor:nil];
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
       swichFemale.onTintColor = [UIColor greenColor];
       switchMale.onTintColor = [UIColor greenColor];
        //[swichFemale setOnImage: [UIImage imageNamed:@"switch.png"]];
       //[swichFemale setOffImage:[UIImage imageNamed:@"switch.png"]];
    }

    NSDictionary * dict= [ud objectForKey:UDFacebookDetail];
    NSLog(@"Userdict %@",dict);
    
    NSDictionary * dictAge = [dict objectForKey:FACEBOOK_AGERANGE];
    NSArray * arrIntrest = [dict objectForKey:FACEBOOK_INTRESTED_IN];
    
//    switch ([[dict objectForKey:RPLoginPrefSex] intValue]) {
//        case MALE:
//        {
//            [swichFemale setOn:NO animated:YES];
//            [switchMale setOn:YES animated:YES];
//            break;
//        }
//        case FEMALE:
//        {
//            [swichFemale setOn:YES animated:YES];
//            [switchMale setOn:NO animated:YES];
//            break;
//        }
//        case BOTH:
//        {
//            [swichFemale setOn:YES animated:YES];
//            [switchMale setOn:YES animated:YES];
//            break;
//        }
//            
//        default:
//            break;
//    }
    
    if ([[dict objectForKey:RPLoginPrefSex] intValue] ==MALE) {
        
    }
    else if ([[dict objectForKey:RPLoginPrefSex] intValue] ==MALE)
    {
        
    }
    
    /***** settings For Intrest ******/
    
    if ([ud integerForKey:@"INTREST"]==0) {
        
    if ( arrIntrest.count>1)
    {
       [swichFemale setOn:YES animated:YES];
       [switchMale setOn:YES animated:YES];
        Intested_in = 3;

    }
    else{
        if ([[arrIntrest objectAtIndex:0] isEqualToString:@"female"]) {
            [swichFemale setOn:YES animated:YES];
            [switchMale setOn:NO animated:YES];
            Intested_in = 2;
        }
        else if([[arrIntrest objectAtIndex:0] isEqualToString:@"male"])
        {
           [switchMale setOn:YES animated:YES];
           [swichFemale setOn:NO animated:YES];
            Intested_in = 1;
        }
        else
        {
            [switchMale setOn:NO animated:YES];
            [swichFemale setOn:YES animated:YES];
            Intested_in = 1;
        }
    }
    }
    else{
     
        if ([ud integerForKey:@"INTREST"]==1) {
            [switchMale setOn:YES animated:YES];
            [swichFemale setOn:NO animated:YES];
            Intested_in = 1;
        }
        else if([ud integerForKey:@"INTREST"]==2)
        {
            [swichFemale setOn:YES animated:YES];
            [switchMale setOn:NO animated:YES];
            Intested_in = 2;
        }
        else if([ud integerForKey:@"INTREST"]==3)
        {
            [swichFemale setOn:YES animated:YES];
            [switchMale setOn:YES animated:YES];
            Intested_in = 3;
        }
    }
    
    /***** settings For gender******/
    
    if ([ud integerForKey:@"GENDER"]==0)
    {
    if ([[dict objectForKey:FACEBOOK_GENDER] isEqualToString:@"female"])
    {
        
        [btnFemale setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
        [btnMale setTitleColor:[Helper getColorFromHexString:@"#999999" :1.0] forState:UIControlStateNormal];
        btnFemale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
        [btnFemale setBackgroundImage:[UIImage imageNamed:@"indicator_tab.png"] forState:UIControlStateSelected];
        btnMale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
        [btnMale setBackgroundImage:nil forState:UIControlStateNormal];
        [btnFemale setSelected:YES];
        [btnMale setSelected:NO];
         sex =FEMALE;
    }
    else
    {
        [btnMale setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
        [btnFemale setTitleColor:[Helper getColorFromHexString:@"#999999" :1.0] forState:UIControlStateNormal];
        [btnMale setBackgroundImage:[UIImage imageNamed:@"indicator_tab.png"] forState:UIControlStateSelected];
        btnFemale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
        btnMale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
        [btnFemale setBackgroundImage:nil forState:UIControlStateNormal];
        [btnMale setSelected:YES];
        [btnFemale setSelected:NO];
         sex=MALE;
        
        
    }
    }
    else
    {
       
        if ([ud integerForKey:@"GENDER"]==FEMALE)
        {
            [btnFemale setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
            [btnMale setTitleColor:[Helper getColorFromHexString:@"#999999" :1.0] forState:UIControlStateNormal];
            btnFemale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            [btnFemale setBackgroundImage:[UIImage imageNamed:@"indicator_tab.png"] forState:UIControlStateSelected];
            btnMale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            [btnMale setBackgroundImage:nil forState:UIControlStateNormal];
            [btnFemale setSelected:YES];
            [btnMale setSelected:NO];
            sex=FEMALE;
            
            
        }
        else{
            
            [btnMale setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
            [btnFemale setTitleColor:[Helper getColorFromHexString:@"#999999" :1.0] forState:UIControlStateNormal];
            [btnMale setBackgroundImage:[UIImage imageNamed:@"indicator_tab.png"] forState:UIControlStateSelected];
            btnFemale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            btnMale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            [btnFemale setBackgroundImage:nil forState:UIControlStateNormal];
            [btnMale setSelected:YES];
            [btnFemale setSelected:NO];
            sex =MALE;
            
        }
   
    }
    
    
    if ([ud integerForKey:@"DIST"]==3)
    {
        
            
            [btnMile setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
            [btnKm setTitleColor:[Helper getColorFromHexString:@"#999999" :1.0] forState:UIControlStateNormal];
            btnMile.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            [btnMile setBackgroundImage:[UIImage imageNamed:@"indicator_tab.png"] forState:UIControlStateSelected];
            btnKm.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            [btnKm setBackgroundImage:nil forState:UIControlStateNormal];
            [btnMile setSelected:YES];
            [btnKm setSelected:NO];
            
       
    }
    else if([ud integerForKey:@"DIST"]==4)
    {
        [btnKm setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
        [btnMile setTitleColor:[Helper getColorFromHexString:@"#999999" :1.0] forState:UIControlStateNormal];
        btnKm.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
        [btnKm setBackgroundImage:[UIImage imageNamed:@"indicator_tab.png"] forState:UIControlStateSelected];
        btnKm.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
        [btnMile setBackgroundImage:nil forState:UIControlStateNormal];
        [btnKm setSelected:YES];
        [btnMile setSelected:NO];
 
    }
    else{
        [btnMile setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
        [btnKm setTitleColor:[Helper getColorFromHexString:@"#999999" :1.0] forState:UIControlStateNormal];
        btnMile.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
        [btnMile setBackgroundImage:[UIImage imageNamed:@"indicator_tab.png"] forState:UIControlStateSelected];
        btnKm.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
        [btnKm setBackgroundImage:nil forState:UIControlStateNormal];
        [btnMile setSelected:YES];
        [btnKm setSelected:NO];
  
    }
   
    
    /***** settings For distance slider******/
    
    [sliderDistance setValue:50 animated:YES];
    sliderDistance.maximumValue =100;
    sliderDistance.minimumValue = 0;
    if (![ud objectForKey:@"DISTANCE"]) {
        
        if ([ud integerForKey:@"DIST"] ==3) {
            lblDistance.text = [NSString stringWithFormat:@"%dmi", 50];
        }
        else if ([ud integerForKey:@"DIST"] ==4) {
            lblDistance.text = [NSString stringWithFormat:@"%dkm", 50];
        }
        else{
         lblDistance.text =@"50mi";
        }
        sliderDistance.value =50;
    }
    else{
        if ([ud integerForKey:@"DIST"] ==3) {
            lblDistance.text = [NSString stringWithFormat:@"%dmi", [[ud objectForKey:@"DISTANCE"] intValue]];
        }
        else if ([ud integerForKey:@"DIST"] ==4) {
            lblDistance.text = [NSString stringWithFormat:@"%dkm", [[ud objectForKey:@"DISTANCE"] intValue]];
        }
        else{
            lblDistance.text =[NSString stringWithFormat:@"%dmi", [[ud objectForKey:@"DISTANCE"] intValue]];
        }

       
        sliderDistance.value =[[ud objectForKey:@"DISTANCE"]intValue];
    }
    
    /***** settings For max and Min age slider******/

   
    int min = [[dictAge objectForKey:AGERANGE_MIN] intValue];
    int max = [[dictAge objectForKey:AGERANGE_MAX] intValue];

    UIImage *minImage = [[UIImage imageNamed:@"slider_blue.png"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    UIImage *maxImage = [[UIImage imageNamed:@"slider_gray.png"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    UIImage *thumbImage = [UIImage imageNamed:@"slider_btn.png"];
    
    [[UISlider appearance] setMaximumTrackImage:maxImage
                                       forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:minImage
                                       forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage
                                forState:UIControlStateNormal];

 
    slider = [[RangeSlider alloc] initWithFrame:CGRectMake(18, 379, 286, 26)];
    // the slider enforces a height of 30, although I'm not sure that this is necessary
	    slider.minimumRangeLength = 0.1;
	[slider setMinThumbImage:[UIImage imageNamed:@"slider_btn.png"]]; // the two thumb controls are given custom images
	[slider setMaxThumbImage:[UIImage imageNamed:@"slider_btn.png"]];
    //slider.min =(min-18)/40;
    //slider.max =(max-18)/40;
    [scrollview addSubview:slider];
	
	[slider setTrackImage:[[UIImage imageNamed:@"slider_gray.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(9.0, 9.0, 9.0, 9.0)]];
	[slider setInRangeTrackImage:[UIImage imageNamed:@"slider_blue.png"]];
    
	[slider addTarget:self action:@selector(report:) forControlEvents:UIControlEventValueChanged];
    
    if ([ud integerForKey:@"PrefMin"] ||[ud integerForKey:@"PrefMax"]) {
        lblAgeMin.text = [NSString stringWithFormat:@"%d-%d+",[ud integerForKey:@"PrefMin"],[ud integerForKey:@"PrefMax"]];
        if ([ud integerForKey:@"PrefMin"]>18) {
           float val = ([ud integerForKey:@"PrefMin"]-18.0)/40.0;
             [slider setMin:val];
        }
          if ([ud integerForKey:@"PrefMax"] > 18 && [ud integerForKey:@"PrefMax"] < 58)
          {
               float val = ([ud integerForKey:@"PrefMax"]-18.0)/40.0;
                [slider setMax:val];
          }
       
      
    }
    else{
        lblAgeMin.text = [NSString stringWithFormat:@"18-58+"];
        if (min > 18) {
            float val = (min-18.0)/40.0;
            [slider setMin:val];
        }
        if (max > 18 && max < 58) {
            [slider setMax:(max-18.0)/40.0];
        }

        
    }

       // [self report:slider];
    
    btnAccountDelete.frame = CGRectMake(13, btnSubmitt.frame.origin.y+btnSubmitt.frame.size.height+150, 296, 49);
    
    viewBG.frame = CGRectMake(0,44, 320,  btnAccountDelete.frame.origin.y+btnAccountDelete.frame.size.height+50);
    btnAccountDelete.userInteractionEnabled = YES;
    viewBG.backgroundColor = [UIColor clearColor];
  
    [Helper setButton:btnAccountDelete Text:@"Delete Account" WithFont:HELVETICALTSTD_LIGHT FSize:19 TitleColor:WHITE_COLOR  ShadowColor:nil];
    [super viewDidLoad];
    if (IS_IPHONE_5) {
        scrollview.contentSize = CGSizeMake(320, btnAccountDelete.frame.origin.y+btnAccountDelete.frame.size.height+100);
    }
    else{
        scrollview.contentSize = CGSizeMake(320, btnAccountDelete.frame.origin.y+btnAccountDelete.frame.size.height+120);
    }
  
    // Do any additional setup after loading the view from its nib.
}

-(void)saveUpdatedValue
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];

    NSDictionary * dict= [ud objectForKey:@"FBUSERDETAIL"];
    NSDictionary * dictAge = [dict objectForKey:FACEBOOK_AGERANGE];
    NSArray * arrIntrest = [dict objectForKey:FACEBOOK_INTRESTED_IN];
    
    /***** settings For Intrest ******/

    if ([ud integerForKey:@"INTREST"]==0) {
        
        if ( arrIntrest.count>1)
        {
            [swichFemale setOn:YES animated:YES];
            [switchMale setOn:YES animated:YES];
            Intested_in = 3;
            
        }
        else{
            if ([[arrIntrest objectAtIndex:0] isEqualToString:@"female"]) {
                [swichFemale setOn:YES animated:YES];
                [switchMale setOn:NO animated:YES];
                Intested_in = 2;
            }
            else if([[arrIntrest objectAtIndex:0] isEqualToString:@"male"])
            {
                [switchMale setOn:YES animated:YES];
                [swichFemale setOn:NO animated:YES];
                Intested_in = 1;
            }
            else
            {
                [switchMale setOn:NO animated:YES];
                [swichFemale setOn:YES animated:YES];
                Intested_in = 1;
            }
        }
    }
    else{
        
        if ([ud integerForKey:@"INTREST"]==1) {
            [switchMale setOn:YES animated:YES];
            [swichFemale setOn:NO animated:YES];
            Intested_in = 1;
        }
        else if([ud integerForKey:@"INTREST"]==2)
        {
            [swichFemale setOn:YES animated:YES];
            [switchMale setOn:NO animated:YES];
            Intested_in = 2;
        }
        else if([ud integerForKey:@"INTREST"]==3)
        {
            [swichFemale setOn:YES animated:YES];
            [switchMale setOn:YES animated:YES];
            Intested_in = 3;
        }
        
        
    }
    
    
    /***** settings For gender******/

    if ([ud integerForKey:@"GENDER"]==0) {
        
        if ([[dict objectForKey:FACEBOOK_GENDER] isEqualToString:@"female"])
        {
            
            [btnFemale setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
            [btnMale setTitleColor:[Helper getColorFromHexString:@"#999999" :1.0] forState:UIControlStateNormal];
            btnFemale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            [btnFemale setBackgroundImage:[UIImage imageNamed:@"indicator_tab.png"] forState:UIControlStateSelected];
            btnMale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            [btnMale setBackgroundImage:nil forState:UIControlStateNormal];
            [btnFemale setSelected:YES];
            [btnMale setSelected:NO];
            
            sex =FEMALE;
        }
        else
        {
            [btnMale setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
            [btnFemale setTitleColor:[Helper getColorFromHexString:@"#999999" :1.0] forState:UIControlStateNormal];
            [btnMale setBackgroundImage:[UIImage imageNamed:@"indicator_tab.png"] forState:UIControlStateSelected];
            btnFemale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            btnMale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            [btnFemale setBackgroundImage:nil forState:UIControlStateNormal];
            [btnMale setSelected:YES];
            [btnFemale setSelected:NO];
            sex=MALE;
            
            
        }
    }
    else
    {
        
        if ([ud integerForKey:@"GENDER"]==FEMALE)
        {
            [btnFemale setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
            [btnFemale setTitleColor:[Helper getColorFromHexString:@"#999999" :1.0] forState:UIControlStateNormal];
            btnFemale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            [btnFemale setBackgroundImage:[UIImage imageNamed:@"indicator_tab.png"] forState:UIControlStateSelected];
            btnMale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            [btnMale setBackgroundImage:nil forState:UIControlStateNormal];
            [btnFemale setSelected:YES];
            [btnMale setSelected:NO];
            sex=FEMALE;
            
            
        }
        else{
            
            [btnMale setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
            [btnFemale setTitleColor:[Helper getColorFromHexString:@"#999999" :1.0] forState:UIControlStateNormal];
            [btnMale setBackgroundImage:[UIImage imageNamed:@"indicator_tab.png"] forState:UIControlStateSelected];
            btnFemale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            btnMale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            [btnFemale setBackgroundImage:nil forState:UIControlStateNormal];
            [btnMale setSelected:YES];
            [btnFemale setSelected:NO];
            sex =MALE;
            
        }
        
    }
    
     /***** settings For distance slider******/
    
    [sliderDistance setValue:50 animated:YES];
    sliderDistance.maximumValue =100;
    sliderDistance.minimumValue = 0;
    
    UIImage *minImage = [[UIImage imageNamed:@"slider_blue.png"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    UIImage *maxImage = [[UIImage imageNamed:@"slider_gray.png"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    UIImage *thumbImage = [UIImage imageNamed:@"slider_btn.png"];
    
    [[UISlider appearance] setMaximumTrackImage:maxImage
                                       forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:minImage
                                       forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage
                                forState:UIControlStateNormal];
    
    NSLog(@"distance%@",[ud objectForKey:@"DISTANCE"]);
    if (![ud objectForKey:@"DISTANCE"]) {
        
        if ([ud integerForKey:@"DIST"] ==3) {
            lblDistance.text = [NSString stringWithFormat:@"%dmi", 50];
        }
        else if ([ud integerForKey:@"DIST"] ==4) {
            lblDistance.text = [NSString stringWithFormat:@"%dkm", 50];
        }
        else{
            lblDistance.text =@"50mi";
        }
        sliderDistance.value =50;
    }
    else{
        if ([ud integerForKey:@"DIST"] ==3) {
            lblDistance.text = [NSString stringWithFormat:@"%dmi", [[ud objectForKey:@"DISTANCE"] intValue]];
        }
        else if ([ud integerForKey:@"DIST"] ==4) {
            lblDistance.text = [NSString stringWithFormat:@"%dkm", [[ud objectForKey:@"DISTANCE"] intValue]];
        }
        else{
            lblDistance.text =@"50mi";
        }
        
        
        sliderDistance.value =[[ud objectForKey:@"DISTANCE"]intValue];
    }

    
    
    
      /***** settings For max and Min age slider******/
    int min = [[dictAge objectForKey:AGERANGE_MIN] intValue];
    int max = [[dictAge objectForKey:AGERANGE_MAX] intValue];
    NSLog(@"%d,%d",min,max);
   
    // there are two track images, one for the range "track", and one for the filled in region of the track between the slider thumbs
	
    [slider setTrackImage:[[UIImage imageNamed:@"slider_gray.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(9.0, 9.0, 9.0, 9.0)]];
	[slider setInRangeTrackImage:[UIImage imageNamed:@"slider_blue.png"]];
    
    if ([ud integerForKey:@"PrefMin"] ||[ud integerForKey:@"PrefMax"]) {
        lblAgeMin.text = [NSString stringWithFormat:@"%d-%d+",[ud integerForKey:@"PrefMin"],[ud integerForKey:@"PrefMax"]];
        if ([ud integerForKey:@"PrefMin"]>18) {
            float val = ([ud integerForKey:@"PrefMin"]-18.0)/40.0;
            [slider setMin:val];
        }
        if ([ud integerForKey:@"PrefMax"] > 18 && [ud integerForKey:@"PrefMax"] < 58)
        {
            float val = ([ud integerForKey:@"PrefMax"]-18.0)/40.0;
            [slider setMax:val];
        }
    }
    else{
        lblAgeMin.text = [NSString stringWithFormat:@"18-58+"];
        if (min > 18) {
            float val = (min-18.0)/40.0;
            [slider setMin:val];
        }
        if (max > 18 && max < 58) {
            [slider setMax:(max-18.0)/40.0];
        }
        
        
    }
    //[self report:slider];
    [super viewDidLoad];
  
}
-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -Button Action(GENDER AND DISTANCE)
-(IBAction)btnAction:(id)sender{
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    UIButton * btn = (UIButton*)sender;
    switch (btn.tag) {
        case MALE:
        {
            
            [btnMale setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
            [btnFemale setTitleColor:[Helper getColorFromHexString:@"#999999" :1.0] forState:UIControlStateNormal];
            [btnMale setBackgroundImage:[UIImage imageNamed:@"indicator_tab.png"] forState:UIControlStateSelected];
            [btnFemale setBackgroundImage:nil forState:UIControlStateNormal];
            btnFemale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            btnMale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            [btnMale setSelected:YES];
            [btnFemale setSelected:NO];
            sex  = MALE;
            
            [ud setInteger:MALE forKey:@"GENDER"];
        
            break;
        }
        case FEMALE:
        {
            
            [btnFemale setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
            [btnMale setTitleColor:[Helper getColorFromHexString:@"#999999" :1.0] forState:UIControlStateNormal];
            [btnFemale setBackgroundImage:[UIImage imageNamed:@"indicator_tab.png"] forState:UIControlStateSelected];
            [btnMale setBackgroundImage:nil forState:UIControlStateNormal];
            btnFemale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            btnMale.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            [btnMale setSelected:NO];
            [btnFemale setSelected:YES];
            sex  = FEMALE;
            [ud setInteger:FEMALE forKey:@"GENDER"];
            break;
        }
        case MILE:
        {
            
            [btnMile setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
            [btnKm setTitleColor:[Helper getColorFromHexString:@"#999999" :1.0] forState:UIControlStateNormal];
            [btnMile setBackgroundImage:[UIImage imageNamed:@"indicator_tab.png"] forState:UIControlStateSelected];
            [btnKm setBackgroundImage:nil forState:UIControlStateNormal];
            btnMile.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            btnKm.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            [btnKm setSelected:NO];
            [btnMile setSelected:YES];
            [ud setInteger:MILE forKey:@"DIST"];
            
            break;
        }
        case KM:
        {
            
            [btnKm setTitleColor:WHITE_COLOR forState:UIControlStateSelected];
            [btnMile setTitleColor:[Helper getColorFromHexString:@"#999999" :1.0] forState:UIControlStateNormal];
            [btnKm setBackgroundImage:[UIImage imageNamed:@"indicator_tab.png"] forState:UIControlStateSelected];
            [btnMile setBackgroundImage:nil forState:UIControlStateNormal];
            btnMile.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            btnKm.titleLabel.font = [UIFont fontWithName:HELVETICALTSTD_LIGHT size:19.0];
            [btnMile setSelected:NO];
            [btnKm setSelected:YES];
            [ud setInteger:KM forKey:@"DIST"];
            
            break;
        }


            
        default:
            break;
    }
}

#pragma mark-switch method For male and female

- (void)setState:(id)sender
{
  
    UISwitch * swch = (UISwitch*)sender;
    BOOL state = [sender isOn];
    
    NSLog(@"state%d",state);
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
 
    switch (swch.tag) {
        case 0:
        {
            if ([swichFemale isOn]==YES && [switchMale isOn]==YES) {
                
                Intested_in = 3;
                [ud setInteger:Intested_in forKey:@"INTREST"];
                
            }
            else if([swichFemale isOn]==YES && [switchMale isOn]==NO)
            {
                Intested_in =2;
                
                [ud setInteger:Intested_in forKey:@"INTREST"];

            }
            
            else if([swichFemale isOn]==NO && [switchMale isOn]==YES)
            {
                Intested_in =1;
                [ud setInteger:Intested_in forKey:@"INTREST"];
            }
            else{
               Intested_in =3;
                 [ud setInteger:Intested_in forKey:@"INTREST"];
            }
            
            
            break;
        }
        case 1:
        {
          
            if ([swichFemale isOn]==YES && [switchMale isOn]==YES) {
                
                Intested_in = 3;
                [ud setInteger:Intested_in forKey:@"INTREST"];
                
            }
            else if([swichFemale isOn]==YES && [switchMale isOn]==NO)
            {
                Intested_in =2;
                [ud setInteger:Intested_in forKey:@"INTREST"];
            }
            
            else if([swichFemale isOn]==NO && [switchMale isOn]==YES)
            {
                Intested_in =1;
                [ud setInteger:Intested_in forKey:@"INTREST"];
            }
            else{
                Intested_in =3;
                [ud setInteger:Intested_in forKey:@"INTREST"];
            }

            break;
        }

            
        default:
            break;
    }
    
   
}


#pragma mark - slider Distance value Change method

-(IBAction)sliderChange:(UISlider*)sender {
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    NSString *newText = [[NSString alloc] initWithFormat:@"%d",(int)[sender value]];
    if ([[ud objectForKey:@"DIST"] intValue] ==3) {
      lblDistance.text = [NSString stringWithFormat:@"%@mi", newText];
    }
     else if ([[ud objectForKey:@"DIST"] intValue] ==4) {
        lblDistance.text = [NSString stringWithFormat:@"%@km", newText];
    }
     else{
         
     lblDistance.text= [NSString stringWithFormat:@"%@mi", newText];
         
     }
   
    [ud setObject:lblDistance.text forKey:@"DISTANCE"];

   
}

#pragma mark -slider age(MAX and MIN)

- (void)report:(RangeSlider *)sender {
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    int min = sender.min*40+18;
    int max = sender.max*40+18;
    
    [ud setInteger:min forKey:@"PrefMin"];
    [ud setInteger:max forKey:@"PrefMax"];
    [ud synchronize];
    
	NSString *report = nil;
    if (max >= 58) {
       report = [NSString stringWithFormat:@"%d-58+", min];
        
    }
    else {
        report = [NSString stringWithFormat:@"%d-%d", min, max];
 
    }
	lblAgeMin.text = report;
	NSLog(@"%f-%f",sender.min, sender.max);
    NSLog(@"%d-%d",min, max);
    
    
   
}

#pragma mark - Button Action (Update Prefrance ,Logout,mail and Delete)
-(IBAction)btnActionBottom:(id)sender{
    UIButton * btn = (UIButton*)sender;
    switch (btn.tag) {
        case 11:
        {
            [self openMail];
            break;
        }
        case 12:
        {
            [self sendRequestForLogOut];
            break;
        }
        case 13:
        {
            [self sendRequestForUpdate];
            break;
        }
        case 14:
        {
            [self sendRequestForDeleteAccount];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark- Request And Response For Delete Account

-(void)sendRequestForDeleteAccount
{
//    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
//    [pi showPIOnView:self.view withMessage:@"Deleting Account.."];
    
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
    NSLog(@"deleteAccount%@",paramDict );
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    handler.requestType = eParseKey;
    NSMutableURLRequest * request = [Service parseDeleteAccount:paramDict];
    
    [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(DeleteAccount:)];
}

-(void)DeleteAccount:(NSDictionary*)_response
{
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];

    NSLog(@"response %@",_response);
    
    if (_response == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Connection Timeout." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
        alert.tag = 400;
        [alert show];
    }
    else
    {
        
        if (_response != nil) {
            
            NSDictionary *dict = [_response objectForKey:@"ItemsList"];
            NSLog(@"dict%@",dict);
            
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"TOKEN"];
//            [FBSession.activeSession closeAndClearTokenInformation];
//            
//            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFirstLaunchForMatchedList"];
//            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFirstLaunchOver"];
//            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFirstSignupOrLogin"];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PrefMin"];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PrefMax"];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"INTREST"];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"GENDER"];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"DISTANCE"];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"DIST"];
//            
//            
//            
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
          //  LoginViewController * login;
         //   CGRect screen = [[UIScreen mainScreen]bounds];
            
             if ([[dict objectForKey:@"errFlag"]intValue]==0 && [[dict objectForKey:@"errNum"]intValue]==61) {
                //[Helper showAlertWithTitle:@"Message" Message:[dict objectForKey:@"errMsg"]];
                 
                 
                 UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"You are about to delete all your account details incliuding matches and chat too. Are you sure?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                 alert.tag =102;
                 [alert show];

                
                 
//                 if (screen.size.height==568)
//                 {
//                     
//                     
//                     login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//                     
//                     // self.window.rootViewController =  navigationController;
//                     
//                 }
//                 else{
//                     login = [[LoginViewController alloc] initWithNibName:@"LoginViewController_ip4" bundle:nil];
//                     
//                     // self.window.rootViewController =  navigationController;
//                 }
//                 
//                 [self.navigationController pushViewController:login animated:YES];
                 
            }
            
             else if ([[dict objectForKey:@"errFlag"]intValue]==1 && [[dict objectForKey:@"errNum"]intValue]==31){
                 
                 UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"You are about to delete all your account details incliuding matches and chat too. Are you sure?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                 alert.tag =102;
                 [alert show];
             }
            

            else if ([[dict objectForKey:@"errFlag"]intValue]==1 && [[dict objectForKey:@"errNum"]intValue]==62){
                
                [pi showMessage:[dict objectForKey:@"errMsg"] On:self.view];
                
            }

           
            
            
            
            
            
            
            
        }
        
        
    }
    
    [pi hideProgressIndicator];
 
}

#pragma mark- Request And Response For Logout

-(void)sendRequestForLogOut
{
//    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
//    [pi showPIOnView:self.view withMessage:@"Logging Out.."];
    
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
    
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    handler.requestType = eParseKey;
    NSMutableURLRequest * request = [Service parseLogOut:paramDict];
    [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(LogoutResponse:)];
    
    
}

-(void)LogoutResponse:(NSDictionary*)_response
{
    
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    NSLog(@"response %@",_response);
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
            NSLog(@"%@",dict);

           
            if (!dict) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Connection Timeout." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    [pi hideProgressIndicator];
            }
            
 
                
            if ([[dict objectForKey:@"errFlag"]intValue]==0 && [[dict objectForKey:@"errNum"]intValue]==41) {
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Are you sure to logout from your account?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                  alert.tag =101;
                 [alert show];
                 
                
                
                
            }
            else
            {
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Are you sure to logout from your account?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                alert.tag =101;
                [alert show];
                
//                [Helper showAlertWithTitle:@"Error" Message:dict[@"errMsg"]];
//                [pi hideProgressIndicator];
                
            }

            
          
            
        }
        
        
    }
    
  
    
    
}

-(void)logout{
    
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"TOKEN"];
    [FBSession.activeSession closeAndClearTokenInformation];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFirstLaunchForMatchedList"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFirstLaunchOver"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isFirstSignupOrLogin"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PrefMin"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PrefMax"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"INTREST"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"GENDER"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"DISTANCE"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"DIST"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    LoginViewController * login;
    CGRect screen = [[UIScreen mainScreen]bounds];
    if (screen.size.height==568)
    {
        
        
        login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        
        // self.window.rootViewController =  navigationController;
        
    }
    else{
        login = [[LoginViewController alloc] initWithNibName:@"LoginViewController_ip4" bundle:nil];
        
        // self.window.rootViewController =  navigationController;
    }
    
    [self.navigationController pushViewController:login animated:YES];
    
    [pi hideProgressIndicator];
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
        
      //[self presentModalViewController:mailer animated:YES];
        
        
        [self.navigationController presentViewController:mailer animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
        
        
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
    if (result == MFMailComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MFMailComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed")  ;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark- Request And Response For Update Prefrence

-(void)sendRequestForUpdate
{
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"updating.."];
   
     NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
     NSString * strUUID = nil;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        
        strUUID = [oNSUUID UUIDString];
        
    } else {
      
        strUUID = [oNSUUID UUIDString];
       
        
    }
    int distance = [lblDistance.text intValue];
    int lowerAge;
    int UpperAge;
   // NSString * strPreferdAge = lblAgeMin.text;
    //NSArray *arrPreferdAge = [strPreferdAge componentsSeparatedByString:@"-"];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PrefMin"] ==0) {
          lowerAge = 18;
    }
    else{
        lowerAge =[[NSUserDefaults standardUserDefaults] integerForKey:@"PrefMin"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PrefMax"] ==0) {
        UpperAge = 56;
    }
    else{
        UpperAge = [[NSUserDefaults standardUserDefaults] integerForKey:@"PrefMin"];
    }
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN"] forKey:RPSessionToken];
    [paramDict setObject:strUUID forKey:RPDeviceId];
    [paramDict setObject:[NSString stringWithFormat:@"%d",sex] forKey:RPUpdatePreferedSex];
    [paramDict setObject:[NSString stringWithFormat:@"%d",Intested_in] forKey:RPUpdatePreferedPrefSex];
    [paramDict setObject:[NSString stringWithFormat:@"%d",lowerAge] forKey:RPUpdatePreferedLowerAge];
    [paramDict setObject:[NSString stringWithFormat:@"%d",UpperAge] forKey:RPUpdatePreferedUpperAge];
    [paramDict setObject:[NSString stringWithFormat:@"%d",distance] forKey:RPUpdatePreferedRadius];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"DIST"] ==3) {
          [paramDict setObject:[NSString stringWithFormat:@"%d",2] forKey:RPUpdatePreferedDistanceType];
    }
    else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"DIST"] ==4) {
           [paramDict setObject:[NSString stringWithFormat:@"%d",1] forKey:RPUpdatePreferedDistanceType];
    }
    else{
      [paramDict setObject:[NSString stringWithFormat:@"%d",2] forKey:RPUpdatePreferedDistanceType];
    }

    
    NSLog(@"dict%@",paramDict);
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    handler.requestType = eParseKey;
    NSMutableURLRequest * request = [Service parseGetUpdatePrefrences:paramDict];
    NSLog(@"request%@",request);
    [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(settingResponse:)];
   
}
-(void)settingResponse:(NSDictionary*)_response
{
   
    ProgressIndicator * pi = [ProgressIndicator sharedInstance];
    NSLog(@"response %@",_response);
    
    if (_response == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Connection Timeout." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
        alert.tag = 400;
        [alert show];
    }
    else
    {
        if (_response != nil) {
            NSDictionary *dict = [_response objectForKey:@"ItemsList"];
            NSLog(@"%@",dict);
            
            if (!dict) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Connection Timeout." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
                [alert show];
                
                [pi hideProgressIndicator];
            }
            else
            {
            
            if ([[dict objectForKey:@"errFlag"]intValue]==0 && [[dict objectForKey:@"errNum"]intValue]==13) {
                //[Helper showAlertWithTitle:@"Message" Message:[dict objectForKey:@"errMsg"]];
                [pi showMessage:[dict objectForKey:@"errMsg"] On:self.view];
            }
            else if ([[dict objectForKey:@"errFlag"]intValue]==1 && [[dict objectForKey:@"errNum"]intValue]==14){
            
           [pi showMessage:[dict objectForKey:@"errMsg"] On:self.view];
            
        }
        else if ([[dict objectForKey:@"errFlag"]intValue]==1 && [[dict objectForKey:@"errNum"]intValue]==14)
        {
         [pi showMessage:[dict objectForKey:@"errMsg"] On:self.view];
        }
        else{
          [pi showMessage:[dict objectForKey:@"errMsg"] On:self.view];
        }
        
            [pi hideProgressIndicator];

        }
        
        
    }
    }
    

}



#pragma mark -PPRevealSlider Delegte method
- (BOOL) pprevealSideViewController:(PPRevealSideViewController *)controller shouldDeactivateGesture:(UIGestureRecognizer*)gesture forView:(UIView*)view
{
    if ([view isEqual:slider] || [view isEqual:sliderDistance]||[view isEqual:sliderAgeBox]||[view isEqual:sliderDistanceBox]) {
        return YES;
    }
    return NO;
}
#pragma mark -UIALertView Delegte method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //ProgressIndicator * pi =[ProgressIndicator sharedInstance];
    
    if (alertView.tag==101) {
        
        //[pi showPIOnView:self.view withMessage:@"Logging Out.."];
        if (buttonIndex==0) {
            //[pi hideProgressIndicator];
        }
        else{
          [self logout];
        }
        
    }
   else if (alertView.tag==102) {
         //[pi showPIOnView:self.view withMessage:@"Deleting Account.."];
       if (buttonIndex==0) {
          // [pi hideProgressIndicator];
       }
       else{
           [self logout];
       }
       
    }
    
}

@end
