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
@import CoreData;

@interface COIntentionItemStore()
@property (nonatomic) NSMutableArray *privateIntentionItems;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;
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
        // Read in the data model
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        // Identify where the SQLite file should go.
        NSString *path = self.intentionItemsArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure" reason:[error localizedDescription] userInfo:nil];
        }
        
        // Create the managed object context
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        [self loadAllIntentionItems];
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
    double order;
    if ([self.allIntentionItems count] == 0) {
        order = 1.0;
    } else {
        order = [[self.privateIntentionItems lastObject] intentionItemOrderingValue] + 1.0;
    }
    NSLog(@"Adding after %d items, order = %.2f", [self.privateIntentionItems count], order);
    
    COIntentionItem *intentionItem = [NSEntityDescription insertNewObjectForEntityForName:@"COIntentionItem" inManagedObjectContext:self.context];
    intentionItem.intentionItemOrderingValue = order;
    
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
    
    // Compute a new intentionItemOrderingValue for the object that was moved
    double lowerBound = 0.0;
    
    // Is there an object before it in the array?
    if (toIndex > 0) {
        lowerBound = [self.privateIntentionItems[(toIndex - 1)] intentionItemOrderingValue];
    } else {
        lowerBound = [self.privateIntentionItems[1] intentionItemOrderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    // Is there an object after it in the array?
    if (toIndex < [self.privateIntentionItems count] - 1) {
        upperBound = [self.privateIntentionItems[(toIndex + 1)] intentionItemOrderingValue];
    } else {
        upperBound = [self.privateIntentionItems[(toIndex - 1)] intentionItemOrderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    
    NSLog(@"Moving to order %f", newOrderValue);
    intentionItem.intentionItemOrderingValue = newOrderValue;
    
}

// -----------------------------------------------------------------------------------------------------------------

- (void)removeIntentionItem:(COIntentionItem *)intentionItem
{
    [self.context deleteObject:intentionItem];
    [self.privateIntentionItems removeObjectIdenticalTo:intentionItem];
     
}
     
// =================================================================================================================
#pragma mark - Saving intentionItems in the intentionItemStore using CoreData
// =================================================================================================================
     
- (NSString *)intentionItemsArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"intentionItemStore.data"];
}

// -----------------------------------------------------------------------------------------------------------------

- (BOOL)saveChanges
{
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving intention items: %@", [error localizedDescription]);
    }
    return successful;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)loadAllIntentionItems
{
    if (!self.privateIntentionItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"COIntentionItem" inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"intentionItemOrderingValue" ascending:YES];
        request.sortDescriptors = @[sortDescriptor];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateIntentionItems = [[NSMutableArray alloc] initWithArray:result];
    }
}
@end
