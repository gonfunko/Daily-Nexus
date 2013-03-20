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
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TDNCollectionViewLeftImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"leftImageCell"];
    
    [TDNArticleManager sharedManager].delegate = self;
    [[TDNArticleManager sharedManager] loadAllArticles];
    
    self.title = @"The Daily Nexus";
}

- (void)articleManagerDidFinishLoading {
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[TDNArticleManager sharedManager] currentArticles] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TDNArticle *article = [[[TDNArticleManager sharedManager] currentArticles] objectAtIndex:indexPath.row];
    
    TDNCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"leftImageCell" forIndexPath:indexPath];
    
    cell.title.text = article.title;
    cell.byline.text = [NSString stringWithFormat:@"Published %@ by %@", [article.publicationDate description], article.author];
    cell.story.text = article.story;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width, 255.0);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.collectionView performBatchUpdates:nil completion:nil];
}

- (void)dealloc {
    [TDNArticleManager sharedManager].delegate = nil;
}

@end
