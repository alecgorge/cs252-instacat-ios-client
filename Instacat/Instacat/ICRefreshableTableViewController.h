//
//  ICRefreshableTableViewController.h
//  Instacat
//
//  Created by Alec Gorge on 4/26/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICRefreshableTableViewController : UITableViewController

- (void)refresh:(UIRefreshControl *)sender;

@end
