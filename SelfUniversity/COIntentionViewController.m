// =================================================================================================================
//
//  COIntensionViewController.m
//  iLearn University
//
//  Created by Jeffrey Young on 6/25/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COIntentionViewController.h"
#import "COIntentionDetailViewController.h"
#import "COIntentionItemStore.h"
#import "COIntentionItem.h"

@interface COIntentionViewController ()

@end

@implementation COIntentionViewController

// =================================================================================================================
#pragma mark - Initialization
// =================================================================================================================

- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        // Temporarily populate a few random intention Items so we can see what it all looks like.
        for (int i=0; i<8; i++) {
            [[COIntentionItemStore sharedIntentionItemStore] createIntentionItem];
        }
        
        // Set the contents of the navigation bar with a title and buttons
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Intention";
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewIntentionItem:)];
        
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
        self.tabBarItem.title = @"Intention";
        
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

- (IBAction)addNewIntentionItem:(id)sender
{
    // Create a intentionTypeSelector object, display it and allow the user to choose which type of intention object they would like to add.
    COIntentionTypeSelectorTableViewController *intentionTypeSelector = [[COIntentionTypeSelectorTableViewController alloc] init];
    intentionTypeSelector.m_delegate = self;
    intentionTypeSelector.m_dismissBlock = ^{
        [self createNewIntentionType];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:intentionTypeSelector];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:navController animated:YES completion:nil];
}

// -----------------------------------------------------------------------------------------------------------------

- (void) intentionTypeSelected:(NSInteger)intentionType
{
    self.m_nIntentionTypeSelected = intentionType;
}

// -----------------------------------------------------------------------------------------------------------------
// When the user has selected the type of intention he or she wants to create, we will handle it here and create the
// right kind of intention object to add to the list.

- (void) createNewIntentionType
{
    COIntentionItem *newIntentionItem = [[COIntentionItemStore sharedIntentionItemStore] createIntentionItem];
    newIntentionItem.m_IntentionItemName = @"";
    newIntentionItem.m_IntentionItemDescription = @"";
    
    COIntentionDetailViewController *detailViewController = [[COIntentionDetailViewController alloc] initForNewItem:YES];
    detailViewController.m_IntentionItem = newIntentionItem;
    detailViewController.m_DismissBlock = ^{
        [self.tableView reloadData];
    };
    
    switch (self.m_nIntentionTypeSelected) {
        case kIntentionItem:
            detailViewController.m_nIntentionTypeTitle = @"Create a new Intention";
            break;
            
        case kGoalItem:
            detailViewController.m_nIntentionTypeTitle = @"Create a new Goal";
            break;
            
        case kDrivingQuestionItem:
            detailViewController.m_nIntentionTypeTitle = @"Create a new Driving Question";
            break;
            
        case kNoIntentionTypeSelectionMade:
            NSLog(@"Cancelled, not creating anything.");
            break;
    }

    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
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
    return [[[COIntentionItemStore sharedIntentionItemStore] allIntentionItems] count];
}

// -----------------------------------------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Set the text on the cell with the description of the item that is the nth index of items
    
    NSArray *intentionItems = [[COIntentionItemStore sharedIntentionItemStore] allIntentionItems];
    COIntentionItem *intentionItem = intentionItems[indexPath.row];
    
    cell.textLabel.text = intentionItem.m_IntentionItemName;
    
    return cell;
}

// -----------------------------------------------------------------------------------------------------------------

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *intentionItems = [[COIntentionItemStore sharedIntentionItemStore] allIntentionItems];
        COIntentionItem *selectedIntentionItem = intentionItems[indexPath.row];
        [[COIntentionItemStore sharedIntentionItemStore] removeIntentionItem:selectedIntentionItem];
        
        // Also remove that row from the table view with an animation...
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// -----------------------------------------------------------------------------------------------------------------

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[COIntentionItemStore sharedIntentionItemStore] moveIntentionItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

// -----------------------------------------------------------------------------------------------------------------

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    COIntentionDetailViewController *intentionDetailViewController = [[COIntentionDetailViewController alloc] initForNewItem:NO];
    
    // Give the detail view controller the intentionItem we created.
    NSArray *intentionItems = [[COIntentionItemStore sharedIntentionItemStore] allIntentionItems];
    COIntentionItem *selectedIntentionItem = intentionItems[indexPath.row];
    intentionDetailViewController.m_IntentionItem = selectedIntentionItem;
    
    // Push the detail view controller onto the top of the navigation controller's stack
    [self.navigationController pushViewController:intentionDetailViewController animated:YES];
}

@end
