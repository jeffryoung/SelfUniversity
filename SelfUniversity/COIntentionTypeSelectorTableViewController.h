// =================================================================================================================
//
//  COIntentionTypeSelectorTableViewController.h
//  iLearn University
//
//  Created by Jeffrey Young on 8/13/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>

// =================================================================================================================
#pragma mark - Constant Definitions
// =================================================================================================================

#define kNoIntentionTypeSelectionMade    -1

typedef enum : NSUInteger {
    kIntentionItem,
    kGoalItem,
    kDrivingQuestionItem,
} tIntentionType;

// =================================================================================================================
#pragma mark - Protocol Definition
// =================================================================================================================

@protocol COIntentionTypeSelectorDelegate <NSObject>

@required
- (void) intentionTypeSelected:(NSInteger)intentionType;

@end

// =================================================================================================================
#pragma mark - Interface Definition
// =================================================================================================================

@interface COIntentionTypeSelectorTableViewController : UITableViewController

@property (nonatomic) NSInteger m_nSelectedType;
@property (retain) id m_delegate;
@property (nonatomic, copy) void (^m_dismissBlock)(void);


@end
