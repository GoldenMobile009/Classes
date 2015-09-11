//
//  MatchedViewController.h
//  Tinder
//
//  Created by Rahul Sharma on 07/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceHandler.h"
#import "DataBase.h"
#import "PPRevealSideViewController.h"
@interface MatchedViewController : UIViewController<sendMessageDelegate,DataInsertedSuccessfullyDelegate,PPRevealSideViewControllerDelegate>
{
    
}
@property (strong , nonatomic) IBOutlet UITableView *tblView;
@property (strong , nonatomic) NSMutableArray *matchedUserLists;

@end
