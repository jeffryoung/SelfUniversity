// =================================================================================================================
//
//  COBookPDFScrollView.m
//  SelfUniversity
//
//  Created by Jeffrey Young on 7/1/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COBookPDFScrollView.h"
#import "COBookTiledPDFView.h"
#import <QuartzCore/QuartzCore.h>

@implementation COBookPDFScrollView
{
    CGPDFPageRef g_PDFPage;
}

// =================================================================================================================
#pragma mark - Initialization methods
// =================================================================================================================

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

// -----------------------------------------------------------------------------------------------------------------

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)initialize
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.delegate = self;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 5;
    self.minimumZoomScale = .25;
    self.maximumZoomScale = 5;
}

// =================================================================================================================
#pragma mark - Object Methods
// =================================================================================================================

- (void)setPDFPage:(CGPDFPageRef)PDFPage;
{
    if( PDFPage != NULL ) CGPDFPageRetain(PDFPage);
    if( g_PDFPage != NULL ) CGPDFPageRelease(g_PDFPage);
    g_PDFPage = PDFPage;
    
    // PDFPage is null if we're requested to draw a padded blank page by the parent UIPageViewController
    if( PDFPage == NULL ) {
        self.m_pageRect = self.bounds;
    } else {
        self.m_pageRect = CGPDFPageGetBoxRect( g_PDFPage, kCGPDFMediaBox );
        self.m_PDFScale = self.frame.size.width/self.m_pageRect.size.width;
        self.m_pageRect = CGRectMake( self.m_pageRect.origin.x, self.m_pageRect.origin.y, self.m_pageRect.size.width*_m_PDFScale, self.m_pageRect.size.height*_m_PDFScale );
    }
    // Create the TiledPDFView based on the size of the PDF page and scale it to fit the view.
    [self replaceTiledPDFViewWithFrame:self.m_pageRect];
}

// -----------------------------------------------------------------------------------------------------------------

- (void)dealloc
{
    // Clean up.
    if( g_PDFPage != NULL ) CGPDFPageRelease(g_PDFPage);
}

// -----------------------------------------------------------------------------------------------------------------
// Use layoutSubviews to center the PDF page in the view.

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //NSLog(@"%s bounds: %@",__PRETTY_FUNCTION__,NSStringFromCGRect(self.bounds));
    
    // Center the image as it becomes smaller than the size of the screen.
    
    CGSize boundsSize = self.bounds.size;
    
    CGRect frameToCenter = self.m_tiledPDFView.frame;
    
    // Center horizontally.
    
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // Center vertically.
    
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    self.m_tiledPDFView.frame = frameToCenter;
    self.m_backgroundImageView.frame = frameToCenter;
    

    // To handle the interaction between CATiledLayer and high resolution screens, set the tiling view's contentScaleFactor to 1.0.
    // If this step were omitted, the content scale factor would be 2.0 on high resolution screens,
    // which would cause the CATiledLayer to ask for tiles of the wrong scale.

    self.m_tiledPDFView.contentScaleFactor = 1.0;
}

// =================================================================================================================
#pragma mark - UIScrollView delegate methods
// =================================================================================================================

// -----------------------------------------------------------------------------------------------------------------

// A UIScrollView delegate callback, called when the user starts zooming.
// Return the current TiledPDFView.

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.m_tiledPDFView;
}

// -----------------------------------------------------------------------------------------------------------------
// A UIScrollView delegate callback, called when the user begins zooming.
// When the user begins zooming, remove the old TiledPDFView and set the current TiledPDFView
// to be the old view so we can create a new TiledPDFView when the zooming ends.

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    NSLog(@"%s scrollView.zoomScale=%f",__PRETTY_FUNCTION__,self.zoomScale);
    // Remove back tiled view.
    [self.m_oldTiledPDFView removeFromSuperview];
    
    // Set the current TiledPDFView to be the old view.
    self.m_oldTiledPDFView = self.m_tiledPDFView;
}

// -----------------------------------------------------------------------------------------------------------------
// A UIScrollView delegate callback, called when the user stops zooming.
// When the user stops zooming, create a new TiledPDFView based on the new zoom level and draw it on top of the old TiledPDFView.

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"BEFORE  %s scale=%f, _PDFScale=%f",__PRETTY_FUNCTION__,scale,self.m_PDFScale);
    // Set the new scale factor for the TiledPDFView.
    self.m_PDFScale *= scale;
    NSLog(@"AFTER  %s scale=%f, _m_PDFScale=%f newFrame=%@",__PRETTY_FUNCTION__, scale, self.m_PDFScale, NSStringFromCGRect(self.m_oldTiledPDFView.frame));
    
    // Create a new tiled PDF View at the new scale
    [self replaceTiledPDFViewWithFrame:self.m_oldTiledPDFView.frame];
}

// -----------------------------------------------------------------------------------------------------------------

-(void)replaceTiledPDFViewWithFrame:(CGRect)frame
{
    // Create a new tiled PDF View at the new scale
    NSLog(@"%s Creating a new tiled PDF View with frame %@ at scale %f", __PRETTY_FUNCTION__, NSStringFromCGRect(frame), self.m_PDFScale);
    COBookTiledPDFView *tiledPDFView = [[COBookTiledPDFView alloc] initWithFrame:frame scale:self.m_PDFScale];
    [tiledPDFView setPage:g_PDFPage];
    
    // Add the new TiledPDFView to the PDFScrollView.
    [self addSubview:tiledPDFView];
    self.m_tiledPDFView = tiledPDFView;
}


@end
