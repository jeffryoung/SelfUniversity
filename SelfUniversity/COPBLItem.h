// =================================================================================================================
//
//  COPBLItem.h
//  iLearn University
//
//  Created by Jeffrey Young on 10/23/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>
#import "COIntentionItemType.h"

@interface COPBLItem : COIntentionItemType

@property (nonatomic, strong)   NSString  * pblItemSubDrivingQuestion;
@property (nonatomic, strong)   NSString  * pblItemClarifyingQuestion1;
@property (nonatomic, strong)   NSString  * pblItemClarifyingQuestion2;
@property (nonatomic, strong)   NSString  * pblItemClarifyingQuestion3;
@property (nonatomic, strong)   NSString  * pblItemGuidingQuestion1;
@property (nonatomic, strong)   NSString  * pblItemGuidingQuestion2;
@property (nonatomic, strong)   NSString  * pblItemGuidingQuestion3;

@end
