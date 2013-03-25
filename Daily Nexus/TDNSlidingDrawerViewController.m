//
//  TDNSlidingDrawerViewController.m
//  Daily Nexus
//
//  TDNSlidingDrawerViewController uses view controller containment to create a three-view sliding
//  drawer view controller as used in the Facebook app, in which the main view can be slid aside
//  to reveal a secondary view to the left or right
//

#import "TDNSlidingDrawerViewController.h"

@interface TDNSlidingDrawerViewController ()

@property (assign) BOOL leftDrawerVisible;
@property (assign) BOOL rightDrawerVisible;

@end

@implementation TDNSlidingDrawerViewController

@synthesize mainViewController;
@synthesize leftViewController;
@synthesize rightViewController;
@synthesize leftDrawerVisible;
@synthesize rightDrawerVisible;

// Initialize ourself with a nib and three view controllers
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil mainViewController:(UIViewController *)main leftViewController:(UIViewController *)left andRightViewController:(UIViewController *)right {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        mainViewController = main;
        leftViewController = left;
        rightViewController = right;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // When our view loads, add the main view controller as a child and add its view as a subview
    [self addChildViewController:self.mainViewController];
    [self.view addSubview:[self.mainViewController view]];
    self.mainViewController.view.frame = self.view.frame;
    [self.mainViewController didMoveToParentViewController:self];
    
    // Add a shadow to the main view controller's view (only visible when a drawer is open)
    self.mainViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mainViewController.view.layer.shadowOpacity = 0.5;
    self.mainViewController.view.layer.shadowRadius = 3.0;
    
    // Listen for changes to our view's bounds, so we can resize our child views appropriately when
    // the device is rotated
    [self addObserver:self
           forKeyPath:@"view.bounds"
              options:NSKeyValueObservingOptionNew
              context:nil];
}

- (void)toggleLeftDrawer {
    
    // If the right drawer is visible, ignore the request to toggle the left drawer
    if (self.rightDrawerVisible) {
        return;
    }
    
    // If the left drawer is visible, we want to hide it
    if (self.leftDrawerVisible) {
        
        // Slide the main view to the left to cover up the left drawer, then remove the left view and its controller
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{ self.mainViewController.view.frame = CGRectMake(0, 0, self.mainViewController.view.frame.size.width, self.mainViewController.view.frame.size.height); }
                         completion:^(BOOL finished) {
                             [self.leftViewController.view removeFromSuperview];
                             [self.leftViewController willMoveToParentViewController:nil];
                             [self.leftViewController removeFromParentViewController];
                         }];
        
        // Note that the left drawer is no longer visible
        self.leftDrawerVisible = NO;
        
    } else {
        // If the left drawer is not visible, add the left view controller and its view as children and subviews, respectively
        [self addChildViewController:self.leftViewController];
        [self.view insertSubview:[self.leftViewController view] belowSubview:[self.mainViewController view]];
        [self.leftViewController didMoveToParentViewController:self];
        
        // Make the main view's shadow appear on the left
        self.mainViewController.view.layer.shadowOffset = CGSizeMake(-3, 0);
        
        // Determine how wide to make the drawer based on the current device
        NSInteger width = 260;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            width = 320;
        }
        
        // Size the left drawer view appropriately
        self.leftViewController.view.frame = CGRectMake(0, 0, width, self.view.bounds.size.height);
        
        // Slide the main view to the right to reveal the left drawer
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{ self.mainViewController.view.frame = CGRectMake(width, 0, self.mainViewController.view.frame.size.width, self.mainViewController.view.frame.size.height); }
                         completion:NULL];
        
        // Note that the left drawer is now visible
        self.leftDrawerVisible = YES;
    }
}

- (void)toggleRightDrawer {
    
    if (self.leftDrawerVisible) {
        return;
    }
    
    // If the right drawer is visible, we want to hide it
    if (self.rightDrawerVisible) {
        
        // Slide the main view to the right to cover up the right drawer, then remove the right view and its controller
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{ self.mainViewController.view.frame = CGRectMake(0, 0, self.mainViewController.view.frame.size.width, self.mainViewController.view.frame.size.height); }
                         completion:^(BOOL finished) {
                             NSLog(@"removed");
                             [self.rightViewController.view removeFromSuperview];
                             [self.rightViewController willMoveToParentViewController:nil];
                             [self.rightViewController removeFromParentViewController];
                         }];
        
        // Note that the right drawer is no longer visible
        self.rightDrawerVisible = NO;
        
    } else {
        // If the right drawer is not visible, add the right view controller and its view as children and subviews, respectively
        [self addChildViewController:self.rightViewController];
        [self.view insertSubview:[self.rightViewController view] belowSubview:[self.mainViewController view]];
        [self.rightViewController didMoveToParentViewController:self];
        
        // Make the main view's shadow appear on the right
        self.mainViewController.view.layer.shadowOffset = CGSizeMake(3, 0);
        
        // Determine how wide to make the drawer based on the current device
        NSInteger width = 260;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            width = 320;
        }
        
        // Size the right drawer view appropriately
        self.rightViewController.view.frame = CGRectMake(self.view.bounds.size.width - width, 0, width, self.view.bounds.size.height);
        
        // Slide the main view to the left to reveal the right drawer
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{ self.mainViewController.view.frame = CGRectMake(-width, 0, self.mainViewController.view.frame.size.width, self.mainViewController.view.frame.size.height); }
                         completion:NULL];
        
        // Note that the right drawer is now visible
        self.rightDrawerVisible = YES;
    }

}

// This method will be called whenever our view's bounds change
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // Determine how wide the drawer should be
    NSInteger width = 260;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        width = 320;
    }

    // If the left drawer is visible, correct the frame of the drawer view and main view
    if (self.leftDrawerVisible) {
        self.leftViewController.view.frame = CGRectMake(0, 0, width, self.view.bounds.size.height);
        self.mainViewController.view.frame = CGRectMake(width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    
    // Do the same if the right drawer is visible
    if (self.rightDrawerVisible) {
        self.rightViewController.view.frame = CGRectMake(self.view.bounds.size.width - width, 0, width, self.view.bounds.size.height);
        self.mainViewController.view.frame = CGRectMake(-width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"view.bounds"];
}

@end
