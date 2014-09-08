// =================================================================================================================
//
//  COIntentionItem.m
//  iLearn University
//
//  Created by Jeffrey Young on 9/8/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COIntentionItem.h"


@implementation COIntentionItem

// =================================================================================================================
#pragma mark - Core Data Class Data
// =================================================================================================================

@dynamic intentionItemKey;
@dynamic intentionItemName;
@dynamic intentionItemDescription;
@dynamic intentionItemDateCreated;
@dynamic intentionItemOrderingValue;
@dynamic intentionItemSubType;

// =================================================================================================================
#pragma mark - Object Class Methods
// =================================================================================================================

+ (instancetype)randomIntentionItem
{
    // Create an immutable array of names
    NSArray *randomNameList = @[@"My Short Term Intention", @"My Long Term Intention", @"Professional Goal", @"Personal Goal", @"Professional Project", @"Personal Project"];
    
    // Create an immutable array of descriptions
    NSArray *randomDescriptionList = @[@"A longer description of my intention", @"A longer description of my goal", @"A longer description of my project"];
    
    // Create a random index for the name we will use for this new intention item.
    NSInteger nameIndex = arc4random() % [randomNameList count];
    NSInteger descriptionIndex = nameIndex / 2;
    
    COIntentionItem *newIntentionItem = [[self alloc] initWithName:randomNameList[nameIndex]
                                          intentionItemDescription:randomDescriptionList[descriptionIndex]];
    return newIntentionItem;
}

// =================================================================================================================
#pragma mark - Object Initialization Methods
// =================================================================================================================

- (instancetype)initWithName:(NSString *)intentionItemName intentionItemDescription:(NSString *)intentionItemDescription
{
    self = [super init];
    if (self) {
        self.intentionItemName = intentionItemName;
        self.intentionItemDescription = intentionItemDescription;
    }
    return self;
}

// -----------------------------------------------------------------------------------------------------------------

- (void) awakeFromInsert
{
    [super awakeFromInsert];
    
    self.intentionItemDateCreated = [NSDate date];
    
    // Create the record key for this database object using a NSUUID object - and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.intentionItemKey = key;
}

@end
