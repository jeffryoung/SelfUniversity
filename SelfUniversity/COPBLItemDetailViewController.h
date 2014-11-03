// =================================================================================================================
//
//  COPBLItemDetailViewController.h
//  iLearn University
//
//  Created by Jeffrey Young on 10/23/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>
#import "COIntentionItemTypeDetailViewController.h"
#import "COPBLItem.h"

@interface COPBLItemDetailViewController : COIntentionItemTypeDetailViewController <COIntentionItemTypeDetailView, UIViewControllerRestoration>

@property (nonatomic, strong) COPBLItem *m_PBLItem;

@end
