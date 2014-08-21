// =================================================================================================================
//
//  COVisionDetailViewController.m
//  iLearn University
//
//  Created by Jeffrey Young on 8/19/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COVisionDetailViewController.h"
#import "COVisionItem.h"
#import "COVisionItemStore.h"

@interface COVisionDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *visionNameField;
@property (weak, nonatomic) IBOutlet UITextView *visionDescriptionField;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;
@property (nonatomic) BOOL m_bIsNew;

@end

@implementation COVisionDetailViewController

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
    
    COVisionItem *visionItem = self.m_VisionItem;
    
    if (self.m_bIsNew) {
        self.title = self.m_nVisionTypeTitle;
    } else {
        self.title = visionItem.m_VisionItemName;
    }
    
    self.visionNameField.text = visionItem.m_VisionItemName;
    self.visionDescriptionField.text = visionItem.m_VisionItemDescription;
    
    // Format the date into a simle date string
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.dateCreatedLabel.text = [dateFormatter stringFromDate:visionItem.m_DateCreated];
}

// -----------------------------------------------------------------------------------------------------------------

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear us as being the first responder
    [self.view endEditing:YES];
    
    // Save changes to the visionItem
    COVisionItem *visionItem = self.m_VisionItem;
    visionItem.m_VisionItemName = self.visionNameField.text;
    visionItem.m_VisionItemDescription = self.visionDescriptionField.text;
}

// -----------------------------------------------------------------------------------------------------------------

- (void) setVisionItem:(COVisionItem *)visionItem
{
    _m_VisionItem = visionItem;
    self.navigationItem.title = visionItem.m_VisionItemName;
}

// -----------------------------------------------------------------------------------------------------------------

- (void) save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.m_DismissBlock];
}

// -----------------------------------------------------------------------------------------------------------------

- (void) cancel:(id)sender
{
    // The user cancelled, then we need to remove the new vision item from the store
    [[COVisionItemStore sharedVisionItemStore] removeVisionItem:self.m_VisionItem];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.m_DismissBlock];
}
@end
