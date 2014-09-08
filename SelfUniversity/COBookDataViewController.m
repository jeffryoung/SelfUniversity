// =================================================================================================================
//
//  COBookDataViewController.m
//  iLearn University
//
//  Created by Jeffrey Young on 7/1/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COBookDataViewController.h"
#import "COBookPDFScrollView.h"
#import "COBookTiledPDFView.h"

@interface COBookDataViewController ()

@end

@implementation COBookDataViewController

// =================================================================================================================
#pragma mark - Object Methods
// =================================================================================================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Set the restoration identifier for this view controller.
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    }
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    return self;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
    
    self.m_page = CGPDFDocumentGetPage( self.m_pdf, self.m_pageNumber );
    NSLog(@"self.m_page==NULL? %@",self.m_page==NULL?@"yes":@"no");
    
    if( self.m_page != NULL ) CGPDFPageRetain( self.m_page );
    [self.scrollView setPDFPage:self.m_page];

}

// -----------------------------------------------------------------------------------------------------------------

- (void)viewWillAppear:(BOOL)animated
{
    // Disable zooming if our pages are currently shown in landscape
    if( self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ) {
        [self.scrollView setUserInteractionEnabled:YES];
    } else {
        [self.scrollView setUserInteractionEnabled:NO];
    }
    NSLog(@"%s scrollView.zoomScale=%f",__PRETTY_FUNCTION__,self.scrollView.zoomScale);
}

// -----------------------------------------------------------------------------------------------------------------

- (void)viewDidLayoutSubviews
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [self restoreScale];
}

// -----------------------------------------------------------------------------------------------------------------

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if( fromInterfaceOrientation == UIInterfaceOrientationPortrait || fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ) {
        [self.scrollView setUserInteractionEnabled:NO];
    } else {
        [self.scrollView setUserInteractionEnabled:YES];
    }
}

// -----------------------------------------------------------------------------------------------------------------

-(void)restoreScale
{
    // Called on orientation change.
    // We need to zoom out and basically reset the scrollview to look right in two-page spline view.
    CGRect pageRect = CGPDFPageGetBoxRect( self.m_page, kCGPDFMediaBox );
    CGFloat yScale = self.view.frame.size.height/pageRect.size.height;
    CGFloat xScale = self.view.frame.size.width/pageRect.size.width;
    
    self.m_myScale = MIN( xScale, yScale );
    NSLog(@"%s self.myScale=%f",__PRETTY_FUNCTION__, self.m_myScale);
    self.scrollView.bounds = self.view.bounds;
    self.scrollView.zoomScale = 1.0;
    self.scrollView.m_PDFScale = self.m_myScale;
    self.scrollView.m_tiledPDFView.bounds = self.view.bounds;
    self.scrollView.m_tiledPDFView.m_myScale = self.m_myScale;
    [self.scrollView.m_tiledPDFView.layer setNeedsDisplay];
}

// -----------------------------------------------------------------------------------------------------------------

- (void)didReceiveMemoryWarning {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// -----------------------------------------------------------------------------------------------------------------

- (void) dealloc
{
    if (self.m_page != NULL) {
        CGPDFPageRelease(self.m_page);
    }
}

@end
