// =================================================================================================================
//
//  COVisionDetailViewController.h
//  iLearn University
//
//  Created by Jeffrey Young on 8/19/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>

@class COVisionItem;

@interface COVisionDetailViewController : UIViewController

@property (nonatomic, strong) COVisionItem *m_VisionItem;
@property (nonatomic, copy) void (^m_DismissBlock)(void);
@property (nonatomic, strong) NSString *m_nVisionTypeTitle;

- (instancetype) initForNewItem:(BOOL)isNew;

@end
