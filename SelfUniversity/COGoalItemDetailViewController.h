// =================================================================================================================
//
//  COGoalItemDetailViewController.h
//  iLearn University
//
//  Created by Jeffrey Young on 9/21/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>

@class COGoalItem;

@interface COGoalItemDetailViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIViewControllerRestoration>

@property (nonatomic, strong) COGoalItem *m_GoalItem;
@property (nonatomic, copy) void (^m_DismissBlock)(void);
@property (nonatomic, strong) NSString *m_tGoalTitle;

- (instancetype) initForNewItem:(BOOL)isNew;

@end
