//
//  TDNArticleManager.m
//  Daily Nexus
//
//  TDNArticleManager is responsible for loading and maintaining a list of all available articles.
//

#import "TDNArticleManager.h"

@interface TDNArticleManager ()

@property (retain, readwrite) NSArray *articles;
@property (retain) TDNFeedParser *parser;

@end

@implementation TDNArticleManager

@synthesize articles;
@synthesize parser;
@synthesize delegate;
@synthesize currentArticle;

- (id)init {
    if (self = [super init]) {
        articles = [[NSArray alloc] init];
        parser = [[TDNFeedParser alloc] init];
    }
    
    return self;
}

+ (TDNArticleManager *)sharedManager {
    static TDNArticleManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[TDNArticleManager alloc] init];
    });
    
    return sharedManager;
}

- (void)loadArticlesInSection:(NSString *)section {
    
    if ([self.delegate respondsToSelector:@selector(articleManagerDidStartLoading)]) {
        [self.delegate articleManagerDidStartLoading];
    }
    
    NSDictionary *feedURLs = @{@"Features"       : @"http://dailynexus.com/category/feature/feed/",
                               @"News"           : @"http://dailynexus.com/category/news/feed/",
                               @"Sports"         : @"http://dailynexus.com/category/sports/feed/",
                               @"Opinion"        : @"http://dailynexus.com/category/opinion/feed/",
                               @"Artsweek"       : @"http://dailynexus.com/category/artsweek/feed/",
                               @"On the Menu"    : @"http://dailynexus.com/category/on-the-menu/feed/",
                               @"Science & Tech" : @"http://dailynexus.com/category/science/feed/",
                               @"Online"         : @"http://dailynexus.com/category/online-2/feed/",
                               @"Most Recent"    : @"http://dailynexus.com/feed/"};
    
    // Create a request to download the main RSS feed
    NSURL *feedURL = [NSURL URLWithString:[feedURLs objectForKey:section]];
    NSURLRequest *feedDownloadRequest = [[NSURLRequest alloc] initWithURL:feedURL];
    
    // Attempt to load the feed
    [NSURLConnection sendAsynchronousRequest:feedDownloadRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               // If we get data, parse the articles, otherwise display an error
                               if (data) {
                                   /* Normally, we could just parse the data, but the Nexus RSS feed has a leading newline before the XML declaration. This
                                      makes it invalid XML and causes NSXMLParser to error out, so we convert the raw data to a string, trim whitespace 
                                      and newlines, convert it back to data and then parse that. */
                                   NSString *feedContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   feedContents = [feedContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                   
                                   self.articles = [self.parser articlesWithFeedData:[feedContents dataUsingEncoding:NSUTF8StringEncoding]];
                               } else {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Load Articles"
                                                                                   message:error.localizedDescription
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                               }
                               
                               // Notify our delegate we finished loading
                               if ([self.delegate respondsToSelector:@selector(articleManagerDidFinishLoading)]) {
                                   [self.delegate articleManagerDidFinishLoading];
                               }
                           }];
}

- (void)removeAllArticles {
    self.articles = [NSArray array];
}

@end
