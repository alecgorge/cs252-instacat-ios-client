//
//  ICImage.h
//  Instacat
//
//  Created by Alec Gorge on 4/26/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import "ICJSONModel.h"

#import "ICLike.h"
#import "ICComment.h"
#import "ICUser.h"

@interface ICImage : ICJSONModel

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) ICUser *user;

@property (strong, nonatomic) NSArray<ICLike> *likes;
@property (strong, nonatomic) NSArray<ICComment> *comments;

@property (readonly, nonatomic) NSURL<Ignore> *imageURL;

@property (nonatomic) BOOL isLikedLocally;

@end
