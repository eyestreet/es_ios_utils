//
//  ESApplicationDelegate.m
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/21/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import "ESApplicationDelegate.h"
#import "ESUtils.h"

@implementation ESApplicationDelegate

@synthesize managedObjectContext, managedObjectModel, persistentStoreCoordinator, window;

-(NSString*)persistantStoreName
{
    [NSException raise:NSInternalInconsistencyException format:@"Your UIApplicationDelegate must implement -(NSString*)persistantStoreName.", NSStringFromSelector(_cmd)];
    return nil;
}

+(ESApplicationDelegate*)delegate
{
    id<UIApplicationDelegate> d = [UIApplication sharedApplication].delegate;
    if([d isKindOfClass:ESApplicationDelegate.class])
        return d;
    [NSException raise:NSInternalInconsistencyException format:@"Your UIApplicationDelegate must extend ESApplicationDelegate to use this method.", NSStringFromSelector(_cmd)];
    return nil;
}

- (void)dealloc
{
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
    [super dealloc];
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
}

#pragma mark - Core Data stack

+(NSManagedObjectContext*)managedObjectContext
{
    return self.delegate.managedObjectContext;
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if(managedObjectContext)
        return managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel)
        return managedObjectModel;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.persistantStoreName withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created. Then we check to see if a default DB
 is bundled with app and, if so, use that if the database doesn't already exist.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator)
        return persistentStoreCoordinator;
    
    NSString *storePath = [[[self applicationDocumentsDirectory] path] stringByAppendingPathComponent:$format(@"%@.sqlite", self.persistantStoreName)];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:storePath]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:$format(@"%@", self.persistantStoreName) ofType:@"sqlite"];
        if (defaultStorePath) {
            [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
        }
    }
    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL 
                                                        options:options error:&error])
    {
        [error log];
        abort(); //FIXME: remove before final product
    }    
    
    return persistentStoreCoordinator;
}

- (void)saveContext
{
    if(managedObjectContext.hasChanges)
    {
        [managedObjectContext saveAndDoOnError:^(NSError *e) {
            [e log];
            abort();
        }];
    }
}

@end