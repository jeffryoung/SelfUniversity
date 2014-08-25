// =================================================================================================================
//
//  COIntentionItemStore.h
//  iLearn University
//
//  Created by Jeffrey Young on 8/13/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <Foundation/Foundation.h>

@class COIntentionItem;

@interface COIntentionItemStore : NSObject

// =================================================================================================================
#pragma mark - Properties
// =================================================================================================================

@property (nonatomic, readonly) NSArray *allIntentionItems;

// =================================================================================================================
#pragma mark - Methods
// =================================================================================================================

+ (instancetype) sharedIntentionItemStore;
- (COIntentionItem *) createIntentionItem;
- (void) removeIntentionItem:(COIntentionItem *)intentionItem;
- (void) moveIntentionItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (BOOL) saveChanges;

@end
