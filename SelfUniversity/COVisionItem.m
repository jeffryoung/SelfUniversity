// =================================================================================================================
//
//  COVisionItem.m
//  iLearn University
//
//  Created by Jeffrey Young on 8/13/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COVisionItem.h"

@implementation COVisionItem

/*@dynamic m_VisionItemName;
@dynamic m_VisionItemDescription;
@dynamic m_DateCreated;
 */

// =================================================================================================================
#pragma mark - Object Class Methods
// =================================================================================================================

+ (instancetype)randomVisionItem
{
    // Create an immutable array of names
    NSArray *randomNameList = @[@"My Short Term Vision", @"My Long Term Vision", @"Professional Goal", @"Personal Goal", @"Professional Project", @"Personal Project"];
    
    // Create an immutable array of descriptions
    NSArray *randomDescriptionList = @[@"A longer description of my vision", @"A longer description of my goal", @"A longer description of my project"];
    
    // Create a random index for the name we will use for this new vision item.
    NSInteger nameIndex = arc4random() % [randomNameList count];
    NSInteger descriptionIndex = nameIndex / 2;
    
    COVisionItem *newVisionItem = [[self alloc] initWithName:randomNameList[nameIndex]
                                       visionItemDescription:randomDescriptionList[descriptionIndex]];
    return newVisionItem;
}

// =================================================================================================================
#pragma mark - Object Initialization Methods
// =================================================================================================================

- (instancetype)initWithName:(NSString *)visionItemName visionItemDescription:(NSString *)visionItemDescription
{
    self = [super init];
    if (self) {
        self.m_VisionItemName = visionItemName;
        self.m_VisionItemDescription = visionItemDescription;
        self.m_DateCreated = [[NSDate alloc] init];
    }
    return self;
}


@end
