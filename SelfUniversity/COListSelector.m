// =================================================================================================================
//
//  COListSelector.m
//  iLearn University
//
//  Created by Jeffrey Young on 8/13/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COListSelector.h"

// =================================================================================================================
#pragma mark - Private Object Data
// =================================================================================================================

@interface COListSelector ()

@property (nonatomic,strong) NSArray *gListText;

@end

// =================================================================================================================
#pragma mark - Object Methods
// =================================================================================================================

@implementation COListSelector;

@synthesize m_delegate;

static NSString *intentionTypeCellIdentifier;

// -----------------------------------------------------------------------------------------------------------------

- (instancetype) initWithList:(NSArray *)listText
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        self.gListText = listText;
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                       target:self
                                       action:@selector(save:)];
        self.navigationItem.rightBarButtonItem = doneButton;
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                         target:self
                                         action:@selector(cancel:)];
        
        self.navigationItem.leftBarButtonItem = cancelButton;
        self.m_nIndexSelected = kNoSelectionMade;
        
        // Set the restoration identifier for this view controller.
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    }
    return self;
}

// -----------------------------------------------------------------------------------------------------------------

- (instancetype) init
{
    return [self initWithList:@[]];
}

// -----------------------------------------------------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    intentionTypeCellIdentifier = @"intentionTypeCellIdentifier";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:intentionTypeCellIdentifier];
    
    self.title = NSLocalizedString(@"Creating...", @"List Selector Title");
     
}

// -----------------------------------------------------------------------------------------------------------------
// Action to take when the user presses the Done button on the navigation controller

- (void) save:(id)sender
{
    [[self m_delegate] indexSelected:self.m_nIndexSelected];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.m_dismissBlock];
}

// -----------------------------------------------------------------------------------------------------------------
// Action to take when the user presses the Cancel button on the navigation controller

- (void) cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

// =================================================================================================================
#pragma mark - Selection Handling Methods
// =================================================================================================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

// -----------------------------------------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.gListText count];
}

// -----------------------------------------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:intentionTypeCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.gListText objectAtIndex:indexPath.row];
    return cell;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Turn off the selection of the selected row.
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // If we have selected the same row as selected before, then we don't need to do anything.
    NSUInteger oldIndex = self.m_nIndexSelected;
    if (oldIndex == indexPath.row) {
        return;
    }
    
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldIndex inSection:0];
    
    // Put a checkmark on the new cell and remember the row selected.
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.m_nIndexSelected = indexPath.row;
    }
    
    // Take the checkmark off the old cell
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
}

// =================================================================================================================
#pragma mark - UIViewControllerRestoration Protocol Methods
// =================================================================================================================

+ (UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[self alloc] init];
}

@end
