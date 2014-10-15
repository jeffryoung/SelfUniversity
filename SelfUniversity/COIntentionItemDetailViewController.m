// =================================================================================================================
//
//  COIntentionItemDetailViewController.m
//  iLearn University
//
//  Created by Jeffrey Young on 9/21/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COGlobalDefsConstants.h"
#import "COAppDelegate.h"
#import "COIntentionItemTypeViewController.h"
#import "COIntentionItemDetailViewController.h"
#import "COIntentionItem.h"
#import "COIntentionItemTypeStore.h"
#import "COIntentionItemHelpViewController.h"

@interface COIntentionItemDetailViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *helpButton;

@property (weak, nonatomic) IBOutlet UIImageView *intentionItemTypeLogo;

@property (weak, nonatomic) IBOutlet UITextField *intentionNameField;
@property (weak, nonatomic) IBOutlet UITextView *intentionDescriptionField;
@property (weak, nonatomic) IBOutlet UITextView *contributionField;
@property (weak, nonatomic) IBOutlet UITextField *outcome1Field;
@property (weak, nonatomic) IBOutlet UITextField *outcome2Field;
@property (weak, nonatomic) IBOutlet UITextField *outcome3Field;
@property (weak, nonatomic) IBOutlet UITextField *outcome4Field;
@property (weak, nonatomic) IBOutlet UITextField *outcome5Field;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedField;

@property (weak, nonatomic) IBOutlet UILabel *intentionQuestionLabel;
@property (weak, nonatomic) IBOutlet UILabel *intentionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *intentionDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *contributionLabel;
@property (weak, nonatomic) IBOutlet UILabel *outcomeQuestionLabel;
@property (weak, nonatomic) IBOutlet UILabel *outcome1Label;
@property (weak, nonatomic) IBOutlet UILabel *outcome2Label;
@property (weak, nonatomic) IBOutlet UILabel *outcome3Label;
@property (weak, nonatomic) IBOutlet UILabel *outcome4Label;
@property (weak, nonatomic) IBOutlet UILabel *outcome5Label;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;

@end

@implementation COIntentionItemDetailViewController

// =================================================================================================================
#pragma mark - Object Methods
// =================================================================================================================

- (instancetype) initForNewItem:(BOOL)isNew
{
    self = [super initForNewItem:isNew];
    
    if (self)
    {
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
// Load the form with data from the selected intention item

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    COIntentionItem *intentionItem = self.m_IntentionItem;
    
    // Set the title on the view controller
    if (self.m_bIsNew) {
        self.title = self.m_tIntentionItemTypeControllerTitle;
    } else {
        self.title = intentionItem.intentionItemTypeName;
    }
    
   // Load the array of field transitions for the keyboard Next button.
    self.m_FieldTransitions = @[self.intentionNameField, self.intentionDescriptionField, self.contributionField, self.outcome1Field, self.outcome2Field, self.outcome3Field, self.outcome4Field, self.outcome5Field];
    
    [self loadTextFieldsFromIntentionItem];

}

// -----------------------------------------------------------------------------------------------------------------

- (void) setIntentionItem:(COIntentionItem *)intentionItem
{
    _m_IntentionItem = intentionItem;
    self.navigationItem.title = intentionItem.intentionItemTypeName;
}

// -----------------------------------------------------------------------------------------------------------------

- (void) loadTextFieldsFromIntentionItem
{
    COIntentionItem *intentionItem = self.m_IntentionItem;

    // Place the data from the intentionItem into the fields on the detail view.
    self.intentionItemTypeLogo.image = [UIImage imageNamed:@"IntentionItemIcon.png"];
    self.intentionNameField.text = intentionItem.intentionItemTypeName;
    self.intentionDescriptionField.text = intentionItem.intentionItemTypeDescription;
    self.contributionField.text = intentionItem.intentionItemContribution;
    self.outcome1Field.text = intentionItem.intentionItemOutcome1;
    self.outcome2Field.text = intentionItem.intentionItemOutcome2;
    self.outcome3Field.text = intentionItem.intentionItemOutcome3;
    self.outcome4Field.text = intentionItem.intentionItemOutcome4;
    self.outcome5Field.text = intentionItem.intentionItemOutcome5;
    
    // Format the date into a simle date string and put the date on the detail view.
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    self.dateCreatedField.text = [dateFormatter stringFromDate:intentionItem.intentionItemTypeDateCreated];
}

// -----------------------------------------------------------------------------------------------------------------

- (IBAction)displayHelpViewController:(id)sender
{
    COIntentionItemHelpViewController *intentionItemHelpViewController = [[COIntentionItemHelpViewController alloc] init];
    [self.navigationController pushViewController:intentionItemHelpViewController animated:YES];
    
}

// =================================================================================================================
#pragma mark - COIntentionItemTypeDetailView Protocol Methods
// =================================================================================================================

- (void) saveTextFieldsIntoIntentionItemType
{
    // Save any changes back into the intentionItem
    COIntentionItem *intentionItem = self.m_IntentionItem;
    intentionItem.intentionItemTypeName = self.intentionNameField.text;
    intentionItem.intentionItemTypeDescription = self.intentionDescriptionField.text;
    intentionItem.intentionItemContribution = self.contributionField.text;
    intentionItem.intentionItemOutcome1 = self.outcome1Field.text;
    intentionItem.intentionItemOutcome2 = self.outcome2Field.text;
    intentionItem.intentionItemOutcome3 = self.outcome3Field.text;
    intentionItem.intentionItemOutcome4 = self.outcome4Field.text;
    intentionItem.intentionItemOutcome5 = self.outcome5Field.text;
}

// -----------------------------------------------------------------------------------------------------------------
- (void) removeCurrentIntentionItemType
{
    [[COIntentionItemTypeStore sharedIntentionItemTypeStore] removeIntentionItemType:self.m_IntentionItem];
}

// =================================================================================================================
#pragma mark - UIViewControllerRestoration Protocol Methods
// =================================================================================================================

+ (UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    COIntentionItemDetailViewController *restoredViewController = [[self alloc] initForNewItem:NO];
    
    return restoredViewController;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [self saveTextFieldsIntoIntentionItemType];
    [[COIntentionItemTypeStore sharedIntentionItemTypeStore] saveChanges];
    
    [coder encodeObject:self.m_IntentionItem.intentionItemTypeKey forKey:@"intentionItemTypeKey"];
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
            self.m_IntentionItem = (COIntentionItem *)intentionItemType;
            break;
        }
    }
    
    self.m_tIntentionItemTypeControllerTitle = [coder decodeObjectForKey:@"intentionItemDetailControllerTitle"];
    self.m_bIsNew = [coder decodeBoolForKey:@"intentionItemIsNew"];
    
    [super decodeRestorableStateWithCoder:coder];
    
    // If we were entering a new intentionItem, then reach back to the intentionItemTypeViewController and tell it to show the detail view controller modally.
    if (self.m_bIsNew) {
        COAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
        COIntentionItemTypeViewController *intentionItemTypeViewController = ((UINavigationController *)(tabBarController.viewControllers[kCOIntentionItemTypeViewControllerPosition])).viewControllers[0];
        [intentionItemTypeViewController registerToPresentDetailViewControllerModally:self];
    }
}

@end
