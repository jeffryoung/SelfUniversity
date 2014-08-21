// =================================================================================================================
//
//  COVisionItemStore.h
//  iLearn University
//
//  Created by Jeffrey Young on 8/13/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <Foundation/Foundation.h>

@class COVisionItem;

@interface COVisionItemStore : NSObject

// =================================================================================================================
#pragma mark - Properties
// =================================================================================================================

@property (nonatomic, readonly) NSArray *allVisionItems;

// =================================================================================================================
#pragma mark - Methods
// =================================================================================================================

+ (instancetype) sharedVisionItemStore;
- (COVisionItem *) createVisionItem;
- (void) removeVisionItem:(COVisionItem *)visionItem;
- (void) moveVisionItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (BOOL) saveChanges;

@end
