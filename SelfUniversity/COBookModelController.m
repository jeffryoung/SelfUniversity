// =================================================================================================================
//
//  COBookModelController.m
//  SelfUniversity
//
//  Created by Jeffrey Young on 7/1/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COBookModelController.h"
#import "COBookDataViewController.h"

@implementation COBookModelController

// =================================================================================================================
#pragma mark - Initialization Methods
// =================================================================================================================

- (id)init
{
    self = [super init];
    if (self) {
        // Create the data model from the pdf file.
        NSURL *pdfURL = [[NSBundle mainBundle] URLForResource:@"iLearnUniversity.pdf" withExtension:nil];
		self.m_pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef) pdfURL);
        self.m_numberOfPages = (int)CGPDFDocumentGetNumberOfPages(self.m_pdf);
        if( self.m_numberOfPages % 2 ) self.m_numberOfPages++;
    }
    return self;
}

// -----------------------------------------------------------------------------------------------------------------

- (COBookDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
    // Create a new view controller and pass suitable data.
    COBookDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"BookDataViewController"];
    dataViewController.m_pageNumber = (int)index + 1;
    dataViewController.m_pdf = self.m_pdf;
    return dataViewController;
}

// -----------------------------------------------------------------------------------------------------------------

- (NSUInteger)indexOfViewController:(COBookDataViewController *)viewController
{
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and
    // the view controller stores the model object; you can therefore use the model object to identify the index.
    
    return viewController.m_pageNumber - 1;
}

// =================================================================================================================
#pragma mark - Page View Controller Data Source
// =================================================================================================================

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(COBookDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

// -----------------------------------------------------------------------------------------------------------------

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(COBookDataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == self.m_numberOfPages ) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

// =================================================================================================================
#pragma mark - Clean up
// =================================================================================================================

-(void)dealloc
{
    if( self.m_pdf != NULL ) CGPDFDocumentRelease( self.m_pdf );
}


@end
