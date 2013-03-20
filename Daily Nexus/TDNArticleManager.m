//
//  TDNArticleManager.m
//  Daily Nexus
//
//  TDNArticleManager is responsible for loading and maintaining a list of all available articles.
//

#import "TDNArticleManager.h"

@interface TDNArticleManager ()

@property (retain) NSMutableArray *articles;
@property (retain) TDNFeedParser *parser;

@end

@implementation TDNArticleManager

@synthesize articles;
@synthesize parser;
@synthesize delegate;

- (id)init {
    if (self = [super init]) {
        articles = [[NSMutableArray alloc] init];
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

- (void)loadAllArticles {
    
    if ([self.delegate respondsToSelector:@selector(articleManagerDidStartLoading)]) {
        [self.delegate articleManagerDidStartLoading];
    }
    
    // Create a request to download the main RSS feed
    NSURL *feedURL = [NSURL URLWithString:@"http://dailynexus.com/feed/"];
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
                                   
                                   [self.articles addObjectsFromArray:[self.parser articlesWithFeedData:[feedContents dataUsingEncoding:NSUTF8StringEncoding]]];
                               } else {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Load Articles"
                                                                                   message:error.localizedDescription
                                                                                  delegate:nil
                                                                         cancelButtonTitle:nil
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                               }
                               
                               // Notify our delegate we finished loading
                               if ([self.delegate respondsToSelector:@selector(articleManagerDidFinishLoading)]) {
                                   [self.delegate articleManagerDidFinishLoading];
                               }
                           }];
}

- (NSArray *)currentArticles {
    return self.articles;
}

@end
