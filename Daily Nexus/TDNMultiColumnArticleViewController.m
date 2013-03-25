//
//  TDNMultiColumnArticleViewController.m
//  Daily Nexus
//
//  TDNMultiColumnArticleViewController uses a UIWebView and CSS 3 to display story text in a multi-column
//  format along with the title, byline and image(s)
//

#import "TDNMultiColumnArticleViewController.h"

@interface TDNMultiColumnArticleViewController ()

@property (retain, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation TDNMultiColumnArticleViewController

@synthesize article;
@synthesize webview;
@synthesize columnated;

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"NoiseBackground"]];
    
    // Disable vertical scrolling and bouncing (because the webview irritatingly draws shadows. It'd be nice to have bounce)
    self.webview.scrollView.showsVerticalScrollIndicator = NO;
    self.webview.scrollView.bounces = NO;
    
    // Get the HTML representation of our article and load it
    NSString *html = [self.article htmlRepresentationWithHeight:self.view.frame.size.height - 45 andColumns:self.columnated];
    [self.webview loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.dailynexus.com"]];
    
    if ([self.article.categories count] != 0) {
        self.title = [self.article.categories objectAtIndex:0];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // After we rotate, change the height of the main container div to whatever the new view height is
    NSString *heightChange = [NSString stringWithFormat:@"document.getElementById('container').style.height = '%fpx';", self.view.frame.size.height - 45];
    [self.webview stringByEvaluatingJavaScriptFromString:heightChange];
}

@end
