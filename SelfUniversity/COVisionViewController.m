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
#import "COVisionDetailViewController.h"
#import "COVisionItemStore.h"
#import "COVisionItem.h"

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
        
        // Temporarily populate a few random Vision Items so we can see what it all looks like.
        for (int i=0; i<8; i++) {
            [[COVisionItemStore sharedVisionItemStore] createVisionItem];
        }
        
        // Set the contents of the navigation bar with a title and buttons
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Vision Inquiry";
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewVisionItem:)];
        
        // Set this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = barButtonItem;
        navItem.leftBarButtonItem = self.editButtonItem;
        
        // Set the restoration identifier that is the same name as the class
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        // Register ourselves as observers for changes in Dynamic Type size.
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

// -----------------------------------------------------------------------------------------------------------------

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

// =================================================================================================================
#pragma mark - Selectors
// =================================================================================================================

- (IBAction)addNewVisionItem:(id)sender
{
    // Create a visionTypeSelector object, display it and allow the user to choose which type of vision object they would like to add.
    COVisionTypeSelectorTableViewController *visionTypeSelector = [[COVisionTypeSelectorTableViewController alloc] init];
    visionTypeSelector.m_delegate = self;
    visionTypeSelector.m_dismissBlock = ^{
        [self createNewVisionType];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:visionTypeSelector];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:navController animated:YES completion:nil];
}

// -----------------------------------------------------------------------------------------------------------------

- (void) visionTypeSelected:(NSInteger)visionType
{
    self.m_nVisionTypeSelected = visionType;
}

// -----------------------------------------------------------------------------------------------------------------
// When the user has selected the type of vision he or she wants to create, we will handle it here and create the
// right kind of vision object to add to the list.

- (void) createNewVisionType
{
    COVisionItem *newVisionItem = [[COVisionItemStore sharedVisionItemStore] createVisionItem];
    newVisionItem.m_VisionItemName = @"";
    newVisionItem.m_VisionItemDescription = @"";
    
    COVisionDetailViewController *detailViewController = [[COVisionDetailViewController alloc] initForNewItem:YES];
    detailViewController.m_VisionItem = newVisionItem;
    detailViewController.m_DismissBlock = ^{
        [self.tableView reloadData];
    };
    
    switch (self.m_nVisionTypeSelected) {
        case kVisionItem:
            detailViewController.m_nVisionTypeTitle = @"Create a new Vision";
            break;
            
        case kGoalItem:
            detailViewController.m_nVisionTypeTitle = @"Create a new Goal";
            break;
            
        case kDrivingQuestionItem:
            detailViewController.m_nVisionTypeTitle = @"Create a new Driving Question";
            break;
            
        case kNoVisionTypeSelectionMade:
            NSLog(@"Cancelled, not creating anything.");
            break;
    }

    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:navController animated:YES completion:nil];

    
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

// =================================================================================================================
#pragma mark - UITableViewDataSource Protocol Methods
// =================================================================================================================

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[COVisionItemStore sharedVisionItemStore] allVisionItems] count];
}

// -----------------------------------------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Set the text on the cell with the description of the item that is the nth index of items
    
    NSArray *visionItems = [[COVisionItemStore sharedVisionItemStore] allVisionItems];
    COVisionItem *visionItem = visionItems[indexPath.row];
    
    cell.textLabel.text = visionItem.m_VisionItemName;
    
    return cell;
}

// -----------------------------------------------------------------------------------------------------------------

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *visionItems = [[COVisionItemStore sharedVisionItemStore] allVisionItems];
        COVisionItem *selectedVisionItem = visionItems[indexPath.row];
        [[COVisionItemStore sharedVisionItemStore] removeVisionItem:selectedVisionItem];
        
        // Also remove that row from the table view with an animation...
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// -----------------------------------------------------------------------------------------------------------------

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[COVisionItemStore sharedVisionItemStore] moveVisionItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

// -----------------------------------------------------------------------------------------------------------------

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    COVisionDetailViewController *visionDetailViewController = [[COVisionDetailViewController alloc] initForNewItem:NO];
    
    // Give the detail view controller the visionItem we created.
    NSArray *visionItems = [[COVisionItemStore sharedVisionItemStore] allVisionItems];
    COVisionItem *selectedVisionItem = visionItems[indexPath.row];
    visionDetailViewController.m_VisionItem = selectedVisionItem;
    
    // Push the detail view controller onto the top of the navigation controller's stack
    [self.navigationController pushViewController:visionDetailViewController animated:YES];
}

@end
