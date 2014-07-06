// =================================================================================================================
//
//  COBookTiledPDFView.h
//  SelfUniversity
//
//  Created by Jeffrey Young on 7/1/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import <UIKit/UIKit.h>

@interface COBookTiledPDFView : UIView

@property CGPDFPageRef m_pdfPage;
@property CGRect m_pdfPageRect;
@property CGFloat m_myScale;

- (id)initWithFrame:(CGRect)frame scale:(CGFloat)scale;
- (void)setPage:(CGPDFPageRef)newPage;

@end
