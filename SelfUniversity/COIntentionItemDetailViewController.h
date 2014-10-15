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
#import "COIntentionItemTypeDetailViewController.h"
#import "COIntentionItem.h"

@interface COIntentionItemDetailViewController : COIntentionItemTypeDetailViewController <COIntentionItemTypeDetailView, UIViewControllerRestoration>

@property (nonatomic, strong) COIntentionItem *m_IntentionItem;

@end
