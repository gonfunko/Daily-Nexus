//
//  TDNFrontPageViewController.m
//  Daily Nexus
//
//  TDNFrontPageViewController is responsible for managing the "front page" view that the user first
//  sees when launching the app and providing data and cells to the collection view that displays stories
//

#import "TDNFrontPageViewController.h"

@interface TDNFrontPageViewController ()

@property (retain) NSMutableDictionary *images;

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
    
    self.images = [[NSMutableDictionary alloc] init];
}

- (void)articleManagerDidFinishLoading {
    [self loadImages];
    [self.collectionView reloadData];
}

- (void)loadImages {
    for (TDNArticle *article in [[TDNArticleManager sharedManager] currentArticles]) {
        for (NSString *urlString in article.images) {
            NSURL *imageURL = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (data) {
                    UIImage *image = [UIImage imageWithData:data];
                    if (image) {
                        [self.images setObject:image forKey:urlString];
                        [self.collectionView reloadData];
                    }
                }
            }];
        }
    }
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
    
    if ([article.images count] != 0) {
        cell.photo.image = [self.images objectForKey:[article.images objectAtIndex:0]];
    }
    
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
