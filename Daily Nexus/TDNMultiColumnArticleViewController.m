//
//  TDNMultiColumnArticleViewController.m
//  Daily Nexus
//
//  TDNMultiColumnArticleViewController uses a UIWebView and CSS 3 to display story text in a multi-column
//  format along with the title, byline and image(s)
//

#import "TDNMultiColumnArticleViewController.h"

@interface TDNMultiColumnArticleViewController ()

@property (retain) UIWebView *webview;

@end

@implementation TDNMultiColumnArticleViewController

@synthesize article;
@synthesize webview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Set our webview property to our view (which is actually a webview)
        self.webview = (UIWebView *)self.view;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"NoiseBackground"]];
    
    // Disable vertical scrolling and bouncing (because the webview irritatingly draws shadows. It'd be nice to have bounce)
    self.webview.scrollView.showsVerticalScrollIndicator = NO;
    self.webview.scrollView.bounces = NO;
    
    // Get the HTML representation of our article and load it
    NSString *html = [self.article htmlRepresentationWithHeight:self.view.frame.size.height - 20];
    [self.webview loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.dailynexus.com"]];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // After we rotate, change the height of the main container div to whatever the new view height is
    NSString *heightChange = [NSString stringWithFormat:@"document.getElementById('container').style.height = '%fpx';", self.view.frame.size.height - 20];
    [self.webview stringByEvaluatingJavaScriptFromString:heightChange];
}

@end
