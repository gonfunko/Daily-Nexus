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

@end

@implementation TDNArticleViewController

@synthesize article;
@synthesize webview;
@synthesize columnated;

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"NoiseBackground"]];
    
    // Disable vertical scrolling on the iPad and bouncing (because the webview irritatingly draws shadows. It'd be nice to have bounce)
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ) {
        self.webview.scrollView.showsVerticalScrollIndicator = NO;
    }
    
    self.webview.scrollView.bounces = NO;
    
    // Get the HTML representation of our article and load it
    NSString *html = [self.article htmlRepresentationWithHeight:self.view.frame.size.height - 45 andColumns:self.columnated];
    [self.webview loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.dailynexus.com"]];
    
    if ([self.article.categories count] != 0) {
        self.title = [self.article.categories objectAtIndex:0];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showShareSheet:)];
}

- (void)showShareSheet:(id)sender {
    // Create and display a share sheet with the article's contents/link
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[self] applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypePostToWeibo];
    [self presentViewController:activityController animated:YES completion:nil];
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

@end
