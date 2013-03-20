//
//  TDNCollectionViewCell.h
//  Daily Nexus
//
//  TDNCollectionViewCell is a subclass of UICollectionViewCell that displays a story title, byline,
//  body and photo, if present, in a UICollectionView
//

#import <UIKit/UIKit.h>

@interface TDNCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *byline;
@property (nonatomic, retain) IBOutlet UITextView *story;
@property (nonatomic, retain) IBOutlet UIImageView *photo;

@end
