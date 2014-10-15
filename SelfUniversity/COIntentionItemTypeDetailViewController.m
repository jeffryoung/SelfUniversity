// =================================================================================================================
//
//  COIntentionItemTypeDetailViewController.m
//  iLearn University
//
//  Created by Jeffrey Young on 10/14/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COIntentionItemTypeDetailViewController.h"
#import "COGlobalDefsConstants.h"
#import "COAppDelegate.h"
#import "COIntentionItemTypeViewController.h"
#import "COIntentionItem.h"
#import "COIntentionItemTypeStore.h"
#import "COIntentionItemHelpViewController.h"

@interface COIntentionItemTypeDetailViewController ()

@property (nonatomic) BOOL m_bKeyboardIsBeingShown;
@property (nonatomic) BOOL m_bUserCancelledNewIntentionItem;
@property (nonatomic) float m_CurrentKeyboardHeight;
@property (nonatomic) UIEdgeInsets m_OriginalUIEdgeInsets;
@property (nonatomic) UITextField *m_ActiveTextField;
@property (nonatomic) UITextView *m_ActiveTextView;

@end

@implementation COIntentionItemTypeDetailViewController

// =================================================================================================================
#pragma mark - Initialization Methods
// =================================================================================================================


- (instancetype) initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.m_bIsNew = isNew;
        self.m_bKeyboardIsBeingShown = NO;
        self.m_bUserCancelledNewIntentionItem = NO;
        
        // Register to be notified when the keyboard is displayed and when it goes away.
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
        [defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    [self.view addSubview:self.m_pContentView];
}

// -----------------------------------------------------------------------------------------------------------------

- (void)viewDidUnload
{
    self.m_pContentView = nil;
    [super viewDidUnload];
}

// -----------------------------------------------------------------------------------------------------------------
// Load the form with data from the selected intention item

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize contentSize = self.m_pContentView.frame.size;
    
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    
    self.m_pScrollView.contentSize = contentSize;
    
    // Set contentOffset and contentInset on the scrollView only if we are creating a new intention item on an iPhone.
    if (self.m_bIsNew && ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)) {
        self.m_pScrollView.contentOffset = CGPointMake(0.0, 0.0-(statusBarFrame.size.height + navBarFrame.size.height));
        UIEdgeInsets scrollViewInset = UIEdgeInsetsMake(statusBarFrame.size.height + navBarFrame.size.height, 0.0, 0.0, 0.0);
        self.m_pScrollView.contentInset = scrollViewInset;
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
    
}

// -----------------------------------------------------------------------------------------------------------------
// Put the data on the form back into the intentionItem member variable.

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (!self.m_bUserCancelledNewIntentionItem) {
        [self saveTextFieldsIntoIntentionItemType]; 
    }
    
    // Clear us as being the first responder
    [self.view endEditing:YES];
}

// -----------------------------------------------------------------------------------------------------------------

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// =================================================================================================================
#pragma mark - Keyboard handling methods
// =================================================================================================================


// When the keyboard is shown, then we might need to scroll the view up to see the current field if they keyboard
// covered it up.

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    if (!self.m_bKeyboardIsBeingShown) {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        self.m_CurrentKeyboardHeight = kbSize.height;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        CGRect visibleFrameRect = self.m_pScrollView.frame;
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
        self.m_OriginalUIEdgeInsets = self.m_pScrollView.contentInset;
        UIEdgeInsets newContentInsets = self.m_pScrollView.contentInset;
        if (self.m_OriginalUIEdgeInsets.bottom < self.m_CurrentKeyboardHeight) {
            newContentInsets.bottom = self.m_CurrentKeyboardHeight;
        }
        
        self.m_pScrollView.contentInset = newContentInsets;
        self.m_pScrollView.scrollIndicatorInsets = newContentInsets;
        
        if (!CGRectContainsRect(visibleFrameRect, activeFrameRect) ) {
            [self.m_pScrollView scrollRectToVisible:activeFrameRect animated:YES];
        }
        
        self.m_bKeyboardIsBeingShown = YES;
    }
}

// -----------------------------------------------------------------------------------------------------------------
// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    self.m_CurrentKeyboardHeight = 0.0;
    self.m_pScrollView.contentInset = self.m_OriginalUIEdgeInsets;
    self.m_pScrollView.scrollIndicatorInsets = self.m_OriginalUIEdgeInsets;
    self.m_bKeyboardIsBeingShown = NO;
}

// =================================================================================================================
#pragma mark - Text Field and View Handling Methods
// =================================================================================================================

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Get the field that we should be editing next, if any...
    NSUInteger index = [self.m_FieldTransitions indexOfObject:textField];
    if ((index != NSNotFound) && ((index+1) < [self.m_FieldTransitions count])) {
        UIResponder *nextField = [self.m_FieldTransitions objectAtIndex:(index+1)];
        [nextField becomeFirstResponder];
        return NO;
    } else {
        [textField resignFirstResponder];
        return YES;
    }
}

// -----------------------------------------------------------------------------------------------------------------

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.m_ActiveTextView = textView;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // Get the field that we should be editing next, if any...
    NSUInteger index = [self.m_FieldTransitions indexOfObject:textView];
    if ((index != NSNotFound) && ((index+1) < [self.m_FieldTransitions count])) {
        UIResponder *nextField = [self.m_FieldTransitions objectAtIndex:(index+1)];
        [nextField becomeFirstResponder];
    }
    
    self.m_ActiveTextView = nil;
}

// =================================================================================================================
#pragma mark - Selector methods
// =================================================================================================================

- (void) save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.m_DismissBlock];
}

// -----------------------------------------------------------------------------------------------------------------

- (void) cancel:(id)sender
{
    // The user cancelled, then we need to remove the new intention item from the store
//    [[COIntentionItemTypeStore sharedIntentionItemTypeStore] removeIntentionItemType:self.m_IntentionItem];
    [self removeCurrentIntentionItemType];
    self.m_bUserCancelledNewIntentionItem = YES;
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.m_DismissBlock];
}

// =================================================================================================================
#pragma mark - COIntentionItemTypeDetailViewDelegate Method Stubs
// =================================================================================================================

- (void) saveTextFieldsIntoIntentionItemType
{
    NSString *logText = @"saveTextFieldsIntoIntentionItemType called in super class.";
    NSLog(@"%@", logText);
}

// -----------------------------------------------------------------------------------------------------------------

- (void) removeCurrentIntentionItemType
{
    NSString *logText = @"removeCurrentIntentionItemType called in super class.";
    NSLog(@"%@", logText);

}

@end
