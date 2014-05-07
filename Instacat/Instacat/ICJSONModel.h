//
//  ICJSONModel.h
//  Instacat
//
//  Created by Alec Gorge on 4/26/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import "JSONModel.h"

@interface JSONValueTransformer(NSDate)

-(NSDate*)NSDateFromNSString:(NSString*)string;
-(id)JSONObjectFromNSDate:(NSDate*)date;

@end

@interface ICJSONModel : JSONModel

@property (strong, nonatomic) NSDate *createdAt;

@end
