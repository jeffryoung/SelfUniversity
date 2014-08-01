// =================================================================================================================
//
//  COBookTiledPDFView.m
//  SelfUniversity
//
//  Created by Jeffrey Young on 7/1/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COBookTiledPDFView.h"
#import <QuartzCore/QuartzCore.h>

@implementation COBookTiledPDFView


// -----------------------------------------------------------------------------------------------------------------
// Create a new TiledPDFView with the desired frame and scale.

- (id)initWithFrame:(CGRect)frame scale:(CGFloat)scale
{
    self = [super initWithFrame:frame];
    if (self) {
        CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
        
        // levelsOfDetail and levelsOfDetailBias determine how the layer is rendered at different zoom levels.
        // This only matters while the view is zooming, because once the the view is done zooming a new TiledPDFView is created at the correct size and scale.
        
        tiledLayer.levelsOfDetail = 4;
        tiledLayer.levelsOfDetailBias = 3;
        tiledLayer.tileSize = CGSizeMake(512.0, 512.0);
        self.m_myScale = scale;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 5;
    }
    return self;
}

// -----------------------------------------------------------------------------------------------------------------
// The layer's class should be CATiledLayer.
+ (Class)layerClass
{
    return [CATiledLayer class];
}

// -----------------------------------------------------------------------------------------------------------------
// Set the CGPDFPageRef for the view.

- (void)setPage:(CGPDFPageRef)newPage
{
    if( self.m_pdfPage != NULL ) CGPDFPageRelease( self.m_pdfPage );
    if( newPage != NULL ) self.m_pdfPage = CGPDFPageRetain( newPage );
}

// -----------------------------------------------------------------------------------------------------------------
// Draw the CGPDFPageRef into the layer at the correct scale.

-(void)drawLayer:(CALayer*)layer inContext:(CGContextRef)context
{
    NSLog(@"%s myScale:%f",__PRETTY_FUNCTION__,self.m_myScale);
    
    // Fill the background with white.
    CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context, self.bounds);
    
    // Print a blank page and return if our page is null.
    if( _m_pdfPage == NULL ) return;
    
    CGContextSaveGState(context);
    
    // Flip the context so that the PDF page is rendered right side up.
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Scale the context so that the PDF page is rendered at the correct size for the zoom level.
    CGContextScaleCTM(context, self.m_myScale, self.m_myScale);
    
    CGContextDrawPDFPage(context, self.m_pdfPage);
    CGContextRestoreGState(context);
}

// -----------------------------------------------------------------------------------------------------------------
// Clean up.

- (void)dealloc
{
    if( self.m_pdfPage != NULL ) CGPDFPageRelease( self.m_pdfPage );
}

@end
