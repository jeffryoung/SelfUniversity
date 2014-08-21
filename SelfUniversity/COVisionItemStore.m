// =================================================================================================================
//
//  COVisionItemStore.m
//  iLearn University
//
//  Created by Jeffrey Young on 8/13/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COVisionItemStore.h"
#import "COVisionItem.h"
//@import CoreData;

@interface COVisionItemStore()
@property (nonatomic) NSMutableArray *privateVisionItems;
//@property (nonatomic, strong) NSManagedObjectContext *context;
//@property (nonatomic, strong) NSManagedObjectModel *model;
@end

@implementation COVisionItemStore

// =================================================================================================================
#pragma mark - Class Methods
// =================================================================================================================

+ (instancetype)sharedVisionItemStore
{
    static COVisionItemStore *sharedVisionItemStore = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedVisionItemStore = [[self alloc] initPrivate];
    });
    return sharedVisionItemStore;
}

// =================================================================================================================
#pragma mark - Initialization Methods
// =================================================================================================================

- (instancetype)init
{
    // If a programmer calls [[COVisionItemStore alloc] init], let him or her know by throwing an exception.
    @throw [NSException exceptionWithName:@"Singleton Object"
                                   reason:@"Use +[COVisionItemStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

// -----------------------------------------------------------------------------------------------------------------
// Secret designated initializer

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _privateVisionItems = [[NSMutableArray alloc] init];
    }
    return self;
}

// =================================================================================================================
#pragma mark - Vision Item Handling Methods
// =================================================================================================================

- (NSArray *)allVisionItems
{
    return self.privateVisionItems;
}

// -----------------------------------------------------------------------------------------------------------------

- (COVisionItem *)createVisionItem
{
    COVisionItem *visionItem = [COVisionItem randomVisionItem];
    [self.privateVisionItems addObject:visionItem];
    
    return visionItem;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)moveVisionItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    COVisionItem *visionItem = self.privateVisionItems[fromIndex];
    
    // Remove the selected item from the store
    [self.privateVisionItems removeObjectAtIndex:fromIndex];
    
    // Insert the item into the array at the new location
    [self.privateVisionItems insertObject:visionItem atIndex:toIndex];
    
}

// -----------------------------------------------------------------------------------------------------------------

- (void)removeVisionItem:(COVisionItem *)visionItem
{
    [self.privateVisionItems removeObjectIdenticalTo:visionItem];
     
}
     
// =================================================================================================================
#pragma mark - Saving visionItems in the visionItemStore using CoreData
// =================================================================================================================
     
- (NSString *)visionItemsArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"visionStore.data"];
}

// -----------------------------------------------------------------------------------------------------------------

- (BOOL)saveChanges
{
    NSError *error;
    BOOL successful = YES; //[self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving vision items: %@", [error localizedDescription]);
    }
    return successful;
}
@end
