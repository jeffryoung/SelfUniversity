// =================================================================================================================
//
//  COVisionViewController.h
//  SelfUniversity
//
//  Created by Jeffrey Young on 6/25/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>
#import "COGlobalDefsConstants.h"
#import "COVisionTypeSelectorTableViewController.h"

@interface COVisionViewController : UITableViewController <COVisionTypeSelectorDelegate>

@property (nonatomic, strong) UITabBarController *m_tabBarController;
@property (nonatomic) NSInteger m_nVisionTypeSelected;

@end
