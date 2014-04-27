//
//  ICLike.h
//  Instacat
//
//  Created by Alec Gorge on 4/26/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import "ICJSONModel.h"

@protocol ICLike
@end

@interface ICLike : ICJSONModel

@property (strong, nonatomic) NSString *handle;

@end
