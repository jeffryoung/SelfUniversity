// =================================================================================================================
//
//  COProductStoryItemHelpViewController.m
//  iLearn University
//
//  Created by Jeffrey Young on 10/20/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COProductStoryItemHelpViewController.h"

@interface COProductStoryItemHelpViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation COProductStoryItemHelpViewController

// =================================================================================================================
#pragma mark - Object Methods
// =================================================================================================================

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self) {
        [self.view addSubview:self.contentView];
    }
}

// -----------------------------------------------------------------------------------------------------------------
// Load the form with data from the selected intention item

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Set the size of the content so that the content will scroll properly.
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    CGSize contentSize = self.contentView.frame.size;
    contentSize.height = contentSize.height + navBarFrame.size.height + statusBarFrame.size.height + 10.0;
    
    self.scrollView.contentSize = contentSize;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)viewDidUnload
{
    self.contentView = nil;
    [super viewDidUnload];
}

// -----------------------------------------------------------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// =================================================================================================================
#pragma mark - Selector methods
// =================================================================================================================
    
- (void) done:(id)sender
{
    // We are done, so tell the presenting view controller to dismiss us.
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
