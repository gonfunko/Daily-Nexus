#`TDNArticleCollectionViewCell : UICollectionViewCell`#

TDNArticleCollectionViewCell displays the contents of an article in a UICollectionView.

##Public Interface##

###Properties###
`@property (retain, readonly) UILabel *title;` - A UILabel intended to display the represented article's title

`@property (retain, readonly) UILabel *byline;` - A UILabel intended to display the represented article's byline

`@property (retain, readonly) UILabel *story;` - A UILabel intended to display the represented article's text

`@property (retain, readonly) UIImageView *imageView;` - A UIImageView that displays the represented article's image, if any