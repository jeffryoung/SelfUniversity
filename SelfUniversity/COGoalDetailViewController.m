// =================================================================================================================
//
//  COGoalDetailViewController.m
//  iLearn University
//
//  Created by Jeffrey Young on 8/19/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COGoalDetailViewController.h"
#import "COIntentionItem.h"
#import "COIntentionItemStore.h"

@interface COGoalDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *intentionNameField;
@property (weak, nonatomic) IBOutlet UITextView *intentionDescriptionField;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;
@property (nonatomic) BOOL m_bIsNew;

@end

@implementation COGoalDetailViewController

// =================================================================================================================
#pragma mark - Object Methods
// =================================================================================================================

- (instancetype) initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.m_bIsNew = isNew;
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
            
            // Set the restoration identifier for this view controller.
            self.restorationIdentifier = NSStringFromClass([self class]);
            self.restorationClass = [self class];
        }
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    COIntentionItem *intentionItem = self.m_IntentionItem;
    
    if (self.m_bIsNew) {
        self.title = self.m_nIntentionTypeTitle;
    } else {
        self.title = intentionItem.intentionItemName;
    }
    
    self.intentionNameField.text = intentionItem.intentionItemName;
    self.intentionDescriptionField.text = intentionItem.intentionItemDescription;
    
    // Format the date into a simle date string
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.dateCreatedLabel.text = [dateFormatter stringFromDate:intentionItem.intentionItemDateCreated];
}

// -----------------------------------------------------------------------------------------------------------------

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear us as being the first responder
    [self.view endEditing:YES];
    
    // Save changes to the intentionItem
    COIntentionItem *intentionItem = self.m_IntentionItem;
    intentionItem.intentionItemName = self.intentionNameField.text;
    intentionItem.intentionItemDescription = self.intentionDescriptionField.text;
}

// -----------------------------------------------------------------------------------------------------------------

- (void) setIntentionItem:(COIntentionItem *)intentionItem
{
    _m_IntentionItem = intentionItem;
    self.navigationItem.title = intentionItem.intentionItemName;
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
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.m_DismissBlock];
}

// =================================================================================================================
#pragma mark - UIViewControllerRestoration Protocol Methods
// =================================================================================================================

+ (UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[self alloc] init];
}

@end