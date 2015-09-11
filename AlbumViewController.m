//
//  AlbumViewController.m
//  FriendPickerSample
//
//  Created by Surender Rathore on 07/12/13.
//
//

#import "AlbumViewController.h"
#import "UIImageView+WebCache.h"
#import "AlbumGridViewController.m"
#import "AlbumCell.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController
@synthesize albumArray;
@synthesize albumCoverPicsArray;
@synthesize target;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Albums";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self addrightButton:self.navigationItem];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonClicked:)];
}

-(void)addrightButton:(UINavigationItem*)naviItem
{
    // UIImage *imgButton = [UIImage imageNamed:@"chat_icon_off_line.png"];
	UIButton *rightbarbutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[rightbarbutton setFrame:CGRectMake(0, 0,60, 25)];
    [rightbarbutton setTitle:@"Cancel" forState:UIControlStateNormal];
    [rightbarbutton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    naviItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbarbutton];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return albumArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AlbumCell *cell = (AlbumCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    NSDictionary *dictAlbums = albumArray[indexPath.row];
    cell.albumName.text = dictAlbums[@"name"];
    cell.albumPhotosCount.text = [NSString stringWithFormat:@"Photos %@",dictAlbums[@"photo_count"]];
    cell.albumCoverImage.layer.borderWidth=0.8;
    CALayer *cellImageLayer = cell.albumCoverImage.layer;
    [cellImageLayer setCornerRadius:5];
    [cellImageLayer setMasksToBounds:YES];
    cell.albumCoverImage.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    
    UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(58/2-20/2, 58/2-20/2, 20, 20)];
    [cell.imageView addSubview:activityIndicator];
    // activityIndicator.backgroundColor=[UIColor greenColor];
    activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [activityIndicator startAnimating];
    
        
        
        
    
    if (albumCoverPicsArray.count > indexPath.row) {
        NSDictionary *dictCoverPics = albumCoverPicsArray[indexPath.row];
        
        
        [cell.albumCoverImage setImageWithURL:[NSURL URLWithString:dictCoverPics[@"src_small"]]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                        
                                        [activityIndicator stopAnimating];
                                    }];

    }
   
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath   *)indexPath
{
    return 71;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dictAlbums = albumArray[indexPath.row];
    // Navigation logic may go here, for example:
    // Create the next view controller.
    AlbumGridViewController *aGVC;
    if (IS_IPHONE_5) {
        
       aGVC = [[AlbumGridViewController alloc] initWithNibName:@"AlbumGridViewController" bundle:nil];

            }
    else{
       aGVC = [[AlbumGridViewController alloc] initWithNibName:@"AlbumGridViewController_ip4" bundle:nil];
 
    }
   
    
    aGVC.albumId = dictAlbums[@"aid"];
    aGVC.target = self.target;
    aGVC.selector = self.selector;
    aGVC.strTitle =dictAlbums[@"name"];
    ;    // Push the view controller.
    [self.navigationController pushViewController:aGVC animated:YES];
}
 


@end
