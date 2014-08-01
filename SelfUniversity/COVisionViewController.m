// =================================================================================================================
//
//  COVisionViewController.m
//  SelfUniversity
//
//  Created by Jeffrey Young on 6/25/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COVisionViewController.h"

@interface COVisionViewController ()

@end

@implementation COVisionViewController

// =================================================================================================================
#pragma mark - Initialization
// =================================================================================================================

- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Vision";
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewVisionItem:)];
        
        // Set this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = barButtonItem;
        navItem.leftBarButtonItem = self.editButtonItem;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(updateTableViewForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
        
        // Register for locale change notifications
        [nc addObserver:self selector:@selector(localeChanged:) name:NSCurrentLocaleDidChangeNotification object:nil];
    }
    return self;
}

// -----------------------------------------------------------------------------------------------------------------

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

// -----------------------------------------------------------------------------------------------------------------

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Set the tab bar item's title
        self.tabBarItem.title = @"Inquiry";
        
        // Create a UIImage from the icon
        UIImage *image = [UIImage imageNamed:@"EyeIcon.png"];
        
        // Put that image on the tab bar item
        self.tabBarItem.image = image;
    }
    return self;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// -----------------------------------------------------------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
    
// =================================================================================================================
#pragma mark - Selectors
// =================================================================================================================

- (IBAction)addNewVisionItem:(id)sender
{
    // Create a new COVisionItem and add it to the store
    
}

// -----------------------------------------------------------------------------------------------------------------

- (void)localeChanged:(NSNotification *)note
{
    [self.tableView reloadData];
}

// -----------------------------------------------------------------------------------------------------------------

- (void)updateTableViewForDynamicTypeSize
{
    static NSDictionary *cellHeightDictionary;
    
    if (!cellHeightDictionary) {
        cellHeightDictionary = @{ UIContentSizeCategoryExtraSmall : @44,
                                  UIContentSizeCategorySmall : @44,
                                  UIContentSizeCategoryMedium : @44,
                                  UIContentSizeCategoryLarge : @44,
                                  UIContentSizeCategoryExtraLarge : @55,
                                  UIContentSizeCategoryExtraExtraLarge : @65,
                                  UIContentSizeCategoryExtraExtraExtraLarge : @75 };
    }
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}

@end
