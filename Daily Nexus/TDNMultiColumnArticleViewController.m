//
//  TDNMultiColumnArticleViewController.m
//  Daily Nexus
//
//  Created by Aaron Dodson on 3/23/13.
//  Copyright (c) 2013 Daily Nexus. All rights reserved.
//

#import "TDNMultiColumnArticleViewController.h"

@implementation TDNMultiColumnArticleViewController

@synthesize webview;
@synthesize scrollView;
@synthesize article;

- (void)viewWillAppear:(BOOL)animated {
    self.webview.scrollView.showsVerticalScrollIndicator = NO;
    self.webview.userInteractionEnabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    NSString *html = [self.article htmlRepresentationWithHeight:self.view.frame.size.height - 20];
    [self.webview loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.dailynexus.com"]];
    self.webview.delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.webview.frame = CGRectMake(0, 0, self.webview.scrollView.contentSize.width, self.webview.scrollView.contentSize.height);
    self.scrollView.contentSize = self.webview.scrollView.contentSize;
}

@end
