//
//  TDNArticleCollectionViewCell.m
//  Daily Nexus
//
//  TDNArticleCollectionViewCell displays the contents of an article in a UICollectionView
//

#import "TDNArticleCollectionViewCell.h"

@interface TDNArticleCollectionViewCell ()

@property (retain, readwrite) UILabel *title;
@property (retain, readwrite) UILabel *byline;
@property (retain, readwrite) UILabel *story;
@property (retain, readwrite) UIImageView *imageView;

@end

@implementation TDNArticleCollectionViewCell

@synthesize title;
@synthesize byline;
@synthesize story;
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize and configure our various subviews
        title = [[UILabel alloc] init];
        byline = [[UILabel alloc] init];
        story = [[UILabel alloc] init];
        imageView = [[UIImageView alloc] init];
        
        title.backgroundColor = [UIColor clearColor];
        title.numberOfLines = 0;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        title.font = [UIFont fontWithName:@"Palatino-Bold" size:24.0];
        title.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        
        byline.backgroundColor = [UIColor clearColor];
        byline.numberOfLines = 0;
        byline.lineBreakMode = NSLineBreakByWordWrapping;
        byline.font = [UIFont fontWithName:@"Palatino" size:12.0];
        byline.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        
        story.backgroundColor = [UIColor clearColor];
        story.numberOfLines = 5;
        story.lineBreakMode = NSLineBreakByWordWrapping;
        story.font = [UIFont fontWithName:@"Palatino" size:16.0];
        story.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        
        // Actually make them subviews
        [self addSubview:title];
        [self addSubview:byline];
        [self addSubview:story];
        [self addSubview:imageView];
        
        // Set up a highlight color when we're selected
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
        selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        selectedBackgroundView.layer.cornerRadius = 5.0;
        [self setSelectedBackgroundView:selectedBackgroundView];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    // Our ideal size is whatever our width is and high enough to completely fit the story
    return CGSizeMake(self.frame.size.width, self.story.frame.origin.y + self.story.frame.size.height + 10);
}

- (void)layoutSubviews {
    // Go through our views and set their frames appropriately
    NSInteger verticalOffset = 10;
    
    self.title.frame = CGRectMake(10, verticalOffset, self.frame.size.width - 20, 0);
    [self.title sizeToFit];
    verticalOffset += self.title.frame.size.height + 10;
    
    self.byline.frame = CGRectMake(10, verticalOffset, self.frame.size.width - 20, 0);
    [self.byline sizeToFit];
    verticalOffset += self.byline.frame.size.height + 10;
    
    if (self.imageView.image != nil) {
        self.imageView.frame = CGRectMake(10, verticalOffset, self.frame.size.width - 20, (imageView.image.size.width / (self.frame.size.width - 20)) * imageView.image.size.height);
        verticalOffset += self.imageView.frame.size.height + 10;
    }
    
    // Set our frame to something that will fit our contents
    self.story.frame = CGRectMake(10, verticalOffset, self.frame.size.width - 20, 0);
    [self.story sizeToFit];
}

@end
