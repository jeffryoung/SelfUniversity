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
#import "COLibraryRootViewController.h"
#import "COIntentionViewController.h"
#import "COIntentionItemStore.h"
#import "COContentViewController.h"
#import "COLearningGuideViewController.h"
#import "COPracticeViewController.h"
#import "COProjectViewController.h"

NSString * const COIntentionItemsEnabledKey = @"IntentionItemsEnabled";
NSString * const COGoalItemsEnabledKey = @"GoalItemsEnabled";
NSString * const CODrivingQuestionItemsEnabledKey = @"DrivingQuestionItemsEnabled";
NSString * const COProductItemsEnabledKey = @"ProductItemsEnabled";

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
                                      CODrivingQuestionItemsEnabledKey: @YES,
                                      COProductItemsEnabledKey: @YES};
    [defaults registerDefaults:factorySettings];
}

// -----------------------------------------------------------------------------------------------------------------

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (!self.window.rootViewController) {
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        self.window.rootViewController = tabBarController;
        
        // Create a IntentionViewController and make it the rootViewController of a UINavigationController
        COIntentionViewController *ivc = [[COIntentionViewController alloc] init];
        ivc.m_tabBarController = tabBarController;
        
        UINavigationController *iNavController = [[UINavigationController alloc] initWithRootViewController:ivc];
        iNavController.restorationIdentifier = NSStringFromClass([iNavController class]);
        
        // Create a view controller that will display the library.
        COLibraryRootViewController *bvc = [[COLibraryRootViewController alloc] init];
        bvc.m_tabBarController = tabBarController;
        
        // Create a Content ViewController that will display the notebook
        COContentViewController *cvc = [[COContentViewController alloc] init];
        
        // Create a Learning Guide ViewController that will display connections to learning guides
        COLearningGuideViewController *lgvc = [[COLearningGuideViewController alloc] init];
        
        // Create a Practice ViewController that will display the practice log
        COPracticeViewController *pravc = [[COPracticeViewController alloc] init];
        
        // Create a Project ViewController that will display the Project Tracker
        COProjectViewController *provc = [[COProjectViewController alloc] init];
        
        // Place each tab's controllers into the tab bar array.
        tabBarController.viewControllers = @[iNavController, bvc, cvc, lgvc, pravc, provc];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

// -----------------------------------------------------------------------------------------------------------------

- (BOOL) application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    return YES;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    BOOL success = [[COIntentionItemStore sharedIntentionItemStore] saveChanges];
    if (success) {
        NSLog(@"Saved all the intention items.");
    } else {
        NSLog(@"Could not save any of the intention items.");
    }
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
    return YES;
}

// -----------------------------------------------------------------------------------------------------------------

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    // Create a new navigation controller
    UIViewController *vc = [[UINavigationController alloc] init];
    
    // The last object in the path array is the restoration identifier for this view controller
    vc.restorationIdentifier = [identifierComponents lastObject];
    
    // If there is only 1 identifier component, then this is the root view controller
    if ([identifierComponents count] == 1) {
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
    if (![_appPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _appPersistentStoreCoordinator;
}
@end
