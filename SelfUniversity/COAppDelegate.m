// =================================================================================================================
//
//  COAppDelegate.m
//  SelfUniversity
//
//  Created by Jeffrey Young on 6/25/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COAppDelegate.h"
#import "COGlobalDefsConstants.h"
#import "COBookRootViewController.h"
#import "COIntentionViewController.h"
#import "COContentViewController.h"
#import "COLearningGuideViewController.h"
#import "COPracticeViewController.h"
#import "COProjectViewController.h"

NSString * const COIntentionItemsEnabledKey = @"IntentionItemsEnabled";
NSString * const COGoalItemsEnabledKey = @"GoalItemsEnabled";
NSString * const CODrivingQuestionItemsEnabledKey = @"DrivingQuestionItemsEnabled";
NSString * const COProductItemsEnabledKey = @"ProductItemsEnabled";

@implementation COAppDelegate

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
        
        // Create a view controller that will display the book.
        COBookRootViewController *bvc = [[COBookRootViewController alloc] init];
        bvc.m_tabBarController = tabBarController;
        
        // Create a IntentionViewController and make it the rootViewController of a UINavigationController
        COIntentionViewController *vvc = [[COIntentionViewController alloc] init];
        vvc.m_tabBarController = tabBarController;
        
        UINavigationController *vNavController = [[UINavigationController alloc] initWithRootViewController:vvc];
        vNavController.restorationIdentifier = NSStringFromClass([vNavController class]);
        
        // Create a Content ViewController that will display the notebook
        COContentViewController *cvc = [[COContentViewController alloc] init];
        
        // Create a Learning Guide ViewController that will display connections to learning guides
        COLearningGuideViewController *lgvc = [[COLearningGuideViewController alloc] init];
        
        // Create a Practice ViewController that will display the practice log
        COPracticeViewController *pravc = [[COPracticeViewController alloc] init];
        
        // Create a Project ViewController that will display the Project Tracker
        COProjectViewController *provc = [[COProjectViewController alloc] init];
        
        // Place each tab's controllers into the tab bar array.
        tabBarController.viewControllers = @[bvc, vNavController, cvc, lgvc, pravc, provc];
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

@end
