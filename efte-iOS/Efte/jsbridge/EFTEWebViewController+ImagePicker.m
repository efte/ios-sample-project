//
//  EFTEWebViewController+ImagePicker.m
//  efte-iOS
//
//  Created by Maxwin on 14-6-2.
//  Copyright (c) 2014年 大众点评. All rights reserved.
//

#import "EFTEWebViewController+ImagePicker.h"

@class EFTEImagePickerController;
static EFTEImagePickerController *imagePickerController;

@interface EFTEImagePickerController : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@end

@implementation EFTEImagePickerController
- (id)init
{
    if (self = [super init]) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePickerController.delegate = self;
    }
    return self;
}

- (void)captureWithController:(UIViewController *)controller
{
    [controller presentModalViewController:self.imagePickerController animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"%@", image);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePickerController dismissModalViewControllerAnimated:YES];
}

@end

@implementation EFTEWebViewController (ImagePicker)

- (void)jsapi_imagePicker:(NSDictionary *)parameters
{
    if (imagePickerController == nil) {
        imagePickerController = [EFTEImagePickerController new];
    }
    [imagePickerController captureWithController:self];
}

@end


