// =================================================================================================================
//
//  COIntentionItemTypeStore.m
//  iLearn University
//
//  Created by Jeffrey Young on 8/13/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COIntentionItemTypeStore.h"
#import "COIntentionItemType.h"
@import CoreData;

@interface COIntentionItemTypeStore()
@property (nonatomic) NSMutableArray *privateIntentionItemTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;
@end

@implementation COIntentionItemTypeStore

// =================================================================================================================
#pragma mark - Class Methods
// =================================================================================================================

+ (instancetype)sharedIntentionItemTypeStore
{
    static COIntentionItemTypeStore *sharedIntentionItemTypeStore = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedIntentionItemTypeStore = [[self alloc] initPrivate];
    });
    return sharedIntentionItemTypeStore;
}

// =================================================================================================================
#pragma mark - Initialization Methods
// =================================================================================================================

- (instancetype)init
{
    // If a programmer calls [[COIntentionItemTypeStore alloc] init], let him or her know by throwing an exception.
    @throw [NSException exceptionWithName:@"Singleton Object"
                                   reason:@"Use +[COIntentionItemTypeStore sharedStore]"
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
        NSString *path = self.intentionItemTypesArchivePath;
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
        [self loadAllIntentionItemTypes];
    }
    return self;
}

// =================================================================================================================
#pragma mark - Intention Item Handling Methods
// =================================================================================================================

- (NSArray *)allIntentionItemTypes
{
    return self.privateIntentionItemTypes;
}

// -----------------------------------------------------------------------------------------------------------------

- (COIntentionItem *)createIntentionItem
{
    double order;
    if ([self.allIntentionItemTypes count] == 0) {
        order = 1.0;
    } else {
        order = [[self.privateIntentionItemTypes lastObject] intentionItemTypeOrderingValue] + 1.0;
    }
    NSLog(@"Adding after %lu items, order = %.2f", (unsigned long)[self.privateIntentionItemTypes count], order);
    
    COIntentionItem *intentionItem = [NSEntityDescription insertNewObjectForEntityForName:@"COIntentionItem" inManagedObjectContext:self.context];
    intentionItem.intentionItemTypeOrderingValue = order;
    intentionItem.intentionItemTypeSubType = NSLocalizedString(@"Intention Item", @"Intention Item");
    
    [self.privateIntentionItemTypes addObject:intentionItem];
    
    return intentionItem;
}

// -----------------------------------------------------------------------------------------------------------------

- (COGoalItem *)createGoalItem
{
    double order;
    if ([self.allIntentionItemTypes count] == 0) {
        order = 1.0;
    } else {
        order = [[self.privateIntentionItemTypes lastObject] intentionItemTypeOrderingValue] + 1.0;
    }
    NSLog(@"Adding after %lu items, order = %.2f", (unsigned long)[self.privateIntentionItemTypes count], order);
    
    COGoalItem *goalItem = [NSEntityDescription insertNewObjectForEntityForName:@"COGoalItem" inManagedObjectContext:self.context];
    goalItem.intentionItemTypeOrderingValue = order;
    goalItem.intentionItemTypeSubType = NSLocalizedString(@"Goal Item", @"Goal Item");
    
    [self.privateIntentionItemTypes addObject:goalItem];
    
    return goalItem;
}

// -----------------------------------------------------------------------------------------------------------------

/*- (CODrivingQuestionItem *)createDrivingQuestionItem
{
    double order;
    if ([self.allIntentionItemTypes count] == 0) {
        order = 1.0;
    } else {
        order = [[self.privateIntentionItemTypes lastObject] intentionItemTypeOrderingValue] + 1.0;
    }
    NSLog(@"Adding after %lu items, order = %.2f", (unsigned long)[self.privateIntentionItemTypes count], order);
    
    CODrivingQuestionItem *drivingQuestionItem = [NSEntityDescription insertNewObjectForEntityForName:@"CODrivingQuestionItem" inManagedObjectContext:self.context];
    drivingQuestionItem.intentionItemTypeOrderingValue = order;
    drivingQuestionItem.intentionItemTypeSubType = NSLocalizedString(@"Driving Question Item", @"Driving Question Item");
    
    [self.privateIntentionItemTypes addObject:drivingQuestionItem];
    
    return drivingQuestionItem;
}*/

// -----------------------------------------------------------------------------------------------------------------

- (COProductStoryItem *)createProductStoryItem
{
    double order;
    if ([self.allIntentionItemTypes count] == 0) {
        order = 1.0;
    } else {
        order = [[self.privateIntentionItemTypes lastObject] intentionItemTypeOrderingValue] + 1.0;
    }
    NSLog(@"Adding after %lu items, order = %.2f", (unsigned long)[self.privateIntentionItemTypes count], order);
    
    COProductStoryItem *productStoryItem = [NSEntityDescription insertNewObjectForEntityForName:@"COProductStoryItem" inManagedObjectContext:self.context];
    productStoryItem.intentionItemTypeOrderingValue = order;
    productStoryItem.intentionItemTypeSubType = NSLocalizedString(@"Product Story Item", @"Product Story Item");
    
    [self.privateIntentionItemTypes addObject:productStoryItem];
    
    return productStoryItem;
}

// -----------------------------------------------------------------------------------------------------------------

/*- (COSelfEmpowermentItem *)createSelfEmpowermentItem
 {
 double order;
 if ([self.allIntentionItemTypes count] == 0) {
 order = 1.0;
 } else {
 order = [[self.privateIntentionItemTypes lastObject] intentionItemTypeOrderingValue] + 1.0;
 }
 NSLog(@"Adding after %lu items, order = %.2f", (unsigned long)[self.privateIntentionItemTypes count], order);
 
 COSelfEmpowermentItem *selfEmpowermentItem = [NSEntityDescription insertNewObjectForEntityForName:@"COSelfEmpowermentItem" inManagedObjectContext:self.context];
 selfEmpowermentItem.intentionItemTypeOrderingValue = order;
 selfEmpowermentItem.intentionItemTypeSubType = NSLocalizedString(@"Product Item", @"Product Item");
 
 [self.privateIntentionItemTypes addObject:selfEmpowermentItem];
 
 return selfEmpowermentItem;
 }*/

// -----------------------------------------------------------------------------------------------------------------

- (void)moveIntentionItemTypeAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    COIntentionItemType *intentionItemType = self.privateIntentionItemTypes[fromIndex];
    
    // Remove the selected item from the store
    [self.privateIntentionItemTypes removeObjectAtIndex:fromIndex];
    
    // Insert the item into the array at the new location
    [self.privateIntentionItemTypes insertObject:intentionItemType atIndex:toIndex];
    
    // Compute a new intentionItemTypeOrderingValue for the object that was moved
    double lowerBound = 0.0;
    
    // Is there an object before it in the array?
    if (toIndex > 0) {
        lowerBound = [self.privateIntentionItemTypes[(toIndex - 1)] intentionItemTypeOrderingValue];
    } else {
        lowerBound = [self.privateIntentionItemTypes[1] intentionItemTypeOrderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    // Is there an object after it in the array?
    if (toIndex < [self.privateIntentionItemTypes count] - 1) {
        upperBound = [self.privateIntentionItemTypes[(toIndex + 1)] intentionItemTypeOrderingValue];
    } else {
        upperBound = [self.privateIntentionItemTypes[(toIndex - 1)] intentionItemTypeOrderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    
    NSLog(@"Moving to order %f", newOrderValue);
    intentionItemType.intentionItemTypeOrderingValue = newOrderValue;
    
}

// -----------------------------------------------------------------------------------------------------------------

- (void)removeIntentionItemType:(COIntentionItemType *)intentionItemType
{
    [self.context deleteObject:intentionItemType];
    [self.privateIntentionItemTypes removeObjectIdenticalTo:intentionItemType];
     
}
     
// =================================================================================================================
#pragma mark - Saving intentionItems in the intentionItemStore using CoreData
// =================================================================================================================
     
- (NSString *)intentionItemTypesArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"iLearnUniversityDataStore.data"];
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

- (void)loadAllIntentionItemTypes
{
    if (!self.privateIntentionItemTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"COIntentionItemType" inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"intentionItemTypeOrderingValue" ascending:YES];
        request.sortDescriptors = @[sortDescriptor];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateIntentionItemTypes = [[NSMutableArray alloc] initWithArray:result];
    }
}
@end
