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
#import "COString.h"

@interface COGoalItemDetailViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITextField *intentionNameField;
@property (weak, nonatomic) IBOutlet UITextView *intentionDescriptionField;
@property (weak, nonatomic) IBOutlet UITextView *goalItemRewardField;
@property (weak, nonatomic) IBOutlet UITextField *goalItemTargetDateField;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;

@property (nonatomic) BOOL m_bIsNew;
@property (nonatomic) BOOL m_bKeyboardIsBeingShown;
@property (nonatomic) BOOL m_bUserCancelledNewGoalItem;
@property (nonatomic) float m_CurrentKeyboardHeight;
@property (nonatomic) UIEdgeInsets m_OriginalUIEdgeInsets;
@property (nonatomic) UITextField *m_ActiveTextField;
@property (nonatomic) UITextView *m_ActiveTextView;

@end

@implementation COGoalItemDetailViewController

// =================================================================================================================
#pragma mark - Object Methods
// =================================================================================================================

- (instancetype) initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        // Initialize member state variables
        self.m_bIsNew = isNew;
        self.m_bKeyboardIsBeingShown = NO;
        self.m_bUserCancelledNewGoalItem = NO;
        
        // Register to be notified when the keyboard is displayed and when it goes away.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        
        // Set the restoration identifier for this view controller.
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    }
    return self;
}

// -----------------------------------------------------------------------------------------------------------------

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem:" userInfo:nil];
    return nil;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.contentView];
}

// -----------------------------------------------------------------------------------------------------------------

- (void)viewDidUnload
{
    self.contentView = nil;
    [super viewDidUnload];
}

// -----------------------------------------------------------------------------------------------------------------
// When the keyboard is shown, then we might need to scroll the view up to see the current field if they keyboard
// covered it up.

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    if (!self.m_bKeyboardIsBeingShown) {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        self.m_CurrentKeyboardHeight = kbSize.height;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        CGRect visibleFrameRect = self.scrollView.frame;
        visibleFrameRect.size.height -= self.m_CurrentKeyboardHeight;
        
        // Get the activeFrameRect, depending upon whether the user is editing one of the text fields or text views.
        CGRect activeFrameRect = CGRectNull;
        if (self.m_ActiveTextField != nil) {
            activeFrameRect = self.m_ActiveTextField.frame;
        } else if (self.m_ActiveTextView != nil) {
            activeFrameRect = self.m_ActiveTextView.frame;
        } else {
            return;
        }
        
        // Set the insets to allow proper scrolling with the keyboard in view
        // If the activeFrameRect is covered up by the keyboard, then scroll it into view.
        self.m_OriginalUIEdgeInsets = self.scrollView.contentInset;
        UIEdgeInsets newContentInsets = self.scrollView.contentInset;
        if (self.m_OriginalUIEdgeInsets.bottom < self.m_CurrentKeyboardHeight) {
            newContentInsets.bottom = self.m_CurrentKeyboardHeight;
        }
        
        self.scrollView.contentInset = newContentInsets;
        self.scrollView.scrollIndicatorInsets = newContentInsets;
        
        if (!CGRectContainsRect(visibleFrameRect, activeFrameRect) ) {
            [self.scrollView scrollRectToVisible:activeFrameRect animated:YES];
        }
        
        self.m_bKeyboardIsBeingShown = YES;
    }
}

// -----------------------------------------------------------------------------------------------------------------
// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    self.m_CurrentKeyboardHeight = 0.0;
    self.scrollView.contentInset = self.m_OriginalUIEdgeInsets;
    self.scrollView.scrollIndicatorInsets = self.m_OriginalUIEdgeInsets;
    self.m_bKeyboardIsBeingShown = NO;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.m_ActiveTextField = textField;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.m_ActiveTextField = nil;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.m_ActiveTextView = textView;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.m_ActiveTextView = nil;
}

// -----------------------------------------------------------------------------------------------------------------
// Load the form with data from the selected goal item

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize contentSize = self.contentView.frame.size;
    
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    
    self.scrollView.contentSize = contentSize;
    
    // Set contentInset on the scrollView only if we are creating a new goal item on an iPhone.
    if (self.m_bIsNew && ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)) {
        self.scrollView.contentOffset = CGPointMake(0.0, 0.0-(statusBarFrame.size.height + navBarFrame.size.height));
        UIEdgeInsets scrollViewInset = UIEdgeInsetsMake(statusBarFrame.size.height + navBarFrame.size.height, 0.0, 0.0, 0.0);
        self.scrollView.contentInset = scrollViewInset;
    }
    
    COGoalItem *goalItem = self.m_GoalItem;
    
    // Set the title on the view controller
    if (self.m_bIsNew) {
        self.title = self.m_tGoalTitle;
    } else {
        self.title = goalItem.intentionItemTypeName;
    }
    
    // Create and set Cancel and Done buttons on the navigation controller if this is for a new goal item and we haven't created
    // the navigation controller buttons already...
    if (self.m_bIsNew && (self.navigationItem.rightBarButtonItem == nil)) {
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
        self.navigationItem.rightBarButtonItem = doneItem;
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        self.navigationItem.leftBarButtonItem = cancelItem;
    }
    
    // Place the data from the intentionItem into the fields on the detail view.
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
    self.dateCreatedLabel.text = [dateFormatter stringFromDate:goalItem.intentionItemTypeDateCreated];
    
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
// Put the data on the form back into the intentionItem member variable.

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (!self.m_bUserCancelledNewGoalItem) {
        [self saveTextFieldsIntoGoalItem];
        [[COIntentionItemTypeStore sharedIntentionItemTypeStore] saveChanges];
    }
    
    // Clear us as being the first responder
    [self.view endEditing:YES];
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

- (void) save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.m_DismissBlock];
}

// -----------------------------------------------------------------------------------------------------------------

- (void) cancel:(id)sender
{
    // The user cancelled, then we need to remove the new intention item from the store
    [[COIntentionItemTypeStore sharedIntentionItemTypeStore] removeIntentionItemType:self.m_GoalItem];
    self.m_bUserCancelledNewGoalItem = YES;
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.m_DismissBlock];
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

- (void) saveTextFieldsIntoGoalItem
{
    // Save any changes back into the intentionItem
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
    [self saveTextFieldsIntoGoalItem];
    [[COIntentionItemTypeStore sharedIntentionItemTypeStore] saveChanges];
    
    [coder encodeObject:self.m_GoalItem.intentionItemTypeKey forKey:@"intentionItemTypeKey"];
    [coder encodeObject:self.m_tGoalTitle forKey:@"intentionItemTitle"];
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
    
    self.m_tGoalTitle = [coder decodeObjectForKey:@"intentionItemTitle"];
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
