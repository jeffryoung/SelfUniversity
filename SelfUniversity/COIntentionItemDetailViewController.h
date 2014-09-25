// =================================================================================================================
//
//  COIntentionItemDetailViewController.h
//  iLearn University
//
//  Created by Jeffrey Young on 9/21/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>

@class COIntentionItem;

@interface COIntentionItemDetailViewController : UIViewController <UIViewControllerRestoration>

@property (nonatomic, strong) COIntentionItem *m_IntentionItem;
@property (nonatomic, copy) void (^m_DismissBlock)(void);
@property (nonatomic, strong) NSString *m_nIntentionItemTitle;

- (instancetype) initForNewItem:(BOOL)isNew;

@end
