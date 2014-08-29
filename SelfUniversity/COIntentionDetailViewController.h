// =================================================================================================================
//
//  COIntentionDetailViewController.h
//  iLearn University
//
//  Created by Jeffrey Young on 8/19/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>

@class COIntentionItem;

@interface COIntentionDetailViewController : UIViewController <UIViewControllerRestoration>

@property (nonatomic, strong) COIntentionItem *m_IntentionItem;
@property (nonatomic, copy) void (^m_DismissBlock)(void);
@property (nonatomic, strong) NSString *m_nIntentionTypeTitle;

- (instancetype) initForNewItem:(BOOL)isNew;

@end
