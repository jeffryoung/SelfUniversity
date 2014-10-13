// =================================================================================================================
//
//  COIntentionItemTypeCell.h
//  iLearn University
//
//  Created by Jeffrey Young on 10/10/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <Foundation/Foundation.h>

@interface COIntentionItemTypeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *intentionItemTypeNameField;
@property (weak, nonatomic) IBOutlet UILabel *intentionItemTypeDescriptionField;
@property (weak, nonatomic) IBOutlet UILabel *intentionItemTypeDateCreatedField;

@end
