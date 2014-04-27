//
//  ICComment.h
//  Instacat
//
//  Created by Alec Gorge on 4/26/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import "JSONModel.h"

@protocol ICComment
@end

@interface ICComment : ICJSONModel

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *handle;

@end
