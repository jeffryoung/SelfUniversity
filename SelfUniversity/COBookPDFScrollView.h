// =================================================================================================================
//
//  COBookPDFScrollView.h
//  SelfUniversity
//
//  Created by Jeffrey Young on 7/1/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class COBookTiledPDFView;

@interface COBookPDFScrollView : UIScrollView <UIScrollViewDelegate>

// =================================================================================================================
#pragma mark - Object Properties
// =================================================================================================================

// Frame of the PDF
@property (nonatomic) CGRect m_pageRect;

// A low resolution image of the PDF page that is displayed until the TiledPDFView renders its content.
@property (nonatomic, weak) UIView *m_backgroundImageView;

// The TiledPDFView that is currently front most.
@property (nonatomic, weak) COBookTiledPDFView *m_tiledPDFView;

// The old TiledPDFView that we draw on top of when the zooming stops.
@property (nonatomic, weak) COBookTiledPDFView *m_oldTiledPDFView;

// Current PDF zoom scale.
@property (nonatomic) CGFloat m_PDFScale;

// =================================================================================================================
#pragma mark - Object Methods
// =================================================================================================================

- (void)setPDFPage:(CGPDFPageRef)PDFPage;
- (void)replaceTiledPDFViewWithFrame:(CGRect)frame;

@end
