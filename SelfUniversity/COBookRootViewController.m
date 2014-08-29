// =================================================================================================================
//
//  COBookRootViewViewController.m
//  SelfUniversity
//
//  Created by Jeffrey Young on 6/25/14.
//  Copyright (c) 2014 infinite Discoveries. All rights reserved.
//
// =================================================================================================================

#import "COBookRootViewController.h"
#import "COBookModelController.h"
#import "COBookDataViewController.h"

@interface COBookRootViewController ()
@property (nonatomic, readonly, strong) COBookModelController *g_modelController;

@end

@implementation COBookRootViewController

// =================================================================================================================
#pragma mark - Initialization
// =================================================================================================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Set the tab bar item's title
        self.tabBarItem.title = NSLocalizedString(@"Library", @"Library Tab Bar Label");
        
        // Create a UIImage from the icon
        UIImage *image = [UIImage imageNamed:@"BookIcon.png"];
        
        // Put that image on the tab bar item
        self.tabBarItem.image = image;
        
        // Set the restoration identifier for this view controller.
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    }
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    return self;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller

    self.m_pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.m_pageViewController.delegate = self;
    
    UIStoryboard *storyboard;
//    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"BookStoryboard_iPad" bundle:nil];
//    } else {
//        storyboard = [UIStoryboard storyboardWithName:@"BookStoryboard_iPhone" bundle:nil];
//    }

    COBookDataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self.m_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    
    self.m_pageViewController.dataSource = self.modelController;
    
    [self addChildViewController:self.m_pageViewController];
    [self.view addSubview:self.m_pageViewController.view];
    
    [self.m_pageViewController didMoveToParentViewController:self];
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.m_pageViewController.gestureRecognizers;
}

// -----------------------------------------------------------------------------------------------------------------

- (void)viewWillAppear:(BOOL)animated
{
    // Reduce the vertical size of the view frame so that it will not overlap the Tab Bar at the bottom of the window.
    
    NSLog(@"%s tabBarController view bounds height = %f", __PRETTY_FUNCTION__, self.m_tabBarController.tabBar.bounds.size.height);
    
    CGRect pageViewRect = self.view.bounds;
    pageViewRect.size.height -= self.m_tabBarController.tabBar.bounds.size.height;
    self.m_pageViewController.view.frame = pageViewRect;
    
    NSLog(@"%s Setting view frame bounds to %@.", __PRETTY_FUNCTION__, NSStringFromCGRect(pageViewRect));
}

// -----------------------------------------------------------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// -----------------------------------------------------------------------------------------------------------------

- (COBookModelController *)modelController
{
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_g_modelController) {
        _g_modelController = [[COBookModelController alloc] init];
    }
    return _g_modelController;
}

// =================================================================================================================
#pragma mark - UIPageViewController delegate methods
// =================================================================================================================

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if (UIInterfaceOrientationIsPortrait(orientation) || ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
        
        UIViewController *currentViewController = self.m_pageViewController.viewControllers[0];
        NSArray *viewControllers = @[currentViewController];
        [self.m_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        self.m_pageViewController.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    }
    
    // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
    COBookDataViewController *m_currentViewController = self.m_pageViewController.viewControllers[0];
    NSArray *viewControllers = nil;
    
    NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:m_currentViewController];
    if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
        UIViewController *nextViewController = [self.g_modelController pageViewController:self.m_pageViewController viewControllerAfterViewController:m_currentViewController];
        viewControllers = @[m_currentViewController, nextViewController];
    } else {
        UIViewController *previousViewController = [self.modelController pageViewController:self.m_pageViewController viewControllerBeforeViewController:m_currentViewController];
        viewControllers = @[previousViewController, m_currentViewController];
    }
    [self.m_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    
    return UIPageViewControllerSpineLocationMid;
}

// =================================================================================================================
#pragma mark - UIViewControllerRestoration Protocol Methods
// =================================================================================================================

+ (UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[self alloc] init];
}

@end
