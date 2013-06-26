//
//  MHStorage.h
//  MissionHub
//
//  Created by Michael Harrison on 6/18/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHStorage : NSObject {
	
	NSManagedObjectContext			*_managedObjectContext;
	NSManagedObjectModel			*_managedObjectModel;
	NSPersistentStoreCoordinator	*_persistentStoreCoordinator;
	
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (MHStorage *)sharedInstance;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
