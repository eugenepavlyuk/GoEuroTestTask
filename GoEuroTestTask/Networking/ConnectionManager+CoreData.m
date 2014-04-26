//
//  ConnectionManager+CoreData.m
//  GoEuroTestTask
//
//  Created by Eugene Pavluk on 3/6/14.
//  Copyright (c) 2014 Eugene Pavlyuk. All rights reserved.
//

#import "ConnectionManager+CoreData.h"
#import "NSManagedObjectContext+RestKit.h"
#import <RestKit/Network/RKObjectManager.h>
#import <RestKit/CoreData/RKManagedObjectStore.h>
#import <RestKit/Support/RKPathUtilities.h>
#import <MagicalRecord/NSPersistentStoreCoordinator+MagicalRecord.h>

@implementation ConnectionManager (CoreData)

- (void)setupCoreData
{
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"database" ofType:@"momd"]];
    
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel
                                                  alloc] initWithContentsOfURL:modelURL] mutableCopy];
    
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"database.sqlite"];
    
    NSError *error = nil;
    
    [managedObjectStore addSQLitePersistentStoreAtPath:storePath
                                fromSeedDatabaseAtPath:nil
                                     withConfiguration:nil
                                               options:nil
                                                 error:&error];
    
    [managedObjectStore createManagedObjectContexts];
    
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:managedObjectStore.persistentStoreCoordinator];
    [NSManagedObjectContext MR_setRootSavingContext:managedObjectStore.persistentStoreManagedObjectContext];
    [NSManagedObjectContext MR_setDefaultContext:managedObjectStore.mainQueueManagedObjectContext];
    
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    manager.managedObjectStore = managedObjectStore;
}

@end
