// =================================================================================================================
//
//  COBookDataViewController.h
//  iLearn University
//
//  Created by Jeffrey Young on 7/1/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class COBookPDFScrollView;

@interface COBookDataViewController : UIViewController

// =================================================================================================================
#pragma mark - Object Properties
// =================================================================================================================

@property (strong) IBOutlet COBookPDFScrollView* scrollView;

@property CGPDFDocumentRef m_pdf;
@property CGPDFPageRef m_page;
@property int m_pageNumber;
@property CGFloat m_myScale;

@end
