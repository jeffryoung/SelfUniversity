//
//  COAppDelegate.h
//  iLearn University
//
//  Created by Jeffrey Young on 6/25/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *appManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *appManagedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *appPersistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
