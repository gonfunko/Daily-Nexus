//
//  TDNAboutViewController.m
//  Daily Nexus
//
//  TDNAboutViewController presents and configures the About view
//

#import "TDNAboutViewController.h"

@interface TDNAboutViewController ()

@property (retain, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation TDNAboutViewController

@synthesize webview;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Add a container view to hold the app icon and draw its shadow
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 72) / 2, 20, 72, 72)];
    container.layer.shadowOffset = CGSizeMake(0, 1);
    container.layer.shadowOpacity = 0.7;
    container.layer.shadowRadius = 3.0;
    container.layer.shadowColor = [UIColor blackColor].CGColor;
    container.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:container.bounds cornerRadius:12.63] CGPath];
    container.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    // Create a CALayer that displays the app icon
    CALayer *icon = [[CALayer alloc] init];
    icon.contents = (id)[UIImage imageNamed:@"Icon-72"].CGImage;
    icon.cornerRadius = 12.63;
    icon.masksToBounds = YES;
    icon.frame = CGRectMake(0, 0, 72, 72);
    [container.layer addSublayer:icon];
    [self.view addSubview:container];

    // Load the credits
    NSString *credits = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"credits" ofType:@"html"]
                                              usedEncoding:nil
                                                     error:nil];
    [self.webview loadHTMLString:credits baseURL:[NSURL URLWithString:@"http://www.dailynexus.com"]];
    
    // Configure the webview to be transparent
    self.webview.backgroundColor = [UIColor clearColor];
    self.webview.opaque = NO;
    
    // Hide any image views on the webview to hide its shadow. This is an awful hack, and should be
    // replaced if or when APIs to do so become available
    for (UIView *view in self.webview.scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.hidden = YES;
        }
    }
    
    self.webview.delegate = self;
    
    // Set our title and add a button to dismiss the About view
    self.title = @"About";
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] init];
    doneButton.title = @"Done";
    doneButton.target = self;
    doneButton.action = @selector(dismissAboutView);
    self.navigationItem.rightBarButtonItem = doneButton;

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[request.URL absoluteString] isEqualToString:@"http://www.dailynexus.com/"]) {
        return YES;
    } else {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
}

- (void)dismissAboutView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
