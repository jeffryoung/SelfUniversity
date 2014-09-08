// =================================================================================================================
//
//  COLibraryRootViewController.h
//  iLearn University
//
//  Created by Jeffrey Young on 6/25/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>

@interface COLibraryRootViewController : UIViewController <UIPageViewControllerDelegate, UIViewControllerRestoration>

@property(nonatomic, strong) UIPageViewController *m_pageViewController;
@property (nonatomic, strong) UITabBarController *m_tabBarController;

@end
