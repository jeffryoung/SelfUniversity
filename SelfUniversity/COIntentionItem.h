// =================================================================================================================
//
//  COIntentionItem.h
//  iLearn University
//
//  Created by Jeffrey Young on 9/8/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// =================================================================================================================
#pragma mark - Core Data Definitions
// =================================================================================================================

@interface COIntentionItem : NSManagedObject

@property (nonatomic, retain)   NSString  * intentionItemKey;
@property (nonatomic, retain)   NSString  * intentionItemName;
@property (nonatomic, retain)   NSString  * intentionItemDescription;
@property (nonatomic, retain)   NSDate    * intentionItemDateCreated;
@property (nonatomic)           double      intentionItemOrderingValue;
@property (nonatomic, retain)   NSString  * intentionItemSubType;

// =================================================================================================================
#pragma mark - Object Methods
// =================================================================================================================

+ (instancetype)randomIntentionItem;
- (instancetype)initWithName:(NSString *)intentionItemName
    intentionItemDescription:(NSString *)intentionItemDescription;

@end
