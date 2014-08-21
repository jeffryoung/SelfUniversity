// =================================================================================================================
//
//  COVisionItem.h
//  iLearn University
//
//  Created by Jeffrey Young on 8/13/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <Foundation/Foundation.h>
//#import <CoreData/CoreData.h>

@interface COVisionItem : NSObject //NSManagedObject

// =================================================================================================================
#pragma mark - Object Properties
// =================================================================================================================

@property (nonatomic, retain) NSString *m_VisionItemName;
@property (nonatomic, retain) NSString *m_VisionItemDescription;
@property (nonatomic, retain) NSDate *m_DateCreated;

// =================================================================================================================
#pragma mark - Object Methods
// =================================================================================================================

+ (instancetype)randomVisionItem;
- (instancetype)initWithName:(NSString *)visionItemName
       visionItemDescription:(NSString *)visionItemDescription;

@end
