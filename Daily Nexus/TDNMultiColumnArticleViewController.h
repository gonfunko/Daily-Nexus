//
//  TDNMultiColumnArticleViewController.h
//  Daily Nexus
//
//  Created by Aaron Dodson on 3/23/13.
//  Copyright (c) 2013 Daily Nexus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDNArticle.h"

@interface TDNMultiColumnArticleViewController : UIViewController <UIWebViewDelegate>

@property (retain, nonatomic) IBOutlet UIWebView *webview;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain) TDNArticle *article;

@end
