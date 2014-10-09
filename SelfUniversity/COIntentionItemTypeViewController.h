// =================================================================================================================
//
//  COIntentionItemTypeViewController.h
//  iLearn University
//
//  Created by Jeffrey Young on 6/25/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>
#import "COGlobalDefsConstants.h"
#import "COListSelectorViewController.h"

@interface COIntentionItemTypeViewController : UITableViewController <COListSelectorDelegate, UIViewControllerRestoration>

@property (nonatomic, strong) UITabBarController *m_tabBarController;
@property (nonatomic) NSInteger m_nIntentionItemTypeSelected;

- (void)registerToPresentDetailViewControllerModally:(UIViewController *)detailViewController;

@end
