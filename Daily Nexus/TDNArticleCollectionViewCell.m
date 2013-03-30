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

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialize and configure our various subviews
        title = [[UILabel alloc] init];
        byline = [[UILabel alloc] init];
        story = [[UILabel alloc] init];
        imageView = [[UIImageView alloc] init];
        
        title.numberOfLines = 0;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        title.font = [UIFont fontWithName:@"Palatino-Bold" size:24.0];
        title.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        title.backgroundColor = [UIColor clearColor];
        title.opaque = YES;
        
        byline.numberOfLines = 0;
        byline.lineBreakMode = NSLineBreakByWordWrapping;
        byline.font = [UIFont fontWithName:@"Palatino" size:12.0];
        byline.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        byline.backgroundColor = [UIColor clearColor];
        byline.opaque = YES;
        
        story.numberOfLines = 0;
        story.lineBreakMode = NSLineBreakByWordWrapping;
        story.font = [UIFont fontWithName:@"Palatino" size:16.0];
        story.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        story.backgroundColor = [UIColor clearColor];
        story.opaque = YES;
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        
        // Actually make them subviews
        [self addSubview:title];
        [self addSubview:byline];
        [self addSubview:story];
        [self addSubview:imageView];
        
        self.opaque = YES;
        
        // Set up a highlight color when we're selected
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
        selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        selectedBackgroundView.layer.cornerRadius = 5.0;
        [self setSelectedBackgroundView:selectedBackgroundView];
    }
    return self;
}

- (void)prepareForReuse {
    self.title.text = @"";
    self.byline.text = @"";
    self.story.text = @"";
    self.imageView.image = nil;
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
        /* Make sure we have some text showing, even if the image is portrait – set the height to the
           lesser of the image's height when scaled to the desired width, or the total cell height
           minus 203 (the 3 is to avoid truncating descenders on the article text) */
        self.imageView.frame = CGRectMake(10, verticalOffset, self.frame.size.width - 20, MIN(((self.frame.size.width - 20) / imageView.image.size.width) * imageView.image.size.height, self.frame.size.height - 203));
        verticalOffset += self.imageView.frame.size.height + 10;
    }
    
    // Set our frame to something that will fit our contents
    self.story.frame = CGRectMake(10, verticalOffset, self.frame.size.width - 20, self.frame.size.height - (verticalOffset + 20));
}

@end
