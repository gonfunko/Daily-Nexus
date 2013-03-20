//
//  TDNFrontPageViewController.m
//  Daily Nexus
//
//  TDNFrontPageViewController is responsible for managing the "front page" view that the user first
//  sees when launching the app and providing data and cells to the collection view that displays stories
//

#import "TDNFrontPageViewController.h"

@interface TDNFrontPageViewController ()

@end

@implementation TDNFrontPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoiseBackground"]];
    self.collectionView.backgroundView = backgroundView;
    
    self.title = @"The Daily Nexus";
}

@end
