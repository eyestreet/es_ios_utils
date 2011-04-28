//
//  ESFetchedTableViewController.h
//  es_ios_utils
//
//  Created by Peter DeWeese on 4/8/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//
//  Implemented with one section.
//

#import <Foundation/Foundation.h>

@interface ESFetchedTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    NSManagedObjectContext     *managedObjectContext;
}

@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain) NSManagedObjectContext     *managedObjectContext;

//Configure these:
@property(nonatomic, retain) NSString *entityName;
@property(copy) void(^doOnError)(NSError*); //defaults to log and abort
@property(nonatomic, readonly) NSArray  *sortDescriptors;
@property(nonatomic, readonly) UITableViewCellStyle useCellStyle; //defaults to normal

-(UITableViewCell*)createCell; //defaults to creating a cell with useCellStyle
-(void)configureFetchRequest:(NSFetchRequest*)fetchRequest; //optional
- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end
