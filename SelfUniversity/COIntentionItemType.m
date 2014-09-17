// =================================================================================================================
//
//  COIntentionItemType.m
//  iLearn University
//
//  Created by Jeffrey Young on 9/8/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COIntentionItemType.h"


@implementation COIntentionItemType

// =================================================================================================================
#pragma mark - Core Data Class Data
// =================================================================================================================

@dynamic intentionItemTypeKey;
@dynamic intentionItemTypeName;
@dynamic intentionItemTypeDescription;
@dynamic intentionItemTypeDateCreated;
@dynamic intentionItemTypeOrderingValue;
@dynamic intentionItemTypeSubType;

// =================================================================================================================
#pragma mark - Object Initialization Methods
// =================================================================================================================

- (instancetype)initWithName:(NSString *)intentionItemTypeName intentionItemTypeDescription:(NSString *)intentionItemTypeDescription
{
    self = [super init];
    if (self) {
        self.intentionItemTypeName = intentionItemTypeName;
        self.intentionItemTypeDescription = intentionItemTypeDescription;
    }
    return self;
}

// -----------------------------------------------------------------------------------------------------------------

- (void) awakeFromInsert
{
    [super awakeFromInsert];
    
    self.intentionItemTypeDateCreated = [NSDate date];
    
    // Create the record key for this database object using a NSUUID object - and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.intentionItemTypeKey = key;
}

@end
