//
//  TDNArticleCollectionViewCell.h
//  Daily Nexus
//
//  TDNArticleCollectionViewCell displays the contents of an article in a UICollectionView
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TDNArticleCollectionViewCell : UICollectionViewCell

@property (retain, readonly) UILabel *title;
@property (retain, readonly) UILabel *byline;
@property (retain, readonly) UILabel *story;
@property (retain, readonly) UIImageView *imageView;

@end
