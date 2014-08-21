// =================================================================================================================
//
//  COVisionTypeSelectorTableViewController.m
//  iLearn University
//
//  Created by Jeffrey Young on 8/13/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COGlobalDefsConstants.h"
#import "COVisionTypeSelectorTableViewController.h"

// =================================================================================================================
#pragma mark - Private Object Data
// =================================================================================================================

@interface COVisionTypeSelectorTableViewController ()

@property (nonatomic,strong) NSArray *visionTypeData;

@end

// =================================================================================================================
#pragma mark - Object Methods
// =================================================================================================================

@implementation COVisionTypeSelectorTableViewController

@synthesize m_delegate;

static NSString *visionTypeCellIdentifier;

// -----------------------------------------------------------------------------------------------------------------

- (instancetype) init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        self.visionTypeData = @[@"A New Vision?  or...",@"A New Goal?  or...",@"A New Driving Question?"];
        
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
        self.m_nSelectedType = kNoVisionTypeSelectionMade;
    }
    return self;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    visionTypeCellIdentifier = @"visionTypeCellIdentifier";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:visionTypeCellIdentifier];
    
    self.title = @"Creating...";
     
}

// -----------------------------------------------------------------------------------------------------------------
// Action to take when the user presses the Done button on the navigation controller

- (void) save:(id)sender
{
    [[self m_delegate] visionTypeSelected:self.m_nSelectedType];
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
    return [self.visionTypeData count];
}

// -----------------------------------------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:visionTypeCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.visionTypeData objectAtIndex:indexPath.row];
    return cell;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Turn off the selection of the selected row.
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // If we have selected the same row as selected before, then we don't need to do anything.
    NSUInteger oldIndex = self.m_nSelectedType;
    if (oldIndex == indexPath.row) {
        return;
    }
    
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldIndex inSection:0];
    
    // Put a checkmark on the new cell and remember the row selected.
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.m_nSelectedType = indexPath.row;
    }
    
    // Take the checkmark off the old cell
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
}


@end
