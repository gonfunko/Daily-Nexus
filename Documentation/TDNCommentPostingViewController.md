#`TDNCommentPostingViewController : UIViewController`#

TDNCommentPostingViewController is responsible for displaying a view that allows the user to enter comments and posting these comments to the Daily Nexus website

##Public Interface##

###Properties###
`@property (retain, nonatomic) TDNArticle *article;` - The article to post comments about.

`@property (retain, nonatomic) NSString *nonce;` - The Askimet nonce value from the article page, to allow comments to get past the anti-spam system.

##Imported Classes##
* [TDNArticle](TDNArticle.md)