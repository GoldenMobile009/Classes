//
//  DBHandler.m
//  PrankCall
//
//  Created by Sahil Khanna on 10/20/12.
//  Copyright 2012 3Embed Software Technologies. All rights reserved.
//

#import "DBHandler.h"
#import "TinderAppDelegate.h"
//#import "MessageTable.h"
@implementation DBHandler


+ (NSManagedObjectContext *)context {
    TinderAppDelegate *appDelegate = (TinderAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
    return context;
}


+ (NSArray *)dataFromTable:(NSString *)table condition:(NSString *)condition orderBy:(NSString *)column ascending:(BOOL)asc {
	TinderAppDelegate *appDelegate = (TinderAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:table inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	if (condition) {
        NSLog(@" condition-->%@",condition);
		NSPredicate *predicate = [NSPredicate predicateWithFormat:condition];
		[fetchRequest setPredicate:predicate];
	}
	
	if (column) {
		NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:column ascending:asc];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	}
	
	NSError *error = nil;
	NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
	
	
	if (error) {
		//NSLog(@"Core Data: %@", [error description]);
	}
	
	return result;
}



@end
