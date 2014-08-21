// =================================================================================================================
//
//  COVisionTypeSelectorTableViewController.h
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

#define kNoVisionTypeSelectionMade    -1

typedef enum : NSUInteger {
    kVisionItem,
    kGoalItem,
    kDrivingQuestionItem,
} tVisionType;

// =================================================================================================================
#pragma mark - Protocol Definition
// =================================================================================================================

@protocol COVisionTypeSelectorDelegate <NSObject>

@required
- (void) visionTypeSelected:(NSInteger)visionType;

@end

// =================================================================================================================
#pragma mark - Interface Definition
// =================================================================================================================

@interface COVisionTypeSelectorTableViewController : UITableViewController

@property (nonatomic) NSInteger m_nSelectedType;
@property (retain) id m_delegate;
@property (nonatomic, copy) void (^m_dismissBlock)(void);


@end
