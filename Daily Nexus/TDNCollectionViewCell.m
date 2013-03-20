//
//  TDNCollectionViewCell.m
//  Daily Nexus
//
//  TDNCollectionViewCell is a subclass of UICollectionViewCell that displays a story title, byline,
//  body and photo, if present, in a UICollectionView
//

#import "TDNCollectionViewCell.h"

@implementation TDNCollectionViewCell

@synthesize title;
@synthesize byline;
@synthesize story;
@synthesize photo;

- (void)awakeFromNib {
    [photo setClipsToBounds:YES];
}

- (void)prepareForReuse {
    // Clear out everything before this cell gets reused in case its new value doesn't have one of these fields
    self.title.text = @"";
    self.byline.text = @"";
    self.story.text = @"";
    self.photo.image = nil;
}

@end
