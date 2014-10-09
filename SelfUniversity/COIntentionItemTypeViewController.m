// =================================================================================================================
//
//  COIntentionItemTypeViewController.m
//  iLearn University
//
//  Created by Jeffrey Young on 6/25/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COGlobalDefsConstants.h"
#import "COAppDelegate.h"
#import "COIntentionItemTypeViewController.h"
#import "COIntentionItemTypeStore.h"
#import "COIntentionItem.h"
#import "COIntentionItemDetailViewController.h"
#import "COGoalItem.h"
#import "COGoalItemDetailViewController.h"

@interface COIntentionItemTypeViewController () <UIDataSourceModelAssociation>

@property (nonatomic) NSMutableArray *gListToIntentionTypeTranslator;
@property (nonatomic) BOOL m_bRestoreInProgressShowDetailViewController;
@property (nonatomic) UIViewController *m_detailViewController;

@end

@implementation COIntentionItemTypeViewController

// =================================================================================================================
#pragma mark - Initialization
// =================================================================================================================

- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.m_bRestoreInProgressShowDetailViewController = NO;
        self.m_detailViewController = nil;
        
        // Set the contents of the navigation bar with a title and buttons
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = NSLocalizedString(@"Intentions", @"Intention View Controller Title");
        
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
    self.tableView.restorationIdentifier = @"COIntentionTypeViewControllerTableView";
}

// -----------------------------------------------------------------------------------------------------------------

- (void) viewDidAppear:(BOOL)animated
{
    if (self.m_bRestoreInProgressShowDetailViewController) {
        [self presentDetailViewModally:self.m_detailViewController];
        self.m_bRestoreInProgressShowDetailViewController = NO;
    }
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
        COListSelectorViewController *intentionTypeSelector = [[COListSelectorViewController alloc] initWithList:intentionTypeNameList];
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
        self.m_nIntentionItemTypeSelected = 0;
        self.gListToIntentionTypeTranslator = listToIntentionTypeTranslator;
        [self createNewIntentionType];
        
    // If we don't have any intention types to choose from, then we don't need to do anything at all.
    } else if ([intentionTypeNameList count] == 0) {
        self.m_nIntentionItemTypeSelected = kNoSelectionMade;
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
    self.m_nIntentionItemTypeSelected = index;
}

// -----------------------------------------------------------------------------------------------------------------
// When the user has selected the type of intention he or she wants to create, we will handle it here and create the
// right kind of intention object to add to the list.

- (void) createNewIntentionType
{
    // Look up what type of intention item we are going to create.
    self.m_nIntentionItemTypeSelected = [self.gListToIntentionTypeTranslator[self.m_nIntentionItemTypeSelected] integerValue];
    
    // Create a new intention item of the right type...
    // Display the correct detail view controller for that type of item as a modal dialog box.
    
    // Intention Items...
    if (self.m_nIntentionItemTypeSelected == kIntentionItem) {
        COIntentionItem *newIntentionItem = [[COIntentionItemTypeStore sharedIntentionItemTypeStore] createIntentionItem];
        newIntentionItem.intentionItemTypeName = @"";
        newIntentionItem.intentionItemTypeDescription = @"";
        
        COIntentionItemDetailViewController *detailViewController = [[COIntentionItemDetailViewController alloc] initForNewItem:YES];
        detailViewController.m_IntentionItem = (COIntentionItem *)newIntentionItem;
        detailViewController.m_DismissBlock = ^{
            [self.tableView reloadData];
        };
        detailViewController.m_tIntentionItemTitle = NSLocalizedString(@"Create a new Intention", @"Create new intention title");
        
        [self presentDetailViewModally:detailViewController];
        
    // Goal Items...
    } else if (self.m_nIntentionItemTypeSelected == kGoalItem) {
        COGoalItem *newGoalItem = [[COIntentionItemTypeStore sharedIntentionItemTypeStore] createGoalItem];
        newGoalItem.intentionItemTypeName = @"";
        newGoalItem.intentionItemTypeDescription = @"";
        newGoalItem.goalItemReward = @"";
        newGoalItem.goalItemTargetDate = [NSDate date];
        
        COGoalItemDetailViewController *detailViewController = [[COGoalItemDetailViewController alloc] initForNewItem:YES];
        detailViewController.m_GoalItem = newGoalItem;
        detailViewController.m_DismissBlock = ^{
            [self.tableView reloadData];
        };
        detailViewController.m_tGoalTitle = NSLocalizedString(@"Create a new Goal", @"Create new goal title");
        
        [self presentDetailViewModally:detailViewController];
        
        // Driving Question Items...
//    } else if (self.m_nIntentionItemTypeSelected == kDrivingQuestionItem) {
        
/*        CODrivingQuestionItem *newDrivingQuestionItem = [[COIntentionItemTypeStore sharedIntentionItemTypeStore] createDrivingQuestionItem];
        newDrivingQuestionItem.intentionItemTypeName = @"";
        newDrivingQuestionItem.intentionItemTypeDescription = @"";
        
        CODrivingQuestionItemDetailViewController *detailViewController = [[CODrivingQuestionItemDetailViewController alloc] initForNewItem:YES];
        detailViewController.m_DrivingQuestionItem = newDrivingQuestionItem;
        detailViewController.m_DismissBlock = ^{
            [self.tableView reloadData];
        };
        detailViewController.m_nDrivingQuestionTitle = NSLocalizedString(@"Create a new Driving Question", @"Create new driving question title");
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        navController.restorationIdentifier = NSStringFromClass([navController class]);
        
        [self presentViewController:navController animated:YES completion:nil];
 */
        // Product Items...
//    } else if (self.m_nIntentionItemTypeSelected == kProductItem) {
/*        COProductItem *newProductItem = [[COIntentionItemTypeStore sharedIntentionItemTypeStore] createProductItem];
         newProductItem.intentionItemTypeName = @"";
         newProductItem.intentionItemTypeDescription = @"";
         
         COProductItemDetailViewController *detailViewController = [[COProductItemDetailViewController alloc] initForNewItem:YES];
         detailViewController.m_ProductItem = newProductItem;
         detailViewController.m_DismissBlock = ^{
         [self.tableView reloadData];
         };
         detailViewController.m_nProductTitle = NSLocalizedString(@"Create a new Product", @"Create new product title");
         
         UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
         navController.modalPresentationStyle = UIModalPresentationFormSheet;
         navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
         navController.restorationIdentifier = NSStringFromClass([navController class]);
         
         [self presentViewController:navController animated:YES completion:nil];
         */

    }
}

// -----------------------------------------------------------------------------------------------------------------

- (void)pushDetailViewOntoNavigationController:(UIViewController *)detailViewController
{
    [self.navigationController pushViewController:detailViewController animated:YES];
}

// -----------------------------------------------------------------------------------------------------------------

- (void)presentDetailViewModally:(UIViewController *)detailViewController
{
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navController.restorationIdentifier = NSStringFromClass([navController class]);
    
    [self presentViewController:navController animated:YES completion:nil];
}

// -----------------------------------------------------------------------------------------------------------------

- (void)registerToPresentDetailViewControllerModally:(UIViewController *)detailViewController
{
    self.m_bRestoreInProgressShowDetailViewController = YES;
    self.m_detailViewController = detailViewController;
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
    return [[[COIntentionItemTypeStore sharedIntentionItemTypeStore] allIntentionItemTypes] count];
}

// -----------------------------------------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Set the text on the cell with the description of the item that is the nth index of items
    NSArray *intentionItemTypes = [[COIntentionItemTypeStore sharedIntentionItemTypeStore] allIntentionItemTypes];
    COIntentionItemType *intentionItemType = intentionItemTypes[indexPath.row];
    
    cell.textLabel.text = intentionItemType.intentionItemTypeName;
    
    return cell;
}

// -----------------------------------------------------------------------------------------------------------------

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *intentionItemTypes = [[COIntentionItemTypeStore sharedIntentionItemTypeStore] allIntentionItemTypes];
        COIntentionItemType *selectedIntentionItemType = intentionItemTypes[indexPath.row];
        [[COIntentionItemTypeStore sharedIntentionItemTypeStore] removeIntentionItemType:selectedIntentionItemType];
        
        // Also remove that row from the table view with an animation...
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// -----------------------------------------------------------------------------------------------------------------

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[COIntentionItemTypeStore sharedIntentionItemTypeStore] moveIntentionItemTypeAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

// -----------------------------------------------------------------------------------------------------------------

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the intentionItemType we selected.
    NSArray *intentionItemTypes = [[COIntentionItemTypeStore sharedIntentionItemTypeStore] allIntentionItemTypes];
    COIntentionItemType *selectedIntentionItemType = intentionItemTypes[indexPath.row];
    
    // Using the subType string in the intentionItemType, push the appropriate view controller on top of the navigation controller's stack.
    if ([selectedIntentionItemType.intentionItemTypeSubType isEqualToString:NSLocalizedString(@"Intention Item", @"Intention Item")]) {
        COIntentionItemDetailViewController *intentionItemDetailViewController = [[COIntentionItemDetailViewController alloc] initForNewItem:NO];
        intentionItemDetailViewController.m_IntentionItem = (COIntentionItem *) selectedIntentionItemType;
        [self pushDetailViewOntoNavigationController:intentionItemDetailViewController];
        
    } else if ([selectedIntentionItemType.intentionItemTypeSubType isEqualToString:NSLocalizedString(@"Goal Item", @"Goal Item")]) {
        COGoalItemDetailViewController *goalItemDetailViewController = [[COGoalItemDetailViewController alloc] initForNewItem:NO];
        COGoalItem *selectedGoalItem = (COGoalItem *) selectedIntentionItemType;
        goalItemDetailViewController.m_GoalItem = selectedGoalItem;
        [self pushDetailViewOntoNavigationController:goalItemDetailViewController];
    }
}

// =================================================================================================================
#pragma mark - UIViewControllerRestoration Protocol Methods
// =================================================================================================================

+ (UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    // The single COIntentionItemTypeViewController instance was re-created by the AppDelegate when the TabBarController structure was recreated.
    // We just need to pass a pointer the that object back to the caller.
    COAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
    COIntentionItemTypeViewController *intentionItemTypeViewController = ((UINavigationController *)(tabBarController.viewControllers[kCOIntentionItemTypeViewControllerPosition])).viewControllers[0];
    
    return intentionItemTypeViewController;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    BOOL isEditing = self.isEditing;
    [coder encodeBool:isEditing forKey:@"TableViewIsEditing"];
    [super encodeRestorableStateWithCoder:coder];
}

// -----------------------------------------------------------------------------------------------------------------

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    BOOL isEditing = [coder decodeBoolForKey:@"TableViewIsEditing"];
    self.editing = isEditing;
    [super decodeRestorableStateWithCoder:coder];
}

// =================================================================================================================
#pragma mark - UIDataSourceModelAssociation
// =================================================================================================================

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)path inView:(UIView *)view
{
    NSString *identifier = nil;
    
    if (path && view) {
        // Return an identifier of the given NSIndexPath, in case next time the data source changes
        COIntentionItemType *intentionItemType = [[COIntentionItemTypeStore sharedIntentionItemTypeStore] allIntentionItemTypes][path.row];
        identifier = intentionItemType.intentionItemTypeKey;
    }
    return identifier;
}

// -----------------------------------------------------------------------------------------------------------------

- (NSIndexPath *) indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
    NSIndexPath *indexPath = nil;
    
    if (identifier && view) {
        NSArray *intentionItemTypes = [[COIntentionItemTypeStore sharedIntentionItemTypeStore] allIntentionItemTypes];
        for (COIntentionItemType *item in intentionItemTypes) {
            if ([identifier isEqualToString:item.intentionItemTypeKey]) {
                NSUInteger row = [intentionItemTypes indexOfObjectIdenticalTo:item];
                indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                break;
            }
        }
    }
    return indexPath;
}


@end
