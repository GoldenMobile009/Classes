//
//  AlbumGridViewController.m
//  FriendPickerSample
//
//  Created by Surender Rathore on 08/12/13.
//
//

#import "AlbumGridViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "GKImageCropViewController.h"
#import "EditProfileViewController.h"
#import "SDWebImageDownloader.h"
#import "UIImageView+WebCache.h"

@interface AlbumGridViewController () <GKImageCropControllerDelegate>{
    NSString * strTitle;
}
@property(nonatomic,retain)IBOutlet UICollectionView *collectionViewPack;
@property(nonatomic,strong)NSArray *albumImages;
@property(nonatomic,strong)NSString * strTitle;
@end

@implementation AlbumGridViewController
@synthesize collectionViewPack;
@synthesize albumId;
@synthesize albumImages;
@synthesize target;
@synthesize strTitle;

static NSString * const kCellReuseIdentifier = @"collectionViewCell";

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
    //Create collection View
    [self.collectionViewPack registerNib:[UINib nibWithNibName:@"CollectionViewItem" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifier];
    self.collectionViewPack.backgroundColor = [UIColor clearColor];
    
     self.title = strTitle;
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(75, 75)];
    flowLayout.minimumInteritemSpacing = 2;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionViewPack setCollectionViewLayout:flowLayout];
    [self.collectionViewPack setAllowsSelection:YES];
    self.collectionViewPack.delegate=self;
    
    [self checkFacebookSession];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
   
}
-(void)checkFacebookSession {
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
                                              //[self pickFriendsButtonClick:sender];
                                              [self getAlbumImages];
                                              //                [self getAlbumImages];
                                          }
                                      }];
        
    }
    else {
        NSLog(@"opened");
        [self getAlbumImages];
    }

}
//-(void)viewDidAppear:(BOOL)animated {
//    
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return _totalImagesData.count;
    return self.albumImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    imageView.clipsToBounds = YES;
    
    
    NSDictionary *dict = albumImages[indexPath.item];
    
    [imageView setImageWithURL:[NSURL URLWithString:dict[@"src_small"]]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

    return cell;
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // printf("Selected View index=%d",indexPath.row);
    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Please wait.."];
    
    NSDictionary *dict = albumImages[indexPath.item];
    
    NSURL *imageURL = [NSURL URLWithString:dict[@"src_big"]];
    
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:imageURL
                                                        options:0
                                                       progress:^(NSUInteger receivedSize, long long expectedSize)
                                                        {
                                                                // progression tracking code
                                                        }
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                                                            {
                                                                    if (image && finished)
                                                                    {
                                                                        [pi hideProgressIndicator];
                                                                        GKImageCropViewController *cropController = [[GKImageCropViewController alloc] init];
                                                                        //cropController.contentSizeForViewInPopover = picker.contentSizeForViewInPopover;
                                                                        cropController.sourceImage = image;
                                                                        cropController.resizeableCropArea = NO;
                                                                        cropController.cropSize = CGSizeMake(320, 320);;
                                                                        cropController.delegate = self;
                                                                        [self.navigationController pushViewController:cropController animated:YES];

                                                                    }
                                                            }];
    
}

-(void)getAlbumImages {
    
    
    NSString *query = [NSString stringWithFormat:@"SELECT src_small, src_big ,object_id FROM photo WHERE  aid = '%@'",self.albumId];
    
    NSLog(@"query %@",query);
    
    // Set up the query parameter
    NSDictionary *queryParam = [NSDictionary dictionaryWithObjectsAndKeys:query, @"q", nil];
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (error) {
                                  
                                  NSLog(@"erro %@",[error localizedDescription]);
                                  
                              } else {
                                  
                                  NSLog(@"result %@",result);
                                  //[self parseAlbums:result];
                                  self.albumImages = [[NSArray alloc] initWithArray:result[@"data"]];
                                  [self.collectionViewPack reloadData];
                                  
                              }
                          }];
}


#pragma mark -
#pragma GKImagePickerDelegate

- (void)imageCropController:(GKImageCropViewController *)imageCropController didFinishWithCroppedImage:(UIImage *)croppedImage{
    
    
    NSLog(@"cropped imge size height  %f : widtth %f",croppedImage.size.height,croppedImage.size.width);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [target performSelectorOnMainThread:self.selector withObject:croppedImage waitUntilDone:NO];
    //[EditProfileViewController croppedFacebookImage:croppedImage];
    
}
@end
