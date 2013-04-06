#`TDNArticleManager : NSObject`#

TDNArticleManager is responsible for loading and maintaining a list of all available articles.

##Public Interface##

###Properties###
`@property (retain) id <TDNArticleManagerDelegate> delegate;` - The [TDNArticleManager](TDNArticleManager.md)'s delegate, which receives notifications when it begins and finishes loading articles

`@property (retain, readonly) NSArray *articles;` - A read-only list of the articles in the current section

`@property (retain) TDNArticle *currentArticle;` - The article selected in the [TDNFrontPageViewController](TDNFrontPageViewController.md) (presented in a [TDNArticleView](TDNArticleView.md)), if any

`@property (copy) NSString *currentSection;` - The name of the section currently selected in the [TDNSectionViewController](TDNSectionViewController.md)'s table

###Methods###
`+ (TDNArticleManager *)sharedManager;` - Returns the shared singleton instance of [TDNArticleManager](TDNArticleManager.md)

`- (void)loadArticles;` - Loads the RSS feed corresponding to the current section, parses its contents, stores them in the articles property, and notifies the delegate (if any) when the process begins and ends

`- (void)removeAllArticles;` - Sets the articles property to an empty array

###Protocols###
* [TDNArticleManagerDelegate](TDNArticleManagerDelegate.md)

##Imported Classes##
* [TDNFeedParser](TDNFeedParser.md)
* [TDNArticle](TDNArticle.md)