//
//  TDNSectionViewController.m
//  Daily Nexus
//
//  TDNSectionViewController is responsible for displaying and selecting sections to show articles from
//

#import "TDNSectionViewController.h"

@implementation TDNSectionViewController

- (void)viewWillAppear:(BOOL)animated {
    // Set up our background view
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoiseBackground"]];
    self.tableView.backgroundView = backgroundView;
    
    self.title = @"Sections";
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        cell.selectedBackgroundView = selectedBackgroundView;
        
        cell.textLabel.font = [UIFont fontWithName:@"Palatino" size:18.0];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        cell.textLabel.highlightedTextColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    }
    
    NSArray *sections = @[@"Feature", @"News", @"Sports", @"Opinion", @"Artsweek", @"On the Menu", @"Science & Tech", @"Online"];
    /* Image credits:
       Star from The Noun Project
       Idea designed by Andrew Laskey from The Noun Project
       Erlenmeyer Flask designed by Emily van den Heever from The Noun Project
       Earth designed by Nicolas Ramallo from The Noun Project
       Newspaper designed by John Caserta from The Noun Project
       Gymnasium designed by Edward Boatman, Mike Clare & Jessica Durkin from The Noun Project
       Art Gallery designed by Saman Bemel-Benrud from The Noun Project
       Fast Food designed by Jinju Jang from The Noun Project */
    NSArray *imageNames = @[@"features", @"news", @"sports", @"opinion", @"art", @"food", @"science", @"online"];
    
    cell.textLabel.text = [sections objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[imageNames objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
