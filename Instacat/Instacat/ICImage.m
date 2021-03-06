//
//  ICImage.m
//  Instacat
//
//  Created by Alec Gorge on 4/26/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import "ICImage.h"

@implementation ICImage

- (NSURL<Ignore> *)imageURL {
    return [[[ICConfig.apiBase URLByAppendingPathComponent:@"images"]
                               URLByAppendingPathComponent:self.uuid]
                               URLByAppendingPathExtension:@"jpg"];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    if([propertyName isEqualToString:@"isLikedLocally"]) {
        return YES;
    }
    else if ([propertyName isEqualToString:@"isCommentedLocally"]) {
        return YES;
    }
    
    return NO;
}

@end
