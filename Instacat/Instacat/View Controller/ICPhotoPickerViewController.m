//
//  ICPhotoPickerViewController.m
//  Instacat
//
//  Created by Alec Gorge on 4/26/14.
//  Copyright (c) 2014 Ramblingwood. All rights reserved.
//

#import "ICPhotoPickerViewController.h"

@interface ICPhotoPickerViewController ()

@end

@implementation ICPhotoPickerViewController

- (id)init {
    if (self = [super init]) {
        self.delegate = self;
        self.requestedImageSize = CGSizeMake(1280, 1280);
    }
    
    return self;
}

- (void)imagePickerController:(DLCImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSData *data = info[@"data"];
    
    [ICAPIClient.sharedInstance postImage:data
                                  success:^{
                                      UIImageWriteToSavedPhotosAlbum([UIImage imageWithData: data], nil, nil, nil);
                                      [self dismissViewControllerAnimated:YES
                                                               completion:NULL];
                                  }];
}

@end
