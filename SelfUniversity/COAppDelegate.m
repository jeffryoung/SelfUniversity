// =================================================================================================================
//
//  COAppDelegate.m
//  iLearn University
//
//  Created by Jeffrey Young on 6/25/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COAppDelegate.h"
#import "COGlobalDefsConstants.h"
#import "COIntentionItemTypeStore.h"

#import "COIntentionItemTypeViewController.h"
#import "COLibraryRootViewController.h"
#import "COContentViewController.h"
#import "COLearningGuideViewController.h"
#import "COPracticeViewController.h"
#import "COTaskViewController.h"

NSString * const COIntentionItemsEnabledKey = @"IntentionItemsEnabled";
NSString * const COGoalItemsEnabledKey = @"GoalItemsEnabled";
NSString * const COProjectBasedLearningItemsEnabledKey = @"ProjectBasedLearningItemsEnabled";
NSString * const COProductStoryItemsEnabledKey = @"ProductStoryItemsEnabled";
NSString * const COSelfEmpowermentItemsEnabledKey = @"SelfEmpowermentItemsEnabled";

BOOL m_bAppIsBeingRestored = NO;

@implementation COAppDelegate

@synthesize appManagedObjectContext = _appManagedObjectContext;
@synthesize appManagedObjectModel = _appManagedObjectModel;
@synthesize appPersistentStoreCoordinator = _appPersistentStoreCoordinator;

// =================================================================================================================
#pragma mark - Initialization
// =================================================================================================================

+ (void) initialize
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *factorySettings = @{COIntentionItemsEnabledKey: @YES,
                                      COGoalItemsEnabledKey: @YES,
                                      COProjectBasedLearningItemsEnabledKey: @YES,
                                      COProductStoryItemsEnabledKey: @YES,
                                      COSelfEmpowermentItemsEnabledKey: @YES};
    [defaults registerDefaults:factorySettings];
}

// -----------------------------------------------------------------------------------------------------------------

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (!m_bAppIsBeingRestored) {
        self.window.rootViewController = [self createTabBarControllerStructure];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

// -----------------------------------------------------------------------------------------------------------------

- (BOOL) application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.opaque = NO;
    self.window.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3];

    return YES;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    BOOL success = [[COIntentionItemTypeStore sharedIntentionItemTypeStore] saveChanges];
    if (success) {
        NSLog(@"Saved all the intention items.");
    } else {
        NSLog(@"Could not save any of the intention items.");
    }
}

// -----------------------------------------------------------------------------------------------------------------

- (UIViewController *) createTabBarControllerStructure
{
    // Create a IntentionItemTypeViewController and make it the rootViewController of a UINavigationController
    COIntentionItemTypeViewController *ivc = [[COIntentionItemTypeViewController alloc] init];
    
    UINavigationController *iNavController = [[UINavigationController alloc] initWithRootViewController:ivc];
    iNavController.restorationIdentifier = NSStringFromClass([iNavController class]);
    
    // Create a view controller that will display the library.
    COLibraryRootViewController *lrvc = [[COLibraryRootViewController alloc] init];
    
    // Create a Content ViewController that will display the notebook
    COContentViewController *cvc = [[COContentViewController alloc] init];
    
    // Create a Learning Guide ViewController that will display connections to learning guides
    COLearningGuideViewController *lgvc = [[COLearningGuideViewController alloc] init];
    
    // Create a Practice ViewController that will display the practice log
    COPracticeViewController *pravc = [[COPracticeViewController alloc] init];
    
    // Create a Task ViewController that will display the Task Tracker
    COTaskViewController *taskvc = [[COTaskViewController alloc] init];
    
    // Create the UITabBarController to hold all these view controllers and set its restorationIdentifier
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.restorationIdentifier = NSStringFromClass([tabBarController class]);
    
    // Put a pointer to the tabBarController in the appropriate view controllers for easy access.
    ivc.m_tabBarController = tabBarController;
    lrvc.m_tabBarController = tabBarController;
    
    // Place each tab's controllers into the tab bar array.
    tabBarController.viewControllers = @[iNavController, lrvc, cvc, lgvc, pravc, taskvc];
    
    return tabBarController;
}

// =================================================================================================================
#pragma mark - State Restoration Methods
// =================================================================================================================

- (BOOL) application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

// -----------------------------------------------------------------------------------------------------------------

- (BOOL) application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    m_bAppIsBeingRestored = YES;
    
    return YES;
}

// -----------------------------------------------------------------------------------------------------------------

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    UIViewController *vc = nil;
    
    // If there is only 1 identifier component, then this is the main UITabBarController
    NSUInteger numberOfIdentifierComponents = [identifierComponents count];
    
    // If there is one identifierComponents, then it is the tabBarController that is being restored.  Create it and make it the rootViewController for the window.
    if (numberOfIdentifierComponents == 1) {
        vc = [self createTabBarControllerStructure];
        self.window.rootViewController = vc;
    }
    return vc;
}

// =================================================================================================================
#pragma mark - Core Data Methods
// =================================================================================================================

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.appManagedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

// -----------------------------------------------------------------------------------------------------------------

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// =================================================================================================================
#pragma mark - Core Data Stack
// =================================================================================================================

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (self.appManagedObjectContext != nil) {
        return self.appManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self appPersistentStoreCoordinator];
    if (coordinator != nil) {
        _appManagedObjectContext = [[NSManagedObjectContext alloc] init];
        [_appManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _appManagedObjectContext;
}

// -----------------------------------------------------------------------------------------------------------------

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_appManagedObjectModel != nil) {
        return _appManagedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iLearnUniversity" withExtension:@"momd"];
    _appManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _appManagedObjectModel;
}

// -----------------------------------------------------------------------------------------------------------------

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_appPersistentStoreCoordinator != nil) {
        return _appPersistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iLearnUniversity.sqlite"];
    
    NSError *error = nil;
    _appPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                                                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![_appPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error]) {
        NSLog(@"Unresolved persistent store error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _appPersistentStoreCoordinator;
}
@end
