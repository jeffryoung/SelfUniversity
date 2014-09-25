// =================================================================================================================
//
//  COIntentionItemTypeStore.h
//  iLearn University
//
//  Created by Jeffrey Young on 8/13/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <Foundation/Foundation.h>
#import "COIntentionItem.h"
#import "COGoalItem.h"

@interface COIntentionItemTypeStore : NSObject

// =================================================================================================================
#pragma mark - Properties
// =================================================================================================================

@property (nonatomic, readonly) NSArray *allIntentionItemTypes;

// =================================================================================================================
#pragma mark - Methods
// =================================================================================================================

+ (instancetype) sharedIntentionItemTypeStore;
- (COIntentionItem *) createIntentionItem;
- (COGoalItem *) createGoalItem;
//- (CODrivingQuestionItem *) createDrivingQuestionItem;
//- (COProductItem *) createProductItem;
- (void) removeIntentionItemType:(COIntentionItemType *)intentionItemType;
- (void) moveIntentionItemTypeAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (BOOL) saveChanges;

@end
