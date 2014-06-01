//
//  EFTEWebViewController+Navigator.m
//  efet-iOS
//
//  Created by Maxwin on 14-5-30.
//  Copyright (c) 2014年 大众点评. All rights reserved.
//

#import "EFTEPageManager.h"
#import "EFTEUtil.h"
#import "EFTEWebViewController+Navigator.h"
#import "UIViewController+EFTENavigator.h"

@implementation EFTEWebViewController (Navigator)
- (void)jsapi_actionOpen:(NSDictionary *)parameters
{
    NSString *page = parameters[@"page"];
    NSDictionary *query = parameters[@"query"];
    BOOL modal = [parameters[@"modal"] boolValue];
    BOOL animated =  YES;
    if (parameters[@"animated"]) {
        animated = [parameters[@"animated"] boolValue];
    }
    
    [self efteOpenPage:page withQuery:query modal:modal animated:animated];
}

- (void)jsapi_actionBack:(NSDictionary *)parameters
{
    BOOL animated = YES;
    if (parameters[@"animated"]) {
        animated = [parameters[@"animated"] boolValue];
    }
    [self.navigationController popViewControllerAnimated:animated];
}

- (void)jsapi_actionDismiss:(NSDictionary *)parameters
{
    BOOL animated = YES;
    if (parameters[@"animated"]) {
        animated = [parameters[@"animated"] boolValue];
    }
    [self dismissModalViewControllerAnimated:animated];
}

- (void)jsapi_actionGetQuery:(NSDictionary *)parameters
{
    [self jsCallbackForId:parameters[@"callbackId"] withRetValue:self.efteQuery];
}

@end
