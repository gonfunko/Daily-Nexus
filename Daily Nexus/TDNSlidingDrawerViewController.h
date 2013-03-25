//
//  TDNSlidingDrawerViewController.h
//  Daily Nexus
//
//  TDNSlidingDrawerViewController uses view controller containment to create a three-view sliding
//  drawer view controller as used in the Facebook app, in which the main view can be slid aside
//  to reveal a secondary view to the left or right
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TDNSlidingDrawerViewController : UIViewController

@property (retain) UIViewController *mainViewController;
@property (retain) UIViewController *leftViewController;
@property (retain) UIViewController *rightViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil mainViewController:(UIViewController *)main leftViewController:(UIViewController *)left andRightViewController:(UIViewController *)right;
- (void)toggleLeftDrawer;
- (void)toggleRightDrawer;

@end
