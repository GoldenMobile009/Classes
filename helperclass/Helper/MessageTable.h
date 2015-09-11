//
//  MessageTable.h
//  Tinder
//
//  Created by Rahul Sharma on 09/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MessageTable : NSManagedObject

@property (nonatomic, retain) NSNumber * date;
@property (nonatomic, retain) NSString * fId;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * messageDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uniqueId;
@property (nonatomic, retain) NSNumber * senderId;
@property (nonatomic, retain) NSNumber * receiverId;

@end
