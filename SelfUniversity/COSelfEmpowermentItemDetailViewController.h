// =================================================================================================================
//
//  COSelfEmpowermentItemDetailViewController.h
//  iLearn University
//
//  Created by Jeffrey Young on 11/3/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>
#import "COIntentionItemTypeDetailViewController.h"
#import "COSelfEmpowermentItem.h"

@interface COSelfEmpowermentItemDetailViewController : COIntentionItemTypeDetailViewController <COIntentionItemTypeDetailView, UIViewControllerRestoration>

@property (nonatomic, strong) COSelfEmpowermentItem *m_SelfEmpowermentItem;

@end
