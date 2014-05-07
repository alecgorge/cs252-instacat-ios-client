//
//  ICJSONModel.m
//  Instacat
//
//  Created by Alec Gorge on 4/26/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import "ICJSONModel.h"

NSDateFormatter *formatter = nil;
NSDateFormatter *getFormatter() {
    if(formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSz";
    }
    
    return formatter;
}

@implementation JSONValueTransformer (NSDate)

- (NSDate*)NSDateFromNSString:(NSString *)string {
    return [getFormatter() dateFromString:string];
}

- (id)JSONObjectFromNSDate:(NSDate *)date {
    return [getFormatter() stringFromDate:date];
}

@end

@implementation ICJSONModel

@end
