//
//  TDNArticleCollectionViewCell.h
//  Daily Nexus
//
//  Created by Aaron Dodson on 3/24/13.
//  Copyright (c) 2013 Daily Nexus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDNArticleCollectionViewCell : UICollectionViewCell

@property (retain, readonly) UILabel *title;
@property (retain, readonly) UILabel *byline;
@property (retain, readonly) UILabel *story;
@property (retain, readonly) UIImageView *imageView;

@end
