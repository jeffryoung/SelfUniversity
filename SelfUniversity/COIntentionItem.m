// =================================================================================================================
//
//  COIntentionItem.m
//  iLearn University
//
//  Created by Jeffrey Young on 8/13/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COIntentionItem.h"

@implementation COIntentionItem

/*@dynamic m_IntentionItemName;
@dynamic m_IntentionItemDescription;
@dynamic m_DateCreated;
 */

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
        self.m_IntentionItemName = intentionItemName;
        self.m_IntentionItemDescription = intentionItemDescription;
        self.m_DateCreated = [[NSDate alloc] init];
    }
    return self;
}


@end
