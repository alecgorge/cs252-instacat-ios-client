//
//  ICUser.h
//  Instacat
//
//  Created by Alec Gorge on 4/26/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import "ICJSONModel.h"

@interface ICUser : ICJSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *handle;

@end
