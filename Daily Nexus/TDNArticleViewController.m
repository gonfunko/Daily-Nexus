//
//  TDNArticleViewController.m
//  Daily Nexus
//
//  TDNArticleViewController uses a UIWebView and CSS 3 to display story text
//  along with the title, byline and image(s)
//

#import "TDNArticleViewController.h"

@interface TDNArticleViewController ()

@property (retain, nonatomic) IBOutlet UIWebView *webview;
@property (retain) UIPopoverController *popoverController;

@end

@implementation TDNArticleViewController

@synthesize article;
@synthesize webview;
@synthesize columnated;
@synthesize popoverController;

- (void)viewWillAppear:(BOOL)animated {
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoiseBackground"]];
    backgroundView.contentMode = UIViewContentModeCenter;
    backgroundView.frame = self.view.frame;
    backgroundView.layer.masksToBounds = YES;
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:backgroundView atIndex:0];
    
    self.webview.delegate = self;
    
    self.webview.scrollView.bounces = YES;
    
    // Disable vertical scrolling on the iPad and horizontal scrolling on the iPhone
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ) {
        self.webview.scrollView.showsVerticalScrollIndicator = NO;
        self.webview.scrollView.alwaysBounceHorizontal = YES;
        self.webview.scrollView.alwaysBounceVertical = NO;
    } else {
        self.webview.scrollView.alwaysBounceHorizontal = NO;
        self.webview.scrollView.alwaysBounceVertical = YES;
    }
    
    // Hide any image views on the webview to hide its shadow. This is an awful hack, and should be
    // replaced if or when APIs to do so become available
    for (UIView *view in self.webview.scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.hidden = YES;
        }
    }
    
    // Set up and add the share button to the right of the navigation bar
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareButton addTarget:self
                    action:@selector(showShareSheet:)
          forControlEvents:UIControlEventTouchUpInside];
    shareButton.frame = CGRectMake(0, 0, 40, 30);
    
    UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItem = shareBarButtonItem;
    
    // Set up and configure the back button, and hide the system default
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self
                   action:@selector(dismissArticleView)
         forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.navigationItem.hidesBackButton = YES;
    
    // Set up a tap recognizer for two taps
    UITapGestureRecognizer *twoTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    twoTapRecognizer.numberOfTapsRequired = 2;
    twoTapRecognizer.delegate = self;
    [self.webview addGestureRecognizer:twoTapRecognizer];
    
    // Set up another tap recognizer for three taps
    UITapGestureRecognizer *threeTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    threeTapRecognizer.numberOfTapsRequired = 3;
    threeTapRecognizer.delegate = self;
    [self.webview addGestureRecognizer:threeTapRecognizer];
    
    // Make sure the two tap recognizer only gets called if there's no third tap
    [twoTapRecognizer requireGestureRecognizerToFail:threeTapRecognizer];
    
    [self loadCurrentArticle];
}

- (void)loadCurrentArticle {
    // Get the HTML representation of our article and load it
    NSString *html = [self.article htmlRepresentationWithHeight:self.view.frame.size.height - 45 andColumns:self.columnated];
    [self.webview loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.dailynexus.com"]];
    
    if ([self.article.categories count] != 0) {
        self.title = [self.article.categories objectAtIndex:0];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[request.URL absoluteString] isEqualToString:@"http://www.dailynexus.com/"]) {
        return YES;
    } else {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // We need to allow both the two and three tap gestures to be simultaneously recognized
    return YES;
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    // Make sure the gesture recognizer has recognized the full gesture
    if (sender.state == UIGestureRecognizerStateEnded) {
        // If so, identify the index of the article we're currently displaying
        NSInteger currentArticle = [[TDNArticleManager sharedManager].articles indexOfObject:self.article];
        
        if (currentArticle != NSNotFound) {
            // If we recognized two taps and this isn't the last article, advance to the next one
            if (sender.numberOfTapsRequired == 2 && currentArticle + 1 < [[TDNArticleManager sharedManager].articles count]) {
                self.article = [[TDNArticleManager sharedManager].articles objectAtIndex:currentArticle + 1];
            // If we instead recognized three taps and this isn't the first article, advance to the previous one
            } else if (sender.numberOfTapsRequired == 3 && currentArticle - 1 >= 0) {
                self.article = [[TDNArticleManager sharedManager].articles objectAtIndex:currentArticle - 1];
            }
        }
        
        // Load the new article
        [self loadCurrentArticle];
    }
}

- (void)showShareSheet:(id)sender {
    // Create and display a share sheet with the article's contents/link
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[self] applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypePostToWeibo];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityController animated:YES completion:nil];
    } else {
        if (self.popoverController == nil) {
            activityController.completionHandler = ^(NSString *activityType, BOOL completed) {
                self.popoverController = nil;
            };
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:activityController];
            self.popoverController.delegate = self;
            [self.popoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem
                                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                                           animated:YES];
        } else {
            [self.popoverController dismissPopoverAnimated:YES];
            self.popoverController = nil;
        }
    }
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    if ([activityType isEqualToString:UIActivityTypePostToFacebook] ||
        [activityType isEqualToString:UIActivityTypePostToTwitter] ||
        [activityType isEqualToString:UIActivityTypeMessage]) {
        // If we're providing data for a short message based service, just return the story's URL
        return [NSURL URLWithString:self.article.url];
    } else {
        // Otherwise, return the actual story text
        return self.article.story;
    }
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return self.article.story;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // After we rotate, change the height of the main container div to whatever the new view height is
    NSString *heightChange = [NSString stringWithFormat:@"document.getElementById('container').style.height = '%fpx';", self.view.frame.size.height - 45];
    [self.webview stringByEvaluatingJavaScriptFromString:heightChange];
}

- (void)dismissArticleView {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
