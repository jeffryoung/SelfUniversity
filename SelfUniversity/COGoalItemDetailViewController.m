// =================================================================================================================
//
//  COGoalItemDetailViewController.m
//  iLearn University
//
//  Created by Jeffrey Young on 9/21/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COGlobalDefsConstants.h"
#import "COAppDelegate.h"
#import "COIntentionItemTypeViewController.h"
#import "COGoalItemDetailViewController.h"
#import "COGoalItem.h"
#import "COIntentionItemTypeStore.h"
#import "COGoalITemHelpViewController.h"

@interface COGoalItemDetailViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *intentionItemTypeLogo;

@property (weak, nonatomic) IBOutlet UITextField *intentionNameField;
@property (weak, nonatomic) IBOutlet UITextView *intentionDescriptionField;
@property (weak, nonatomic) IBOutlet UITextView *goalItemRewardField;
@property (weak, nonatomic) IBOutlet UITextField *goalItemTargetDateField;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedField;

@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;

@end

@implementation COGoalItemDetailViewController

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
    
    COGoalItem *goalItem = self.m_GoalItem;
    
    // Set the title on the view controller
    if (self.m_bIsNew) {
        self.title = self.m_tIntentionItemTypeControllerTitle;
    } else {
        self.title = goalItem.intentionItemTypeName;
    }
    
    // Load the array of field transitions for the Next button.
    self.m_FieldTransitions = @[self.intentionNameField, self.intentionDescriptionField, self.goalItemRewardField, self.goalItemTargetDateField];
    
    [self loadTextFieldsFromGoalItem];
    
}

// =================================================================================================================
#pragma mark - Selector Methods
// =================================================================================================================


- (void) setGoalItem:(COGoalItem *)goalItem
{
    _m_GoalItem = goalItem;
    self.navigationItem.title = goalItem.intentionItemTypeName;
}

// -----------------------------------------------------------------------------------------------------------------

- (void) loadTextFieldsFromGoalItem
{
    COGoalItem *goalItem = self.m_GoalItem;
    
    // Place the data from the intentionItem into the fields on the detail view.
    self.intentionItemTypeLogo.image = [UIImage imageNamed:@"GoalItemIcon.png"];
    self.intentionNameField.text = goalItem.intentionItemTypeName;
    self.intentionDescriptionField.text = goalItem.intentionItemTypeDescription;
    self.goalItemRewardField.text = goalItem.goalItemReward;
    
    // Format Target Date and Date Created into simple date strings and put the dates on the detail view.
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    self.goalItemTargetDateField.text = [dateFormatter stringFromDate:goalItem.goalItemTargetDate];
    self.dateCreatedField.text = [dateFormatter stringFromDate:goalItem.intentionItemTypeDateCreated];
    
    // Set up a Date Picker to be used when the user wants to edit the goalItemTargetDate.
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.minimumDate = [NSDate date];
    if (goalItem.goalItemTargetDate == nil) {
        goalItem.goalItemTargetDate = [NSDate date];
    }
    [datePicker setDate:goalItem.goalItemTargetDate];
    [datePicker addTarget:self action:@selector(updateGoalItemTargetDateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.goalItemTargetDateField setInputView:datePicker];

}

// -----------------------------------------------------------------------------------------------------------------

- (void) updateGoalItemTargetDateTextField:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker*)self.goalItemTargetDateField.inputView;
    
    // Format Target Date and Date Created into simple date strings and put the dates into the text field.
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    self.goalItemTargetDateField.text = [dateFormatter stringFromDate:datePicker.date];

}

// -----------------------------------------------------------------------------------------------------------------

- (void) saveTextFieldsIntoIntentionItemType
{
    // Save any changes back into the goalItem
    COGoalItem *goalItem = self.m_GoalItem;
    goalItem.intentionItemTypeName = self.intentionNameField.text;
    goalItem.intentionItemTypeDescription = self.intentionDescriptionField.text;
    goalItem.goalItemReward = self.goalItemRewardField.text;
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    goalItem.goalItemTargetDate = [dateFormatter dateFromString:self.goalItemTargetDateField.text];
}

// -----------------------------------------------------------------------------------------------------------------
- (void) removeCurrentIntentionItemType
{
    [[COIntentionItemTypeStore sharedIntentionItemTypeStore] removeIntentionItemType:self.m_GoalItem];
}

// -----------------------------------------------------------------------------------------------------------------

- (IBAction)displayHelpViewController:(id)sender
{
    COGoalItemHelpViewController *goalItemHelpViewController = [[COGoalItemHelpViewController alloc] init];
    [self.navigationController pushViewController:goalItemHelpViewController animated:YES];
    
}

// =================================================================================================================
#pragma mark - UIViewControllerRestoration Protocol Methods
// =================================================================================================================

+ (UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    COGoalItemDetailViewController *restoredViewController = [[self alloc] initForNewItem:NO];
    
    return restoredViewController;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [self saveTextFieldsIntoIntentionItemType];
    [[COIntentionItemTypeStore sharedIntentionItemTypeStore] saveChanges];
    
    [coder encodeObject:self.m_GoalItem.intentionItemTypeKey forKey:@"intentionItemTypeKey"];
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
            self.m_GoalItem = (COGoalItem *)intentionItemType;
            break;
        }
    }
    
    self.m_tIntentionItemTypeControllerTitle = [coder decodeObjectForKey:@"intentionItemDetailControllerTitle"];
    self.m_bIsNew = [coder decodeBoolForKey:@"intentionItemIsNew"];
    
    [super decodeRestorableStateWithCoder:coder];
    
    // If we were entering a new goalItem, then reach back to the intentionItemTypeViewController and tell it to show the detail view controller modally.
    if (self.m_bIsNew) {
        COAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
        COIntentionItemTypeViewController *intentionItemTypeViewController = ((UINavigationController *)(tabBarController.viewControllers[kCOIntentionItemTypeViewControllerPosition])).viewControllers[0];
        [intentionItemTypeViewController registerToPresentDetailViewControllerModally:self];
    }
}

@end
