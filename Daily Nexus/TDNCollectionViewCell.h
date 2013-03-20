//
//  TDNCollectionViewCell.h
//  Daily Nexus
//
//  Created by Aaron Dodson on 3/20/13.
//  Copyright (c) 2013 Daily Nexus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDNCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *byline;
@property (nonatomic, retain) IBOutlet UITextView *story;
@property (nonatomic, retain) IBOutlet UIImageView *photo;

@end
