//
//  TDNCommentPostingViewController.h
//  Daily Nexus
//
//  TDNCommentPostingViewController is responsible for displaying a view that allows the user to
//  enter comments and posting these comments to the Daily Nexus website
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TDNArticle.h"

@interface TDNCommentPostingViewController : UIViewController

@property (retain, nonatomic) TDNArticle *article;
@property (retain, nonatomic) NSString *nonce;

@end
