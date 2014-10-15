// =================================================================================================================
//
//  COIntentionItemTypeDetailViewController.h
//  iLearn University
//
//  Created by Jeffrey Young on 10/14/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>

@class COIntentionItemType;

@protocol COIntentionItemTypeDetailView

- (void) saveTextFieldsIntoIntentionItemType;
- (void) removeCurrentIntentionItemType;

@end

@interface COIntentionItemTypeDetailViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, copy) void (^m_DismissBlock)(void);
@property (nonatomic, strong) NSString *m_tIntentionItemTypeControllerTitle;
@property (nonatomic) NSArray *m_FieldTransitions;

@property (nonatomic) BOOL m_bIsNew;
@property (strong, nonatomic) UIScrollView *m_pScrollView;
@property (strong, nonatomic) UIView *m_pContentView;

- (instancetype) initForNewItem:(BOOL)isNew;
- (void)saveTextFieldsIntoIntentionItemType;
- (void)removeCurrentIntentionItemType;

@end
