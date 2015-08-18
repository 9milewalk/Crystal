//
//  UserListViewController.h
//  Crystal
//
//  Created by jingame on 2014/09/03.
//  Copyright (c) 2014年 Yusuke Kawashima. All rights reserved.
//

#import "UserListViewController.h"
#import "MapViewController.h"


@implementation UserListViewController 


- (void)viewDidLoad {
    [super viewDidLoad];

	// self.navigationController.navigationBar.alpha = 0.1;
	// self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
}

 
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
  
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
  
    [query orderByDescending:@"createdAt"];
  
    return query;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    static NSString *cellIdentifier = @"Cell";
     
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UserCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
     
    cell.user = object;
    cell.name.text = object[@"name"];

	PFFile *thumbnail = object[@"icon"];
    cell.icon.image = [UIImage imageNamed:@"placeholder.jpg"];
    cell.icon.file = thumbnail; 
	[cell.icon loadInBackground];

    return cell;
}

// send parameter
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"selectRow"]) {
        MapViewController *viewCon = [segue destinationViewController];    // <- 1
        // viewCon.user = [self.tableView indexPathForSelectedRow].row;    // <- 2
		UserCell *userCell = (UserCell *)sender;
        viewCon.user = userCell.user;
    }
} 
@end


@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
	self.icon.layer.cornerRadius = 5;
	self.icon.clipsToBounds = true;
}

@end
