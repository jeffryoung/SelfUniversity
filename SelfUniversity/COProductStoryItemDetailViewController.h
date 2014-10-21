// =================================================================================================================
//
//  COProductStoryItemDetailViewController.h
//  iLearn University
//
//  Created by Jeffrey Young on 10/20/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>
#import "COIntentionItemTypeDetailViewController.h"
#import "COProductStoryItem.h"

@interface COProductStoryItemDetailViewController : COIntentionItemTypeDetailViewController <COIntentionItemTypeDetailView, UIViewControllerRestoration>

@property (nonatomic, strong) COProductStoryItem *m_ProductStoryItem;

@end
