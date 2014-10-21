// =================================================================================================================
//
//  COProductStoryItem.h
//  iLearn University
//
//  Created by Jeffrey Young on 10/20/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>
#import "COIntentionItemType.h"

@interface COProductStoryItem : COIntentionItemType

@property (nonatomic, strong)   NSString  * productStoryItemUserRole;
@property (nonatomic, strong)   NSString  * productStoryItemGoal;
@property (nonatomic, strong)   NSString  * productStoryItemBenefit;
@property (nonatomic, strong)   NSString  * productStoryItemSize;
@property (nonatomic, strong)   NSString  * productStoryItemParent;
@property (nonatomic, strong)   NSString  * productStoryItemConditionsOfSatisfaction1;
@property (nonatomic, strong)   NSString  * productStoryItemConditionsOfSatisfaction2;
@property (nonatomic, strong)   NSString  * productStoryItemConditionsOfSatisfaction3;
@property (nonatomic, strong)   NSString  * productStoryItemConditionsOfSatisfaction4;
@property (nonatomic, strong)   NSString  * productStoryItemConditionsOfSatisfaction5;

@end
