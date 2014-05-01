//
//  ICImageViewController.h
//  Instacat
//
//  Created by Manik Kalra on 30/04/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICRefreshableTableViewController.h"

@interface ICImageViewController : ICRefreshableTableViewController

@property (nonatomic, strong) ICImage *image;

-(instancetype)initWithImage:(ICImage *)image;

@end
