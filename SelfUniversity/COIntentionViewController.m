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
#import "COIntentionItemDetailViewController.h"
#import "COIntentionItemStore.h"
#import "COIntentionItem.h"

@interface COIntentionViewController ()

@property (nonatomic) NSMutableArray *gListToIntentionTypeTranslator;

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
        
        // Set the contents of the navigation bar with a title and buttons
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = NSLocalizedString(@"Intention", @"Intention View Controller Title");
        
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
        self.tabBarItem.title = NSLocalizedString(@"Intention", @"Intention Tab Bar Label");
        
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
    // Identify which intentions we have turned in in the settings and add their name to the list of intention types
    // the user can choose from on the List Selector model dialog box.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *intentionTypeNameList = [[NSMutableArray alloc] init];
    NSMutableArray *listToIntentionTypeTranslator = [[NSMutableArray alloc] init];
    
    if ([defaults boolForKey:@"IntentionItemsEnabled"]) {
        [intentionTypeNameList addObject:NSLocalizedString(@"A New Intention?", @"New Intention Question")];
        [listToIntentionTypeTranslator addObject:@(kIntentionItem)];
    }
    
    if ([defaults boolForKey:@"GoalItemsEnabled"]) {
        [intentionTypeNameList addObject:NSLocalizedString(@"A New Goal?", @"New Goal Question")];
        [listToIntentionTypeTranslator addObject:@(kGoalItem)];
    }
    
    if ([defaults boolForKey:@"DrivingQuestionItemsEnabled"]) {
        [intentionTypeNameList addObject:NSLocalizedString(@"A New Driving Question?", @"New Driving Question Question")];
        [listToIntentionTypeTranslator addObject:@(kDrivingQuestionItem)];
    }
    
    if ([defaults boolForKey:@"ProductItemsEnabled"]) {
        [intentionTypeNameList addObject:NSLocalizedString(@"A New Product?", @"New Product Question")];
        [listToIntentionTypeTranslator addObject:@(kProductItem)];
    }
    
    // If we have multiple types of intentions to choose from, then put up a modal dialog to let the user choose which
    // type of intention they want to create.
    if ([intentionTypeNameList count] >= 2) {
     
        // Create a intentionTypeSelector object, display it and allow the user to choose which type of intention object they would like to add.
        COListSelector *intentionTypeSelector = [[COListSelector alloc] initWithList:intentionTypeNameList];
        intentionTypeSelector.m_delegate = self;
        intentionTypeSelector.m_dismissBlock = ^{
            [self createNewIntentionType];
        };
        self.gListToIntentionTypeTranslator = listToIntentionTypeTranslator;
        
        // Create a navigation controller to display the list selector modally.
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:intentionTypeSelector];
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        navController.restorationIdentifier = NSStringFromClass([navController class]);
        
        [self presentViewController:navController animated:YES completion:nil];
        
    // If only we only have one intention type, then go ahead and create that intention type.
    } else if ([intentionTypeNameList count] == 1) {
        self.m_nIntentionTypeSelected = 0;
        self.gListToIntentionTypeTranslator = listToIntentionTypeTranslator;
        [self createNewIntentionType];
        
    // If we don't have any intention types to choose from, then we don't need to do anything at all.
    } else if ([intentionTypeNameList count] == 0) {
        self.m_nIntentionTypeSelected = kNoSelectionMade;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Intentions are Enabled in Settings", @"No Intentions enabled message")
                                                        message:NSLocalizedString(@"Go to settings and enable at least one intention type:", @"Enable intentions instructions")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK Button Title")
                                              otherButtonTitles:nil];
        [alert show];
    }
}

// -----------------------------------------------------------------------------------------------------------------

- (void) indexSelected:(NSInteger)index
{
    self.m_nIntentionTypeSelected = index;
}

// -----------------------------------------------------------------------------------------------------------------
// When the user has selected the type of intention he or she wants to create, we will handle it here and create the
// right kind of intention object to add to the list.

- (void) createNewIntentionType
{
    // Look up what type of intention item we are going to create.
    self.m_nIntentionTypeSelected = [self.gListToIntentionTypeTranslator[self.m_nIntentionTypeSelected] integerValue];
    
    // Create a new intention item of the right type...
    COIntentionItem *newIntentionItem = [[COIntentionItemStore sharedIntentionItemStore] createIntentionItem];
    newIntentionItem.intentionItemTypeName = @"";
    newIntentionItem.intentionItemTypeDescription = @"";
    
    // Display the correct detail view controller for that type of item as a modal dialog box.
    COIntentionItemDetailViewController *detailViewController = [[COIntentionItemDetailViewController alloc] initForNewItem:YES];
    detailViewController.m_IntentionItem = newIntentionItem;
    detailViewController.m_DismissBlock = ^{
        [self.tableView reloadData];
    };
    
    switch (self.m_nIntentionTypeSelected) {
        case kIntentionItem:
            detailViewController.m_nIntentionTypeTitle = NSLocalizedString(@"Create a new Intention", @"Create new intention title");
            break;
            
        case kGoalItem:
            detailViewController.m_nIntentionTypeTitle = NSLocalizedString(@"Create a new Goal", @"Create new goal title");
            break;
            
        case kDrivingQuestionItem:
            detailViewController.m_nIntentionTypeTitle = NSLocalizedString(@"Create a new Driving Question", @"Create new driving question title");
            break;
            
        case kProductItem:
            detailViewController.m_nIntentionTypeTitle = NSLocalizedString(@"Create a new Product", @"Create new product title");
            break;
            
        case kNoSelectionMade:
            NSLog(@"Cancelled, not creating anything.");
            return;
    }

    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navController.restorationIdentifier = NSStringFromClass([navController class]);
    
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
    
    cell.textLabel.text = intentionItem.intentionItemTypeName;
    
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
    COIntentionItemDetailViewController *intentionItemDetailViewController = [[COIntentionItemDetailViewController alloc] initForNewItem:NO];
    
    // Give the detail view controller the intentionItem we created.
    NSArray *intentionItems = [[COIntentionItemStore sharedIntentionItemStore] allIntentionItems];
    COIntentionItem *selectedIntentionItem = intentionItems[indexPath.row];
    intentionItemDetailViewController.m_IntentionItem = selectedIntentionItem;
    
    // Push the detail view controller onto the top of the navigation controller's stack
    [self.navigationController pushViewController:intentionItemDetailViewController animated:YES];
}

// =================================================================================================================
#pragma mark - UIViewControllerRestoration Protocol Methods
// =================================================================================================================

+ (UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[self alloc] init];
}

@end
