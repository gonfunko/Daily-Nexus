#`TDNArticleViewController : UIViewController <UIWebViewDelegate, UIGestureRecognizerDelegate, UIPopoverControllerDelegate, UIScrollViewDelegate>`#

TDNArticleViewController uses a UIWebView and CSS 3 to display story text along with the title, byline and image

##Public Interface##

###Properties###
`@property (retain) TDNArticle *article;` - [TDNArticle](TDNArticle.md) object corresponding to the article being displayed by the view controller's view. Should be set before the view controller is presented.

`@property (assign) BOOL columnated;` - If true, the article text is presented in columns scrolling left to right; if false, article text is displayed in a single column scrolling up and down

##Imported Classes##
* [TDNArticleManager](TDNArticleManager.md)
* [TDNArticle](TDNArticle.md)