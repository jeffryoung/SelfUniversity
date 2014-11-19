// =================================================================================================================
//
//  COProjectViewController.m
//  SelfUniversity
//
//  Created by Jeffrey Young on 6/25/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COTaskViewController.h"

@interface COTaskViewController ()

@end

@implementation COTaskViewController

// =================================================================================================================
#pragma mark - Initialization
// =================================================================================================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Set the tab bar item's title
        self.tabBarItem.title = NSLocalizedString(@"Task", @"Task Tab Bar Label");
        
        // Create a UIImage from the icon
        UIImage *image = [UIImage imageNamed:@"TaskIcon.png"];
        
        // Put that image on the tab bar item
        self.tabBarItem.image = image;
    }
    
    // Set the restoration identifier for this view controller.
    self.restorationIdentifier = NSStringFromClass([self class]);
    self.restorationClass = [self class];

    return self;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *customURL = @"trello://";
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:customURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot invoke Trello"
                                                        message:[NSString stringWithFormat:
                                                                 @"Please install Trello from the App Store"]
                                                       delegate:self cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

// -----------------------------------------------------------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// =================================================================================================================
#pragma mark - UIViewControllerRestoration Protocol Methods
// =================================================================================================================

+ (UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[self alloc] init];
}

@end
