//
//  EFTEWebViewController+ImagePicker.m
//  efte-iOS
//
//  Created by Maxwin on 14-6-2.
//  Copyright (c) 2014年 大众点评. All rights reserved.
//

#import "EFTEWebViewController+ImagePicker.h"

typedef void (^ImagePickerBlock)(UIImage *image);

@class EFTEImagePickerController;
static EFTEImagePickerController *_instanceImagePickerController;

@interface EFTEImagePickerController : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (copy, nonatomic) ImagePickerBlock completed;
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

- (void)captureWithController:(UIViewController *)controller completed:(ImagePickerBlock)completed
{
    self.completed = completed;
    [controller presentModalViewController:self.imagePickerController animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.completed(image);
    [self dismiss];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismiss];
}

- (void)dismiss
{
    [self.imagePickerController dismissModalViewControllerAnimated:YES];
    _instanceImagePickerController = nil;
}
@end

@implementation EFTEWebViewController (ImagePicker)

- (void)jsapi_imagePicker:(NSDictionary *)parameters
{
    if (_instanceImagePickerController == nil) {
        _instanceImagePickerController = [EFTEImagePickerController new];
    }
    __weak EFTEWebViewController *weakSelf = self;
    [_instanceImagePickerController captureWithController:self completed:^(UIImage *image) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        NSString *base64string = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [weakSelf jsCallbackForId:parameters[@"callbackId"] withRetValue:@{@"image": base64string}];
    }];
}

@end


