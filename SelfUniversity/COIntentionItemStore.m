// =================================================================================================================
//
//  COIntentionItemStore.m
//  iLearn University
//
//  Created by Jeffrey Young on 8/13/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COIntentionItemStore.h"
#import "COIntentionItem.h"
//@import CoreData;

@interface COIntentionItemStore()
@property (nonatomic) NSMutableArray *privateIntentionItems;
//@property (nonatomic, strong) NSManagedObjectContext *context;
//@property (nonatomic, strong) NSManagedObjectModel *model;
@end

@implementation COIntentionItemStore

// =================================================================================================================
#pragma mark - Class Methods
// =================================================================================================================

+ (instancetype)sharedIntentionItemStore
{
    static COIntentionItemStore *sharedIntentionItemStore = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedIntentionItemStore = [[self alloc] initPrivate];
    });
    return sharedIntentionItemStore;
}

// =================================================================================================================
#pragma mark - Initialization Methods
// =================================================================================================================

- (instancetype)init
{
    // If a programmer calls [[COIntentionItemStore alloc] init], let him or her know by throwing an exception.
    @throw [NSException exceptionWithName:@"Singleton Object"
                                   reason:@"Use +[COIntentionItemStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

// -----------------------------------------------------------------------------------------------------------------
// Secret designated initializer

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _privateIntentionItems = [[NSMutableArray alloc] init];
    }
    return self;
}

// =================================================================================================================
#pragma mark - Intention Item Handling Methods
// =================================================================================================================

- (NSArray *)allIntentionItems
{
    return self.privateIntentionItems;
}

// -----------------------------------------------------------------------------------------------------------------

- (COIntentionItem *)createIntentionItem
{
    COIntentionItem *intentionItem = [COIntentionItem randomIntentionItem];
    [self.privateIntentionItems addObject:intentionItem];
    
    return intentionItem;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)moveIntentionItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    COIntentionItem *intentionItem = self.privateIntentionItems[fromIndex];
    
    // Remove the selected item from the store
    [self.privateIntentionItems removeObjectAtIndex:fromIndex];
    
    // Insert the item into the array at the new location
    [self.privateIntentionItems insertObject:intentionItem atIndex:toIndex];
    
}

// -----------------------------------------------------------------------------------------------------------------

- (void)removeIntentionItem:(COIntentionItem *)intentionItem
{
    [self.privateIntentionItems removeObjectIdenticalTo:intentionItem];
     
}
     
// =================================================================================================================
#pragma mark - Saving intentionItems in the intentionItemStore using CoreData
// =================================================================================================================
     
- (NSString *)intentionItemsArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"intentionStore.data"];
}

// -----------------------------------------------------------------------------------------------------------------

- (BOOL)saveChanges
{
    NSError *error;
    BOOL successful = YES; //[self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving intention items: %@", [error localizedDescription]);
    }
    return successful;
}
@end
