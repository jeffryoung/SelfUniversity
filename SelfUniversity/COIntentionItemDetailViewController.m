// =================================================================================================================
//
//  COIntentionItemDetailViewController.m
//  iLearn University
//
//  Created by Jeffrey Young on 9/21/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COIntentionItemDetailViewController.h"
#import "COIntentionItem.h"
#import "COIntentionItemStore.h"

@interface COIntentionItemDetailViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;


@property (weak, nonatomic) IBOutlet UITextField *intentionNameField;
@property (weak, nonatomic) IBOutlet UITextView *intentionDescriptionField;
@property (weak, nonatomic) IBOutlet UITextView *contributionField;
@property (weak, nonatomic) IBOutlet UITextField *outcome1Field;
@property (weak, nonatomic) IBOutlet UITextField *outcome2Field;
@property (weak, nonatomic) IBOutlet UITextField *outcome3Field;
@property (weak, nonatomic) IBOutlet UITextField *outcome4Field;
@property (weak, nonatomic) IBOutlet UITextField *outcome5Field;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;

@property (nonatomic) BOOL m_bIsNew;
@property (nonatomic) BOOL m_bKeyboardIsBeingShown;
@property (nonatomic) BOOL m_bUserCancelledNewIntentionItem;
@property (nonatomic) float m_CurrentKeyboardHeight;
@property (nonatomic) UIEdgeInsets m_OriginalUIEdgeInsets;
@property (nonatomic) UITextField *m_ActiveTextField;
@property (nonatomic) UITextView *m_ActiveTextView;

@end

@implementation COIntentionItemDetailViewController

// =================================================================================================================
#pragma mark - Object Methods
// =================================================================================================================

- (instancetype) initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.m_bIsNew = isNew;
        self.m_bKeyboardIsBeingShown = NO;
        self.m_bUserCancelledNewIntentionItem = NO;
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
        
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
        self.m_CurrentKeyboardHeight = UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) ? kbSize.width : kbSize.height;
        
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
// Load the form with data from the selected intention item

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize contentSize = self.contentView.frame.size;
    
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    
    self.scrollView.contentSize = contentSize;
    self.scrollView.contentOffset = CGPointMake(0.0, 0.0-(statusBarFrame.size.height + navBarFrame.size.height));
    
    // Set contentInset on the scrollView only if we are creating a new intention item on an iPhone.
    if (self.m_bIsNew && ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)) {
        UIEdgeInsets scrollViewInset = UIEdgeInsetsMake(statusBarFrame.size.height + navBarFrame.size.height, 0.0, 0.0, 0.0);
        self.scrollView.contentInset = scrollViewInset;
    }
    
    COIntentionItem *intentionItem = self.m_IntentionItem;
    
    if (self.m_bIsNew) {
        self.title = self.m_nIntentionTypeTitle;
    } else {
        self.title = intentionItem.intentionItemTypeName;
    }
    
    // Place the data from the intentionItem into the fields on the detail view.
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
    self.dateCreatedLabel.text = [dateFormatter stringFromDate:intentionItem.intentionItemTypeDateCreated];
}

// -----------------------------------------------------------------------------------------------------------------
// Put the data on the form back into the intentionItem member variable.

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (!self.m_bUserCancelledNewIntentionItem) {
        
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
    
    // Clear us as being the first responder
    [self.view endEditing:YES];
}

// -----------------------------------------------------------------------------------------------------------------

- (void) setIntentionItem:(COIntentionItem *)intentionItem
{
    _m_IntentionItem = intentionItem;
    self.navigationItem.title = intentionItem.intentionItemTypeName;
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
    [[COIntentionItemStore sharedIntentionItemStore] removeIntentionItem:self.m_IntentionItem];
    self.m_bUserCancelledNewIntentionItem = YES;
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.m_DismissBlock];
}

// =================================================================================================================
#pragma mark - UIViewControllerRestoration Protocol Methods
// =================================================================================================================

+ (UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    BOOL isNew = NO;
    if ([identifierComponents count] == 3) {
        isNew = YES;
    }
    return [[self alloc] initForNewItem:isNew];
}

@end
