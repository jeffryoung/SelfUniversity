// =================================================================================================================
//
//  COBookModelController.h
//  SelfUniversity
//
//  Created by Jeffrey Young on 7/1/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <Foundation/Foundation.h>

@class COBookDataViewController;

@interface COBookModelController : NSObject <UIPageViewControllerDataSource>

@property CGPDFDocumentRef m_pdf;
@property int m_numberOfPages;

- (COBookDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(COBookDataViewController *)viewController;

@end
