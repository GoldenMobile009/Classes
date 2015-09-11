//
//  MatchedViewController.m
//  Tinder
//
//  Created by Rahul Sharma on 07/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import "MatchedViewController.h"
#import "ProfileMatchedCell.h"
#import "DBHandler.h"
#import "MatchedUserList.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "JSDemoViewController.h"
#import "ProgressIndicator.h"
@interface MatchedViewController ()

@end

@implementation MatchedViewController
@synthesize tblView;
@synthesize matchedUserLists;

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
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [Helper getColorFromHexString:@"#333333" :1.0];
    
    self.title = @"Matched List";
    
    ProgressIndicator *progress = [ProgressIndicator sharedInstance];
    [progress showPIOnView:self.view withMessage:@"loading"];
    
    WebServiceHandler *webservicehandler = [[WebServiceHandler alloc]init];
    webservicehandler.delegate = self;
    
    [webservicehandler webserviceRequestAndResponse:nil serviceType:1 facebookId:nil];
    [self deleteAllDbObject];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)deleteAllDbObject
{
    TinderAppDelegate *appDelegate =(TinderAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MatchedUserList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray*fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *fetchedCategorList=[[NSMutableArray alloc]initWithArray:fetchedObjects];
    
    for (NSManagedObject *managedObject in fetchedCategorList) {
    	[context deleteObject:managedObject];
    	//DLog(@"%@ object deleted",entityDescription);
    }
    if (![context save:&error]) {
    	//NSLog(@"Error deleting %@ - error:",error);
    }
    
    
}

#pragma mark - Other Method
- (void)dataInsertedSucessfullyInDb:(BOOL)success{
    [self.matchedUserLists removeAllObjects];
    
    self.matchedUserLists = (NSMutableArray *)[DBHandler dataFromTable:@"MatchedUserList" condition:nil orderBy:nil ascending:NO];
    [self.tblView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count :%d",self.matchedUserLists.count);
    return [self.matchedUserLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"CellIdentifier";
	
	ProfileMatchedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
        cell = [[ProfileMatchedCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		[cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    NSLog(@"count cellForRowAtIndexPath:%d",self.matchedUserLists.count);
    
    
    MatchedUserList *matchedUserList = [self.matchedUserLists objectAtIndex:indexPath.row];
    cell.labelFirstName.text = matchedUserList.fName;
    
    
    UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(50/2-20/2, 46/2-20/2, 20, 20)];
    [cell.thumbNailImage addSubview:activityIndicator];
    // activityIndicator.backgroundColor=[UIColor greenColor];
    activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [activityIndicator startAnimating];
    
    
    NSURL *urlImagePath=[NSURL URLWithString:matchedUserList.proficePic];
    
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:urlImagePath
                                                        options:0
                                                       progress:^(NSUInteger receivedSize, long long expectedSize)
     {
         // progression tracking code
     }
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished)
         {
             [activityIndicator stopAnimating];
             cell.thumbNailImage.image =image; // do something with image
         }
         else{
             [activityIndicator stopAnimating];
             cell.thumbNailImage.image=[UIImage imageNamed:@"a.png"];
         }
     }];
    //    [cell.thumbNailImage setImageWithURL:urlImagePath
    //                        placeholderImage:nil
    //                                 success:^(UIImage *image) {
    //                                     NSLog(@"sucess");
    //                                     //imageInner.image=image;
    //                                     [activityIndicator stopAnimating];
    //                                 }
    //                                 failure:^(NSError *error) {
    //
    //                                     NSLog(@"fail to download image");
    //                                     cell.thumbNailImage.image=[UIImage imageNamed:@"no_image.png"];
    //                                     [activityIndicator stopAnimating];
    //
    //                                 }];
    //
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MatchedUserList *matchedUserList = [self.matchedUserLists objectAtIndex:indexPath.row];
    
    JSDemoViewController *vc = [[JSDemoViewController alloc] initWithNibName:nil bundle:nil];
   // vc.friendFbId = matchedUserList.fId;
    NSLog(@"status:%@",matchedUserList.status);
   // vc.status = matchedUserList.status;
    
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.revealSideViewController popViewControllerWithNewCenterController:n
                                                                   animated:YES];
    [self.revealSideViewController setDelegate:vc];
    PP_RELEASE(vc);
    PP_RELEASE(n);
    
    [self.revealSideViewController.navigationController pushViewController:vc  animated:YES];
}
#pragma mark - WebServiceResponse Delegate
- (void)getServiceResponseDelegate:(NSDictionary *)responseDict serviceType:(int)type error:(NSError *)error
{
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    if (error == nil) {
        
        
        if ([[responseDict objectForKey:@"errFlag"]intValue] == 0) {
            
            NSLog(@"success");
            if (type == 1) {   // matched list response
                
                if( !self.matchedUserLists ){
                    self.matchedUserLists = [[NSMutableArray alloc]init];
                }
                self.matchedUserLists = [[responseDict objectForKey:@"likes"] mutableCopy];
                
                DataBase *insertDatatoDb = [[DataBase alloc]init];
                insertDatatoDb.delegate = self;
                [insertDatatoDb insertMatchedUserList:self.matchedUserLists];
                
                
            }
        }
    }else{
        NSLog(@"error");
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
