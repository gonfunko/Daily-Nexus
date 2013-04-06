//
//  TDNSectionViewController.m
//  Daily Nexus
//
//  TDNSectionViewController is responsible for displaying and selecting sections to show articles from
//

#import "TDNSectionViewController.h"

@interface TDNSectionViewController ()

@property (retain) NSArray *sections;
@property (retain) NSArray *images;
@property (assign) NSInteger selectedIndex;

@end

@implementation TDNSectionViewController

@synthesize sections;
@synthesize images;
@synthesize selectedIndex;

- (void)viewDidLoad {
    self.selectedIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    // Set up our background view
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoiseBackground"]];
    backgroundView.contentMode = UIViewContentModeCenter;
    self.tableView.backgroundView = backgroundView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.sections = @[@"Most Recent", @"Features", @"News", @"Sports", @"Opinion", @"Artsweek", @"On the Menu", @"Science & Tech", @"Online"];
    
    /* Image credits:
     Star from The Noun Project
     Idea designed by Andrew Laskey from The Noun Project
     Erlenmeyer Flask designed by Emily van den Heever from The Noun Project
     Earth designed by Nicolas Ramallo from The Noun Project
     Newspaper designed by John Caserta from The Noun Project
     Gymnasium designed by Edward Boatman, Mike Clare & Jessica Durkin from The Noun Project
     Art Gallery designed by Saman Bemel-Benrud from The Noun Project
     Fast Food designed by Jinju Jang from The Noun Project
     Calendar designed by Adrijan Karavdić from The Noun Project */
    
    self.images = @[@"recent", @"features", @"news", @"sports", @"opinion", @"art", @"food", @"science", @"online"];
    [self.tableView reloadData];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionTop];
    
    self.title = @"Sections";
    
    // Create a button to show the About window and add it as a footer view in the table
    UIButton *aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aboutButton setTitle:@"Daily Nexus 1.0" forState:UIControlStateNormal];
    [aboutButton setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateNormal];
    aboutButton.titleLabel.font = [UIFont fontWithName:@"Palatino" size:10.0];
    aboutButton.backgroundColor = [UIColor clearColor];
    [aboutButton addTarget:self
                    action:@selector(showAboutView)
          forControlEvents:UIControlEventTouchUpInside];
    [aboutButton sizeToFit];
    aboutButton.frame = CGRectMake(0,  self.view.frame.size.height - aboutButton.frame.size.height - 10, self.view.frame.size.width, 30);
    self.tableView.tableFooterView = aboutButton;
}

- (void)showAboutView {
    TDNAboutViewController *aboutViewController = [[TDNAboutViewController alloc] initWithNibName:@"TDNAboutView" bundle:[NSBundle mainBundle]];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController
                       animated:YES
                     completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TDNEtchedSeparatorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        cell.selectedBackgroundView = selectedBackgroundView;
        
        cell.textLabel.font = [UIFont fontWithName:@"Palatino" size:18.0];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        cell.textLabel.highlightedTextColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    }
    
    cell.textLabel.text = [self.sections objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[self.images objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set the article manager's current section and load the appropriate articles
    [TDNArticleManager sharedManager].currentSection = [self.sections objectAtIndex:indexPath.row];
    [[TDNArticleManager sharedManager] removeAllArticles];
    [[TDNArticleManager sharedManager] loadArticles];
    
    self.selectedIndex = indexPath.row;
    
    [self.parentViewController.parentViewController performSelector:@selector(toggleLeftDrawer)];
}

@end
