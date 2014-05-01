//
//  ICAPIClient.h
//  Instacat
//
//  Created by Alec Gorge on 4/26/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#import "ICImage.h"
#import "ICLike.h"
#import "ICComment.h"

@interface ICAPIClient : AFHTTPSessionManager

+ (instancetype)sharedInstance;

/// @param success Images is an array of ICImage's
- (void)images:(void(^)(NSArray *images)) success;

- (void)image:(NSString *)uuid success:(void(^)(ICImage *image)) success;

- (void)postImage:(NSData*)image success:(void(^)(void)) success;

- (void)verifyUsername:(NSString *)username
          withPassword:(NSString *)password
                result:(void(^)(BOOL valid))result;

- (void)signUpWithHandle:(NSString *)handle
                password:(NSString *)password
                    name:(NSString *)name
                 success:(void(^)(NSError *err))success;

- (void)likeImage:(ICImage *)image
          success:(void(^)(NSError *err))success;

- (void)commentOnImage:(ICImage *)image
               comment:(NSString *)text
               success:(void(^)(NSError *err))success;

@end
