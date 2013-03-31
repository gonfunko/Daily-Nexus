//
//  TDNAppDelegate.m
//  Daily Nexus
//
//  TDNAppDelegate handles initial application setup and responding to application-wide state changes
//

#import "TDNAppDelegate.h"

@interface TDNAppDelegate ()

@end

@implementation TDNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Create our root view controller
    TDNFrontPageViewController *frontPageViewController = nil;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        frontPageViewController = [[TDNFrontPageViewController alloc] initWithNibName:@"TDNFrontPageTableView" bundle:[NSBundle mainBundle]];
    } else {
        frontPageViewController = [[TDNFrontPageViewController alloc] initWithNibName:@"TDNFrontPageCollectionView" bundle:[NSBundle mainBundle]];
    }

    // And a navigation controller to embed it in
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontPageViewController];

    // Create a section view controller
    TDNSectionViewController *sectionsViewController = [[TDNSectionViewController alloc] initWithNibName:@"TDNSectionViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *sectionsNavigiationController = [[UINavigationController alloc] initWithRootViewController:sectionsViewController];
    
    TDNCommentsViewController *commentsViewController = [[TDNCommentsViewController alloc] initWithNibName:@"TDNCommentsViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *commentsNavigiationController = [[UINavigationController alloc] initWithRootViewController:commentsViewController];
    
    // And a sliding drawer view controller with the section controller as the left view controller and the navigation controller as the main view controller
    TDNSlidingDrawerViewController *slidingDrawerViewController = [[TDNSlidingDrawerViewController alloc] initWithNibName:@"TDNSlidingDrawerViewController"
                                                                                           bundle:[NSBundle mainBundle]
                                                                               mainViewController:navigationController
                                                                               leftViewController:sectionsNavigiationController
                                                                           andRightViewController:commentsNavigiationController];
    
    // Set the window's root view controller and display the window
    self.window.rootViewController = slidingDrawerViewController;
    
    [self.window makeKeyAndVisible];
    
    // Configure the global appearance of instances of UINavigationBar
    NSDictionary *navigationBarTextAttributes = @{UITextAttributeTextColor       : [UIColor colorWithWhite:0.2 alpha:1.0],
                                                  UITextAttributeTextShadowColor : [UIColor whiteColor],
                                                  UITextAttributeFont            : [UIFont fontWithName:@"Bodoni 72 Oldstyle" size:0.0]};
    
    NSDictionary *buttonTextAttributes = @{UITextAttributeTextColor           : [UIColor colorWithWhite:0.2 alpha:1.0],
                                               UITextAttributeTextShadowColor : [UIColor whiteColor],
                                               UITextAttributeFont            : [UIFont fontWithName:@"Palatino" size:0.0]};
    NSDictionary *disabledButtonTextAttributes = @{UITextAttributeTextColor   : [UIColor colorWithWhite:0.5 alpha:1.0],
                                               UITextAttributeTextShadowColor : [UIColor whiteColor],
                                               UITextAttributeFont            : [UIFont fontWithName:@"Palatino" size:0.0]};
    
    [[UINavigationBar appearance] setTitleTextAttributes:navigationBarTextAttributes];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:buttonTextAttributes forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:buttonTextAttributes forState:UIControlStateHighlighted];
    [[UIBarButtonItem appearance] setTitleTextAttributes:disabledButtonTextAttributes forState:UIControlStateDisabled];
    
    return YES;
}

@end