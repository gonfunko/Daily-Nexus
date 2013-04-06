#`TDNFrontPageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, TDNArticleManagerDelegate>`#

TDNFrontPageViewController manages the table view (iPhone) or collection view (iPad) that lists the current stories. It also handles creating and presenting a [TDNArticleView](TDNArticleView.md) when the user selects a story. Although a subclass of UIViewController, it implements the delegate and data source methods for both UITableView and UICollectionView. Which set of methods is called depends on the current device.

##Imported Classes##
* [TDNArticleManager](TDNArticleManager.md)
* [TDNArticleViewController](TDNArticleViewController.md)
* [TDNArticleCollectionViewCell](TDNArticleCollectionViewCell.md)
* [TDNLoadingView](TDNLoadingView.md)
* [TDNEtchedSeparatorTableViewCell](TDNEtchedSeparatorTableViewCell.md)
* [UIImage+TDNAdditions](UIImage+TDNAdditions.md)