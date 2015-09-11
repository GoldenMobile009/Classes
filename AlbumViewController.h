//
//  AlbumViewController.h
//  FriendPickerSample
//
//  Created by Surender Rathore on 07/12/13.
//
//

#import <UIKit/UIKit.h>

@interface AlbumViewController : UITableViewController
@property(nonatomic,strong) NSArray *albumArray;
@property(nonatomic,strong) NSArray *albumCoverPicsArray;
@property(nonatomic,strong)id target;
@property(nonatomic)SEL selector;
@end
