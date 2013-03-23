//
//  TDNArticleView.m
//  Daily Nexus
//
//  TDNArticleView displays an article's title, byline, image and text
//

#import "TDNArticleView.h"

@interface TDNArticleView ()

@property (retain) UILabel *title;
@property (retain) UILabel *byline;
@property (retain) UIImageView *imageView;
@property (retain) UITextView *story;

@end

@implementation TDNArticleView

@synthesize article;
@synthesize title;
@synthesize byline;
@synthesize imageView;
@synthesize story;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // Initialize all our properties
        title = [[UILabel alloc] init];
        byline = [[UILabel alloc] init];
        imageView = [[UIImageView alloc] init];
        story = [[UITextView alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Set the appearance of the various text labels, and allow them to wrap text onto new lines
    self.title.numberOfLines = 0;
    self.title.backgroundColor = [UIColor clearColor];
    self.title.font = [UIFont fontWithName:@"Palatino-Bold" size:24.0];
    self.title.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    
    self.byline.numberOfLines = 0;
    self.byline.backgroundColor = [UIColor clearColor];
    self.byline.font = [UIFont fontWithName:@"Palatino" size:14.0];
    self.byline.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    
    self.story.editable = NO;
    self.story.scrollEnabled = NO;
    self.story.backgroundColor = [UIColor clearColor];
    self.story.font = [UIFont fontWithName:@"Palatino" size:16.0];
    self.story.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    self.story.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypePhoneNumber;
    
    // Add all our child views
    [self addSubview:self.title];
    [self addSubview:self.byline];
    [self addSubview:self.imageView];
    [self addSubview:self.story];
    
    // And make our background clear so the noise texture shows through
    self.backgroundColor = [UIColor clearColor];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

// Even though we have an article property, override the setter to configure the view when the article changes
- (void)setArticle:(TDNArticle *)newArticle {
    article = newArticle;
    
    // Set the title's text to the article's title
    title.text = article.title;
    
    // Create an NSDateFormatter to get a nice date representation in the byline
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM d, YYYY"];
    // Generate the byline text
    byline.text = [NSString stringWithFormat:@"Published %@ by %@", [formatter stringFromDate:article.publicationDate], article.author];
    
    // If we have an image, display it in the image view
    if ([article.images count] != 0) {
        self.imageView.image = [article.images objectAtIndex:0];
    }
    
    // And show the story text
    story.text = article.story;
    
    // We need to update the bounds of our subviews to fit their contents
    [self layoutSubviews];
    
    // Once that's done, set the frame of the whole view to contain all the subviews
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.story.frame.origin.y + self.story.frame.size.height + 10)];
}

- (CGSize)sizeThatFits:(CGSize)size {
    // The view's desired size is whatever its width is and enough height to fully display all subviews
    return CGSizeMake(self.bounds.size.width, self.story.frame.origin.y + self.story.frame.size.height + 10);
}

- (void)layoutSubviews {
    // Start with 10 points of padding from the top of the view
    NSInteger verticalOffset = 10;
    
    // Position the title, and size it to fit (make it tall enough to show all line(s) of text)
    self.title.frame = CGRectMake(10, verticalOffset, self.frame.size.width - 20, 0);
    [self.title sizeToFit];
    
    // Increment the vertical offset by the height of the title plus some padding
    verticalOffset += (self.title.frame.size.height + 5);
    
    // Position the byline and size it to fit
    self.byline.frame = CGRectMake(10, verticalOffset, self.frame.size.width - 20, 0);
    [self.byline sizeToFit];
    
    // Increment the vertical offset to account for the byline
    verticalOffset += (self.byline.frame.size.height + 20);
    
    // If we have an image, position the image view
    if ([self.article.images count] != 0) {
        UIImage *image = [self.article.images objectAtIndex:0];
        // Set the frame to maintain the image's aspect ratio and fill the width of the screen (minus some padding)
        self.imageView.frame = CGRectMake(10, verticalOffset, self.frame.size.width - 20, image.size.height * ((self.frame.size.width - 20) / image.size.width));
        verticalOffset += (self.imageView.frame.size.height + 20);
    }
    
    // Finally, set the frame of the main story text
    self.story.frame = CGRectMake(0, verticalOffset, self.frame.size.width, 0);
    self.story.frame = CGRectMake(0, verticalOffset, self.frame.size.width, self.story.contentSize.height);

    [self.story sizeToFit];
}

@end
;