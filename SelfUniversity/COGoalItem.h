// =================================================================================================================
//
//  COGoalItem.h
//  iLearn University
//
//  Created by Jeffrey Young on 9/11/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>
#import "COIntentionItemType.h"

@interface COGoalItem : COIntentionItemType

@property (nonatomic, retain)   NSString  * goalItemReward;
@property (nonatomic, retain)   NSDate    * goalItemTargetDate;

@end
