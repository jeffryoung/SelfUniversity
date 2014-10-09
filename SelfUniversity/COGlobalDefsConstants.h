// =================================================================================================================
//
//  iDGlobalDefsConstants.h
//  iLearningJourney
//
//  Created by Jeffrey Young on 6/20/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#ifndef iLearningJourney_iDGlobalDefsConstants_h
#define iLearningJourney_iDGlobalDefsConstants_h

// =================================================================================================================
#pragma mark - Constant Definitions
// =================================================================================================================

#define kNoSelectionMade    -1

typedef enum : NSUInteger {
    kIntentionItem,
    kGoalItem,
    kDrivingQuestionItem,
    kProductItem
} tIntentionType;

typedef enum : NSUInteger {
    kCOIntentionItemTypeViewControllerPosition,
    kCOLibraryRootViewControllerPosition,
    kCOContentViewControllerPosition,
    kCOLearningGuideViewControllerPosition,
    kCOPracticeViewControllerPosition,
    kCOTaskViewControllerPosition
} tTabBarPositionType;


// =================================================================================================================
#pragma mark - Global Settings Definitions
// =================================================================================================================

extern NSString * const COIntentionItemsEnabledKey;
extern NSString * const COGoalItemsEnabledKey;
extern NSString * const CODrivingQuestionItemsEnabledKey;
extern NSString * const COProductItemsEnabledKey;

#endif
