// =================================================================================================================
//
//  COProductStoryItemDetailViewController.m
//  iLearn University
//
//  Created by Jeffrey Young on 10/20/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COGlobalDefsConstants.h"
#import "COAppDelegate.h"
#import "COIntentionItemTypeViewController.h"
#import "COProductStoryItemDetailViewController.h"
#import "COProductStoryItem.h"
#import "COIntentionItemTypeStore.h"
#import "COProductStoryItemHelpViewController.h"

@interface COProductStoryItemDetailViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *intentionItemTypeLogo;

@property (weak, nonatomic) IBOutlet UITextField *intentionNameField;
@property (weak, nonatomic) IBOutlet UITextView *intentionDescriptionField;
@property (weak, nonatomic) IBOutlet UITextField *productStoryItemUserRoleField;
@property (weak, nonatomic) IBOutlet UITextField *productStoryItemGoalField;
@property (weak, nonatomic) IBOutlet UITextField *productStoryItemBenefitField;
@property (weak, nonatomic) IBOutlet UITextField *productStoryItemSizeField;
@property (weak, nonatomic) IBOutlet UITextField *productStoryItemParentField;
@property (weak, nonatomic) IBOutlet UITextField *productStoryItemConditionsOfSatisfaction1Field;
@property (weak, nonatomic) IBOutlet UITextField *productStoryItemConditionsOfSatisfaction2Field;
@property (weak, nonatomic) IBOutlet UITextField *productStoryItemConditionsOfSatisfaction3Field;
@property (weak, nonatomic) IBOutlet UITextField *productStoryItemConditionsOfSatisfaction4Field;
@property (weak, nonatomic) IBOutlet UITextField *productStoryItemConditionsOfSatisfaction5Field;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedField;

@end

@implementation COProductStoryItemDetailViewController

// =================================================================================================================
#pragma mark - Object Methods
// =================================================================================================================

- (instancetype) initForNewItem:(BOOL)isNew
{
    self = [super initForNewItem:isNew];
    
    if (self) {
        // Connect the IBOutlets scrollView and contentView to the super class so the super class can use them
        self.m_pScrollView = self.scrollView;
        self.m_pContentView = self.contentView;
        
        // Set the restoration identifier for this view controller.
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    }
    return self;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)viewDidLoad
{
    // Connect the IBOutlets scrollView and contentView to the super class so the super class can use them
    self.m_pScrollView = self.scrollView;
    self.m_pContentView = self.contentView;
    
    [super viewDidLoad];
}

// -----------------------------------------------------------------------------------------------------------------
// Load the form with data from the selected goal item

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    COProductStoryItem *productStoryItem = self.m_ProductStoryItem;
    
    // Set the title on the view controller
    if (self.m_bIsNew) {
        self.title = self.m_tIntentionItemTypeControllerTitle;
    } else {
        self.title = productStoryItem.intentionItemTypeName;
    }
    
    // Load the array of field transitions for the Next button.
    self.m_FieldTransitions = @[self.intentionNameField,
                                self.intentionDescriptionField,
                                self.productStoryItemUserRoleField,
                                self.productStoryItemGoalField,
                                self.productStoryItemBenefitField,
                                self.productStoryItemSizeField,
                                self.productStoryItemParentField,
                                self.productStoryItemConditionsOfSatisfaction1Field,
                                self.productStoryItemConditionsOfSatisfaction2Field,
                                self.productStoryItemConditionsOfSatisfaction3Field,
                                self.productStoryItemConditionsOfSatisfaction4Field,
                                self.productStoryItemConditionsOfSatisfaction5Field];
    
    [self loadTextFieldsFromProductStoryItem];
    
}

// =================================================================================================================
#pragma mark - Selector Methods
// =================================================================================================================


- (void) setProductStoryItem:(COProductStoryItem *)productStoryItem
{
    _m_ProductStoryItem = productStoryItem;
    self.navigationItem.title = productStoryItem.intentionItemTypeName;
}

// -----------------------------------------------------------------------------------------------------------------

- (void) loadTextFieldsFromProductStoryItem
{
    COProductStoryItem *productStoryItem = self.m_ProductStoryItem;
    
    // Place the data from the intentionItem into the fields on the detail view.
    self.intentionItemTypeLogo.image = [UIImage imageNamed:@"ProductStoryItemIcon.png"];
    self.intentionNameField.text = productStoryItem.intentionItemTypeName;
    self.intentionDescriptionField.text = productStoryItem.intentionItemTypeDescription;
    self.productStoryItemUserRoleField.text = productStoryItem.productStoryItemUserRole;
    self.productStoryItemGoalField.text = productStoryItem.productStoryItemGoal;
    self.productStoryItemBenefitField.text = productStoryItem.productStoryItemBenefit;
    self.productStoryItemSizeField.text = productStoryItem.productStoryItemSize;
    self.productStoryItemParentField.text = productStoryItem.productStoryItemParent;
    self.productStoryItemConditionsOfSatisfaction1Field.text = productStoryItem.productStoryItemConditionsOfSatisfaction1;
    self.productStoryItemConditionsOfSatisfaction2Field.text = productStoryItem.productStoryItemConditionsOfSatisfaction2;
    self.productStoryItemConditionsOfSatisfaction3Field.text = productStoryItem.productStoryItemConditionsOfSatisfaction3;
    self.productStoryItemConditionsOfSatisfaction4Field.text = productStoryItem.productStoryItemConditionsOfSatisfaction4;
    self.productStoryItemConditionsOfSatisfaction5Field.text = productStoryItem.productStoryItemConditionsOfSatisfaction5;
    
    // Format Target Date and Date Created into simple date strings and put the dates on the detail view.
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    self.dateCreatedField.text = [dateFormatter stringFromDate:productStoryItem.intentionItemTypeDateCreated];
    
}

// -----------------------------------------------------------------------------------------------------------------

- (void) saveTextFieldsIntoIntentionItemType
{
    // Save any changes back into the productStoryItem
    COProductStoryItem *productStoryItem = self.m_ProductStoryItem;
    productStoryItem.intentionItemTypeName = self.intentionNameField.text;
    productStoryItem.intentionItemTypeDescription = self.intentionDescriptionField.text;
    productStoryItem.productStoryItemUserRole = self.productStoryItemUserRoleField.text;
    productStoryItem.productStoryItemGoal = self.productStoryItemGoalField.text;
    productStoryItem.productStoryItemBenefit = self.productStoryItemBenefitField.text;
    productStoryItem.productStoryItemSize = self.productStoryItemSizeField.text;
    productStoryItem.productStoryItemParent = self.productStoryItemParentField.text;
    productStoryItem.productStoryItemConditionsOfSatisfaction1 = self.productStoryItemConditionsOfSatisfaction1Field.text;
    productStoryItem.productStoryItemConditionsOfSatisfaction2 = self.productStoryItemConditionsOfSatisfaction2Field.text;
    productStoryItem.productStoryItemConditionsOfSatisfaction3 = self.productStoryItemConditionsOfSatisfaction3Field.text;
    productStoryItem.productStoryItemConditionsOfSatisfaction4 = self.productStoryItemConditionsOfSatisfaction4Field.text;
    productStoryItem.productStoryItemConditionsOfSatisfaction5 = self.productStoryItemConditionsOfSatisfaction5Field.text;
}

// -----------------------------------------------------------------------------------------------------------------
- (void) removeCurrentIntentionItemType
{
    [[COIntentionItemTypeStore sharedIntentionItemTypeStore] removeIntentionItemType:self.m_ProductStoryItem];
}

// -----------------------------------------------------------------------------------------------------------------

- (IBAction)displayHelpViewController:(id)sender
{
    COProductStoryItemHelpViewController *productStoryItemHelpViewController = [[COProductStoryItemHelpViewController alloc] init];
    [self.navigationController pushViewController:productStoryItemHelpViewController animated:YES];
    
}

// =================================================================================================================
#pragma mark - UIViewControllerRestoration Protocol Methods
// =================================================================================================================

+ (UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    COProductStoryItemDetailViewController *restoredViewController = [[self alloc] initForNewItem:NO];
    
    return restoredViewController;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [self saveTextFieldsIntoIntentionItemType];
    [[COIntentionItemTypeStore sharedIntentionItemTypeStore] saveChanges];
    
    [coder encodeObject:self.m_ProductStoryItem.intentionItemTypeKey forKey:@"intentionItemTypeKey"];
    [coder encodeObject:self.m_tIntentionItemTypeControllerTitle forKey:@"intentionItemDetailControllerTitle"];
    [coder encodeBool:self.m_bIsNew forKey:@"intentionItemIsNew"];
    [super encodeRestorableStateWithCoder:coder];
}

// -----------------------------------------------------------------------------------------------------------------

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSString *intentionItemTypeKey = [coder decodeObjectForKey:@"intentionItemTypeKey"];

    for (COIntentionItemType *intentionItemType in [[COIntentionItemTypeStore sharedIntentionItemTypeStore] allIntentionItemTypes]) {
        if ([intentionItemTypeKey isEqualToString:intentionItemType.intentionItemTypeKey]) {
            self.m_ProductStoryItem = (COProductStoryItem *)intentionItemType;
            break;
        }
    }
    
    self.m_tIntentionItemTypeControllerTitle = [coder decodeObjectForKey:@"intentionItemDetailControllerTitle"];
    self.m_bIsNew = [coder decodeBoolForKey:@"intentionItemIsNew"];
    
    [super decodeRestorableStateWithCoder:coder];
    
    // If we were entering a new productStoryItem, then reach back to the intentionItemTypeViewController and tell it to show the detail view controller modally.
    if (self.m_bIsNew) {
        COAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
        COIntentionItemTypeViewController *intentionItemTypeViewController = ((UINavigationController *)(tabBarController.viewControllers[kCOIntentionItemTypeViewControllerPosition])).viewControllers[0];
        [intentionItemTypeViewController registerToPresentDetailViewControllerModally:self];
    }
}

@end
