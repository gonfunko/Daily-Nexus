//
//  TDNArticleCollectionViewCell.m
//  Daily Nexus
//
//  Created by Aaron Dodson on 3/24/13.
//  Copyright (c) 2013 Daily Nexus. All rights reserved.
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
        
        [self addSubview:title];
        [self addSubview:byline];
        [self addSubview:story];
        [self addSubview:imageView];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(self.frame.size.width, self.story.frame.origin.y + self.story.frame.size.height + 10);
}

- (void)layoutSubviews {
    NSLog(@"layout subviews");
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
    
    self.story.frame = CGRectMake(10, verticalOffset, self.frame.size.width - 20, 0);
    [self.story sizeToFit];
}

@end
