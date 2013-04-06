#`@protocol TDNArticleManagerDelegate <NSObject>`#

TDNArticleManagerDelegate is a protocol for receiving notifications about loading activity in [TDNArticleManager](TDNArticleManager.md).

##Public Interface##

###Methods###
`- (void)articleManagerDidStartLoading;` - Called when the [TDNArticleManager](TDNArticleManager.md) begins loading articles from the RSS feed. **Optional.**

`- (void)articleManagerDidFinishLoading;` - Called when the [TDNArticleManager](TDNArticleManager.md) finishes loading articles from the RSS feed. **Optional.**