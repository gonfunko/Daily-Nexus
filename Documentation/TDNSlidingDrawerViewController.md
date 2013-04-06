#`TDNSlidingDrawerViewController : UIViewController <UIGestureRecognizerDelegate>`#

TDNSlidingDrawerViewController uses view controller containment to create a three-view sliding drawer view controller as used in the Facebook app, in which the main view can be slid aside to reveal a secondary view to the left or right

##Public Interface##

###Properties###
`@property (retain) UIViewController *mainViewController;` - The view controller displayed by default

`@property (retain) UIViewController *leftViewController;` - The view controller displayed on the left as a drawer

`@property (retain) UIViewController *rightViewController;` - The view controller displayed on the right as a drawer

###Methods###
`- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil mainViewController:(UIViewController *)main leftViewController:(UIViewController *)left andRightViewController:(UIViewController *)right;` - The designated initializer. Calls super's implementation of `initWithNibName:bundle:` and sets the view controller properties with the other arguments

`- (void)toggleLeftDrawer;` - Hides or shows the left drawer

`- (void)toggleRightDrawer;` - Hides or shows the right drawer