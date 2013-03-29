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
    CGPathRef path = [UIBezierPath bezierPathWithRect:self.mainViewController.view.bounds].CGPath;
    self.mainViewController.view.layer.shadowPath = path;
    
    // If we have a right view controller, detect swipes to the left and reveal it when they occur
    // (it only seems counterintuitive until you think about it)
    if (self.rightViewController != nil) {
        UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        leftSwipeRecognizer.delegate = self;
        [self.mainViewController.view addGestureRecognizer:leftSwipeRecognizer];
    }
    
    // Do the inverse if we have a left view controller
    if (self.leftViewController != nil) {
        UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        rightSwipeRecognizer.delegate = self;
        [self.mainViewController.view addGestureRecognizer:rightSwipeRecognizer];
    }
}


/* When we show a drawer, we disable user interaction on the main view controller's view, causing it
   to pass touch events up the responder chain to ourself. The drawer view controller views will eat touch events,
   so this method is only called when a touch occurs on the main view controller's view when a drawer is open */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    // If we have a drawer visible, close it in response to the touch on the main view
    if (self.leftDrawerVisible) {
        [self toggleLeftDrawer];
    } else if (self.rightDrawerVisible) {
        [self toggleRightDrawer];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // We need to allow both the left and right swipe gestures to be simultaneously recognized
    return YES;
}

// When we recognize a swipe, show the appropriate drawer based on the swipe's direction
- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    /* We only want to handle the swipe if (1) the gesture is done and (2) the navigation stack has
       only one view controller or there is no navigation stack. This is more tightly coupled to the
       nature of the main view controller than I'd like, but I wasn't able to come up with a better 
       way to only allow swipes when the article list is visible */
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (![mainViewController isKindOfClass:[UINavigationController class]] ||
            ([mainViewController isKindOfClass:[UINavigationController class]] && [((UINavigationController *)mainViewController).viewControllers count] == 1)) {
            if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
                [self toggleRightDrawer];
            } else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
                [self toggleLeftDrawer];
            }
        }
    }
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

        self.mainViewController.view.userInteractionEnabled = YES;
        
    } else {
        // If the left drawer is not visible, add the left view controller and its view as children and subviews, respectively
        [self addChildViewController:self.leftViewController];
        [self.view insertSubview:[self.leftViewController view] belowSubview:[self.mainViewController view]];
        [self.leftViewController didMoveToParentViewController:self];
        
        // Set the shadow path
        CGPathRef path = [UIBezierPath bezierPathWithRect:self.mainViewController.view.bounds].CGPath;
        self.mainViewController.view.layer.shadowPath = path;
        
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
                         completion:^(BOOL finished) { self.leftViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin; }];
        
        // Note that the left drawer is now visible
        self.leftDrawerVisible = YES;
        
        self.mainViewController.view.userInteractionEnabled = NO;
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
                             [self.rightViewController.view removeFromSuperview];
                             [self.rightViewController willMoveToParentViewController:nil];
                             [self.rightViewController removeFromParentViewController];
                         }];
        
        // Note that the right drawer is no longer visible
        self.rightDrawerVisible = NO;
        
        self.mainViewController.view.userInteractionEnabled = YES;
    } else {
        // If the right drawer is not visible, add the right view controller and its view as children and subviews, respectively
        [self addChildViewController:self.rightViewController];
        [self.view insertSubview:[self.rightViewController view] belowSubview:[self.mainViewController view]];
        [self.rightViewController didMoveToParentViewController:self];
        
        // Set the shadow path
        CGPathRef path = [UIBezierPath bezierPathWithRect:self.mainViewController.view.bounds].CGPath;
        self.mainViewController.view.layer.shadowPath = path;
        
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
                         completion:^(BOOL finished) { self.rightViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin; }];
        
        // Note that the right drawer is now visible
        self.rightDrawerVisible = YES;
        
        self.mainViewController.view.userInteractionEnabled = NO;
    }

}

// Workaround from http://blog.radi.ws/post/8348898129/calayers-shadowpath-and-uiview-autoresizing to update shadow path during rotation
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGPathRef oldShadowPath = self.mainViewController.view.layer.shadowPath;
    
    if (oldShadowPath) {
        CFRetain(oldShadowPath);
    }
    
    // Update shadow path for the view
    CGPathRef path = [UIBezierPath bezierPathWithRect:self.mainViewController.view.bounds].CGPath;
    self.mainViewController.view.layer.shadowPath = path;

    if (oldShadowPath) {
        [self.mainViewController.view.layer addAnimation:((^ {
            CABasicAnimation *transition = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
            transition.fromValue = (__bridge id)oldShadowPath;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.duration = duration;
            return transition;
        })()) forKey:@"transition"];
        CFRelease(oldShadowPath);
    }
}

@end
