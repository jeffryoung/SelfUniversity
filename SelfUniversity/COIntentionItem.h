// =================================================================================================================
//
//  COIntentionItem.h
//  iLearn University
//
//  Created by Jeffrey Young on 8/13/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <Foundation/Foundation.h>
//#import <CoreData/CoreData.h>

@interface COIntentionItem : NSObject //NSManagedObject

// =================================================================================================================
#pragma mark - Object Properties
// =================================================================================================================

@property (nonatomic, retain) NSString *m_IntentionItemName;
@property (nonatomic, retain) NSString *m_IntentionItemDescription;
@property (nonatomic, retain) NSDate *m_DateCreated;

// =================================================================================================================
#pragma mark - Object Methods
// =================================================================================================================

+ (instancetype)randomIntentionItem;
- (instancetype)initWithName:(NSString *)intentionItemName
       intentionItemDescription:(NSString *)intentionItemDescription;

@end
