// =================================================================================================================
//
//  COIntentionItemType.h
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

@interface COIntentionItemType : NSManagedObject

@property (nonatomic, retain)   NSString  * intentionItemTypeKey;
@property (nonatomic, retain)   NSString  * intentionItemTypeName;
@property (nonatomic, retain)   NSString  * intentionItemTypeDescription;
@property (nonatomic, retain)   NSDate    * intentionItemTypeDateCreated;
@property (nonatomic)           double      intentionItemTypeOrderingValue;
@property (nonatomic, retain)   NSString  * intentionItemTypeSubType;

// =================================================================================================================
#pragma mark - Object Methods
// =================================================================================================================

- (instancetype)initWithName:(NSString *)intentionItemTypeName intentionItemTypeDescription:(NSString *)intentionItemTypeDescription;

@end
