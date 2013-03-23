//
//  TDNArticleViewController.m
//  Daily Nexus
//
//  TDNArticleViewController is responsible for presenting and managing a view that displays a single article.
//

#import "TDNArticleViewController.h"

@interface TDNArticleViewController ()

@end

@implementation TDNArticleViewController

@synthesize article;
@synthesize articleView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set our view's article property to the article we're displaying
    self.articleView.article = self.article;
    // And update the scroll view's content size so it can scroll
    ((UIScrollView *)self.view).contentSize = self.articleView.frame.size;
    
    // If the article has a category, use the first one as the navigation bar title
    if ([self.article.categories count] != 0) {
        self.title = [self.article.categories objectAtIndex:0];
    }
    
    // Add the noise texture to our view
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"NoiseBackground"]];
}

@end
