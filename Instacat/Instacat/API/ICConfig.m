//
//  ICConfig.m
//  Instacat
//
//  Created by Alec Gorge on 4/16/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import "ICConfig.h"

@implementation ICConfig

+ (NSURL *)apiBase {
    return [NSURL URLWithString:@"http://localhost:3000/api"];
}

@end
