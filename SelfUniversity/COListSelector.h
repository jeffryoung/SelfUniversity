// =================================================================================================================
//
//  COListSelector.h
//  iLearn University
//
//  Created by Jeffrey Young on 8/13/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>
#import "COGlobalDefsConstants.h"

// =================================================================================================================
#pragma mark - Protocol Definition
// =================================================================================================================

@protocol COListSelectorDelegate <NSObject>

@required
- (void) indexSelected:(NSInteger)index;

@end

// =================================================================================================================
#pragma mark - Interface Definition
// =================================================================================================================

@interface COListSelector : UITableViewController <UIViewControllerRestoration>

@property (nonatomic) NSInteger m_nIndexSelected;
@property (retain) id m_delegate;
@property (nonatomic, copy) void (^m_dismissBlock)(void);

- (instancetype) initWithList:(NSArray *)listText;

@end
