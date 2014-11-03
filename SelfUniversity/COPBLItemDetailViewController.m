// =================================================================================================================
//
//  COPBLItemDetailViewController.m
//  iLearn University
//
//  Created by Jeffrey Young on 10/23/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COGlobalDefsConstants.h"
#import "COAppDelegate.h"
#import "COIntentionItemTypeViewController.h"
#import "COPBLItemDetailViewController.h"
#import "COPBLItem.h"
#import "COIntentionItemTypeStore.h"
#import "COPBLItemHelpViewController.h"

@interface COPBLItemDetailViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *intentionItemTypeLogo;

@property (weak, nonatomic) IBOutlet UITextField *intentionNameField;
@property (weak, nonatomic) IBOutlet UITextView *intentionDescriptionField;
@property (weak, nonatomic) IBOutlet UITextField *pblItemSubDrivingQuestionField;
@property (weak, nonatomic) IBOutlet UITextField *pblItemClarifyingQuestion1Field;
@property (weak, nonatomic) IBOutlet UITextField *pblItemClarifyingQuestion2Field;
@property (weak, nonatomic) IBOutlet UITextField *pblItemClarifyingQuestion3Field;
@property (weak, nonatomic) IBOutlet UITextField *pblItemGuidingQuestion1Field;
@property (weak, nonatomic) IBOutlet UITextField *pblItemGuidingQuestion2Field;
@property (weak, nonatomic) IBOutlet UITextField *pblItemGuidingQuestion3Field;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedField;

@property (weak, nonatomic) IBOutlet UILabel *pblLabel;
@property (weak, nonatomic) IBOutlet UILabel *pblDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *subDrivingQuestionLabel;
@property (weak, nonatomic) IBOutlet UILabel *clarifyingQuestionSectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *clarifyingQuestion1Label;
@property (weak, nonatomic) IBOutlet UILabel *clarifyingQuestion2Label;
@property (weak, nonatomic) IBOutlet UILabel *clarifyingQuestion3Label;
@property (weak, nonatomic) IBOutlet UILabel *guidingQuestionSectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *guidingQuestion1Label;
@property (weak, nonatomic) IBOutlet UILabel *guidingQuestion2Label;
@property (weak, nonatomic) IBOutlet UILabel *guidingQuestion3Label;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;


@end

@implementation COPBLItemDetailViewController

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
    
    COPBLItem *PBLItem = self.m_PBLItem;
    
    // Set the title on the view controller
    if (self.m_bIsNew) {
        self.title = self.m_tIntentionItemTypeControllerTitle;
    } else {
        self.title = PBLItem.intentionItemTypeName;
    }
    
    // Load the array of field transitions for the Next button.
    self.m_FieldTransitions = @[self.intentionNameField, self.intentionDescriptionField, self.pblItemSubDrivingQuestionField, self.pblItemClarifyingQuestion1Field,
                                self.pblItemClarifyingQuestion2Field, self.pblItemClarifyingQuestion3Field, self.pblItemGuidingQuestion1Field, self.pblItemGuidingQuestion2Field,
                                self.pblItemGuidingQuestion3Field];
    
    [self loadTextFieldsFromPBLItem];
    
}

// =================================================================================================================
#pragma mark - Selector Methods
// =================================================================================================================


- (void) setPBLItem:(COPBLItem *)PBLItem
{
    _m_PBLItem = PBLItem;
    self.navigationItem.title = PBLItem.intentionItemTypeName;
}

// -----------------------------------------------------------------------------------------------------------------

- (void) loadTextFieldsFromPBLItem
{
    COPBLItem *PBLItem = self.m_PBLItem;
    
    // Place the data from the intentionItem into the fields on the detail view.
    self.intentionItemTypeLogo.image = [UIImage imageNamed:@"ProjectBasedLearningItemIcon.png"];
    self.intentionNameField.text = PBLItem.intentionItemTypeName;
    self.intentionDescriptionField.text = PBLItem.intentionItemTypeDescription;
    self.pblItemSubDrivingQuestionField.text = PBLItem.pblItemSubDrivingQuestion;
    self.pblItemClarifyingQuestion1Field.text = PBLItem.pblItemClarifyingQuestion1;
    self.pblItemClarifyingQuestion2Field.text = PBLItem.pblItemClarifyingQuestion2;
    self.pblItemClarifyingQuestion3Field.text = PBLItem.pblItemClarifyingQuestion3;
    self.pblItemGuidingQuestion1Field.text = PBLItem.pblItemGuidingQuestion1;
    self.pblItemGuidingQuestion2Field.text = PBLItem.pblItemGuidingQuestion2;
    self.pblItemGuidingQuestion3Field.text = PBLItem.pblItemGuidingQuestion3;
    
    // Format Target Date and Date Created into simple date strings and put the dates on the detail view.
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    self.dateCreatedField.text = [dateFormatter stringFromDate:PBLItem.intentionItemTypeDateCreated];
}

// -----------------------------------------------------------------------------------------------------------------

- (void) saveTextFieldsIntoIntentionItemType
{
    // Save any changes back into the PBLItem
    COPBLItem *PBLItem = self.m_PBLItem;
    PBLItem.intentionItemTypeName = self.intentionNameField.text;
    PBLItem.intentionItemTypeDescription = self.intentionDescriptionField.text;
    PBLItem.pblItemSubDrivingQuestion = self.pblItemSubDrivingQuestionField.text;
    PBLItem.pblItemClarifyingQuestion1 = self.pblItemSubDrivingQuestionField.text;
    PBLItem.pblItemClarifyingQuestion2 = self.pblItemSubDrivingQuestionField.text;
    PBLItem.pblItemClarifyingQuestion3 = self.pblItemSubDrivingQuestionField.text;
    PBLItem.pblItemGuidingQuestion1 = self.pblItemGuidingQuestion1Field.text;
    PBLItem.pblItemGuidingQuestion2 = self.pblItemGuidingQuestion2Field.text;
    PBLItem.pblItemGuidingQuestion3 = self.pblItemGuidingQuestion3Field.text;
}

// -----------------------------------------------------------------------------------------------------------------
- (void) removeCurrentIntentionItemType
{
    [[COIntentionItemTypeStore sharedIntentionItemTypeStore] removeIntentionItemType:self.m_PBLItem];
}

// -----------------------------------------------------------------------------------------------------------------

- (IBAction)displayHelpViewController:(id)sender
{
    COPBLItemHelpViewController *PBLItemHelpViewController = [[COPBLItemHelpViewController alloc] init];
    [self.navigationController pushViewController:PBLItemHelpViewController animated:YES];
    
}

// =================================================================================================================
#pragma mark - UIViewControllerRestoration Protocol Methods
// =================================================================================================================

+ (UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    COPBLItemDetailViewController *restoredViewController = [[self alloc] initForNewItem:NO];
    
    return restoredViewController;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [self saveTextFieldsIntoIntentionItemType];
    [[COIntentionItemTypeStore sharedIntentionItemTypeStore] saveChanges];
    
    [coder encodeObject:self.m_PBLItem.intentionItemTypeKey forKey:@"intentionItemTypeKey"];
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
            self.m_PBLItem = (COPBLItem *)intentionItemType;
            break;
        }
    }
    
    self.m_tIntentionItemTypeControllerTitle = [coder decodeObjectForKey:@"intentionItemDetailControllerTitle"];
    self.m_bIsNew = [coder decodeBoolForKey:@"intentionItemIsNew"];
    
    [super decodeRestorableStateWithCoder:coder];
    
    // If we were entering a new PBLItem, then reach back to the intentionItemTypeViewController and tell it to show the detail view controller modally.
    if (self.m_bIsNew) {
        COAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
        COIntentionItemTypeViewController *intentionItemTypeViewController = ((UINavigationController *)(tabBarController.viewControllers[kCOIntentionItemTypeViewControllerPosition])).viewControllers[0];
        [intentionItemTypeViewController registerToPresentDetailViewControllerModally:self];
    }
}

@end
