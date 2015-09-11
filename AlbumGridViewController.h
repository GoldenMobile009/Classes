//
//  AlbumGridViewController.h
//  FriendPickerSample
//
//  Created by Surender Rathore on 08/12/13.
//
//

#import <UIKit/UIKit.h>

@interface AlbumGridViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)NSString *albumId;
@property(nonatomic,strong)id target;
@property(nonatomic)SEL selector;
@end
