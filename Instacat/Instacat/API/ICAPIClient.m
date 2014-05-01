//
//  ICAPIClient.m
//  Instacat
//
//  Created by Alec Gorge on 4/26/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import "ICAPIClient.h"

#import <CRToast/CRToast.h>

@implementation ICAPIClient

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithBaseURL:ICConfig.apiBase];
    });
    return sharedInstance;
}

- (void)failure:(NSError *)error {
    [CRToastManager showNotificationWithOptions:@{
      kCRToastNotificationTypeKey             : @(CRToastTypeNavigationBar),
      kCRToastBackgroundColorKey              : UIColor.redColor,
      kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
      kCRToastUnderStatusBarKey               : @(YES),
      kCRToastTextKey                         : error.localizedDescription,
      kCRToastTimeIntervalKey                 : @(5)
                                                  }
                                completionBlock:^{
                                    
                                }];
}

- (void)images:(void (^)(NSArray *))success {
    [self GET:@"images/"
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSArray *r = [responseObject mk_map:^id(id item) {
              NSError *err;
              ICImage *y = [[ICImage alloc] initWithDictionary:item
                                                        error:&err];
              
              if(err) {
                  [self failure: err];
                  dbug(@"json err: %@", err);
              }
              
              return y;
          }];
          
          success(r);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          dbug(@"task: %@\n%@", task.response, error);
          [self failure:error];
          
          success(nil);
      }];
}

- (void)image:(NSString *)uuid
      success:(void (^)(ICImage *))success {
    [self GET:[@"images/" stringByAppendingString:uuid]
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSError *err;
          ICImage *i = [[ICImage alloc] initWithDictionary:responseObject
                                                     error:&err];
          
          if(err) {
              [self failure:err];
              dbug(@"json: %@", err);
          }
          
          success(i);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          dbug(@"task: %@\n%@", task.response, error);
          [self failure:error];
          
          success(nil);
      }];
}

- (void)applyAuthHeaders {
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:ICGateway.sharedInstance.username
                                                           password:ICGateway.sharedInstance.password];
}

- (void)postImage:(NSData*)image success:(void (^)(void))success {
    [self applyAuthHeaders];
    
    [self POST:@"images/new"
    parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:image
                                    name:@"image"
                                fileName:@"new.jpg"
                                mimeType:@"image/jpg"];
    }
       success:^(NSURLSessionDataTask *task, id responseObject) {
           success();
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           dbug(@"task: %@\n%@", task.response, error);
           [self failure:error];
           
           success();
       }];
}

- (void)signUpWithHandle:(NSString *)handle
                password:(NSString *)password
                    name:(NSString *)name
                 success:(void (^)(NSError *))success {
    [self POST:@"users/new"
    parameters:@{@"handle": handle, @"name": name, @"password": password}
       success:^(NSURLSessionDataTask *task, id responseObject) {
           success(nil);
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           dbug(@"task: %@\n%@", task.response, error);
           
           success(error);
       }];
}

- (void)verifyUsername:(NSString *)username
          withPassword:(NSString *)password
                result:(void (^)(BOOL valid))result {
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:username
                                                           password:password];
    [self GET:@"users/validate/check"
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          result(YES);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          result(NO);
      }];
}

- (void)likeImage:(ICImage *)image
          success:(void (^)(NSError *err))success {
    [self applyAuthHeaders];

    [self POST:[NSString stringWithFormat:@"images/%@/like", image.uuid]
    parameters:nil
       success:^(NSURLSessionDataTask *task, id responseObject) {
           success(nil);
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           dbug(@"task: %@\n%@", task.response, error);
           
           success(error);
       }];
}

- (void)commentOnImage:(ICImage *)image
               comment:(NSString *)text
               success:(void (^)(NSError *))success {
    [self applyAuthHeaders];
    
    [self POST:[NSString stringWithFormat:@"images/%@/comment", image.uuid]
    parameters:@{@"comment": text}
       success:^(NSURLSessionDataTask *task, id responseObject) {
           success(nil);
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           dbug(@"task: %@\n%@", task.response, error);
           
           success(error);
       }];
}

@end
