// =================================================================================================================
//
//  COSelfEmpowermentItemDetailViewController.m
//  iLearn University
//
//  Created by Jeffrey Young on 11/3/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COGlobalDefsConstants.h"
#import "COAppDelegate.h"
#import "COIntentionItemTypeViewController.h"
#import "COSelfEmpowermentItemDetailViewController.h"
#import "COSelfEmpowermentItem.h"
#import "COIntentionItemTypeStore.h"
#import "COSelfEmpowermentItemHelpViewController.h"

@interface COSelfEmpowermentItemDetailViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *intentionItemTypeLogo;

@property (weak, nonatomic) IBOutlet UITextField *intentionNameField;
@property (weak, nonatomic) IBOutlet UITextView *intentionDescriptionField;
@property (weak, nonatomic) IBOutlet UITextView *selfEmpowermentItemAnswer2Field;
@property (weak, nonatomic) IBOutlet UITextView *selfEmpowermentItemAnswer3Field;
@property (weak, nonatomic) IBOutlet UITextView *selfEmpowermentItemAnswer4Field;
@property (weak, nonatomic) IBOutlet UITextView *selfEmpowermentItemAnswer5Field;
@property (weak, nonatomic) IBOutlet UITextView *selfEmpowermentItemAnswer6Field;
@property (weak, nonatomic) IBOutlet UITextView *selfEmpowermentItemAnswer7Field;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedField;

@property (weak, nonatomic) IBOutlet UILabel *selfEmpowermentProcessLabel;
@property (weak, nonatomic) IBOutlet UILabel *problemLabel;
@property (weak, nonatomic) IBOutlet UILabel *problemDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *SelfEmpowermentItemAnswer2Label;
@property (weak, nonatomic) IBOutlet UILabel *SelfEmpowermentItemAnswer3Label;
@property (weak, nonatomic) IBOutlet UILabel *SelfEmpowermentItemAnswer4Label;
@property (weak, nonatomic) IBOutlet UILabel *SelfEmpowermentItemAnswer5Label;
@property (weak, nonatomic) IBOutlet UILabel *SelfEmpowermentItemAnswer6Label;
@property (weak, nonatomic) IBOutlet UILabel *SelfEmpowermentItemAnswer7Label;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;

@end

@implementation COSelfEmpowermentItemDetailViewController

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
    
    COSelfEmpowermentItem *selfEmpowermentItem = self.m_SelfEmpowermentItem;
    
    // Set the title on the view controller
    if (self.m_bIsNew) {
        self.title = self.m_tIntentionItemTypeControllerTitle;
    } else {
        self.title = selfEmpowermentItem.intentionItemTypeName;
    }
    
    // Load the array of field transitions for the Next button.
    self.m_FieldTransitions = @[self.intentionNameField, self.intentionDescriptionField, self.self.selfEmpowermentItemAnswer2Field,
                                self.selfEmpowermentItemAnswer3Field, self.selfEmpowermentItemAnswer4Field, self.selfEmpowermentItemAnswer5Field,
                                self.selfEmpowermentItemAnswer6Field, self.selfEmpowermentItemAnswer7Field];
    
    [self loadTextFieldsFromSelfEmpowermentItem];
    
}

// =================================================================================================================
#pragma mark - Selector Methods
// =================================================================================================================


- (void) setSelfEmpowermentItem:(COSelfEmpowermentItem *)selfEmpowermentItem
{
    _m_SelfEmpowermentItem = selfEmpowermentItem;
    self.navigationItem.title = selfEmpowermentItem.intentionItemTypeName;
}

// -----------------------------------------------------------------------------------------------------------------

- (void) loadTextFieldsFromSelfEmpowermentItem
{
    COSelfEmpowermentItem *selfEmpowermentItem = self.m_SelfEmpowermentItem;
    
    // Place the data from the intentionItem into the fields on the detail view.
    self.intentionItemTypeLogo.image = [UIImage imageNamed:@"SelfEmpowermentItemIcon.png"];
    self.intentionNameField.text = selfEmpowermentItem.intentionItemTypeName;
    self.intentionDescriptionField.text = selfEmpowermentItem.intentionItemTypeDescription;
    self.selfEmpowermentItemAnswer2Field.text = selfEmpowermentItem.selfEmpowermentItemAnswer2;
    self.selfEmpowermentItemAnswer3Field.text = selfEmpowermentItem.selfEmpowermentItemAnswer3;
    self.selfEmpowermentItemAnswer4Field.text = selfEmpowermentItem.selfEmpowermentItemAnswer4;
    self.selfEmpowermentItemAnswer5Field.text = selfEmpowermentItem.selfEmpowermentItemAnswer5;
    self.selfEmpowermentItemAnswer6Field.text = selfEmpowermentItem.selfEmpowermentItemAnswer6;
    self.selfEmpowermentItemAnswer7Field.text = selfEmpowermentItem.selfEmpowermentItemAnswer7;

    
    // Format Target Date and Date Created into simple date strings and put the dates on the detail view.
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    self.dateCreatedField.text = [dateFormatter stringFromDate:selfEmpowermentItem.intentionItemTypeDateCreated];
}

// -----------------------------------------------------------------------------------------------------------------

- (void) saveTextFieldsIntoIntentionItemType
{
    // Save any changes back into the selfEmpowermentItem
    COSelfEmpowermentItem *selfEmpowermentItem = self.m_SelfEmpowermentItem;
    selfEmpowermentItem.intentionItemTypeName = self.intentionNameField.text;
    selfEmpowermentItem.intentionItemTypeDescription = self.intentionDescriptionField.text;
    selfEmpowermentItem.selfEmpowermentItemAnswer2 = self.selfEmpowermentItemAnswer2Field.text;
    selfEmpowermentItem.selfEmpowermentItemAnswer3 = self.selfEmpowermentItemAnswer3Field.text;
    selfEmpowermentItem.selfEmpowermentItemAnswer4 = self.selfEmpowermentItemAnswer4Field.text;
    selfEmpowermentItem.selfEmpowermentItemAnswer5 = self.selfEmpowermentItemAnswer5Field.text;
    selfEmpowermentItem.selfEmpowermentItemAnswer6 = self.selfEmpowermentItemAnswer6Field.text;
    selfEmpowermentItem.selfEmpowermentItemAnswer7 = self.selfEmpowermentItemAnswer7Field.text;
}

// -----------------------------------------------------------------------------------------------------------------
- (void) removeCurrentIntentionItemType
{
    [[COIntentionItemTypeStore sharedIntentionItemTypeStore] removeIntentionItemType:self.m_SelfEmpowermentItem];
}

// -----------------------------------------------------------------------------------------------------------------

- (IBAction)displayHelpViewController:(id)sender
{
    COSelfEmpowermentItemHelpViewController *selfEmpowermentItemHelpViewController = [[COSelfEmpowermentItemHelpViewController alloc] init];
    [self.navigationController pushViewController:selfEmpowermentItemHelpViewController animated:YES];
    
}

// =================================================================================================================
#pragma mark - UIViewControllerRestoration Protocol Methods
// =================================================================================================================

+ (UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    COSelfEmpowermentItemDetailViewController *restoredViewController = [[self alloc] initForNewItem:NO];
    
    return restoredViewController;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [self saveTextFieldsIntoIntentionItemType];
    [[COIntentionItemTypeStore sharedIntentionItemTypeStore] saveChanges];
    
    [coder encodeObject:self.m_SelfEmpowermentItem.intentionItemTypeKey forKey:@"intentionItemTypeKey"];
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
            self.m_SelfEmpowermentItem = (COSelfEmpowermentItem *)intentionItemType;
            break;
        }
    }
    
    self.m_tIntentionItemTypeControllerTitle = [coder decodeObjectForKey:@"intentionItemDetailControllerTitle"];
    self.m_bIsNew = [coder decodeBoolForKey:@"intentionItemIsNew"];
    
    [super decodeRestorableStateWithCoder:coder];
    
    // If we were entering a new selfEmpowermentItem, then reach back to the intentionItemTypeViewController and tell it to show the detail view controller modally.
    if (self.m_bIsNew) {
        COAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
        COIntentionItemTypeViewController *intentionItemTypeViewController = ((UINavigationController *)(tabBarController.viewControllers[kCOIntentionItemTypeViewControllerPosition])).viewControllers[0];
        [intentionItemTypeViewController registerToPresentDetailViewControllerModally:self];
    }
}

@end
