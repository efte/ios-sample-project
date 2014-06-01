//
//  EFTEWebViewController+Ajax.m
//  efet-iOS
//
//  Created by Maxwin on 14-5-29.
//  Copyright (c) 2014年 大众点评. All rights reserved.
//

#import "EFTEWebViewController+Ajax.h"
#import "EFTEUtil.h"
#import <JSONModel/JSONHTTPClient.h>

@implementation EFTEWebViewController (Ajax)
- (void)jsapi_ajax:(NSDictionary *)parameters
{
    NSString *urlString = parameters[@"url"];
    NSString *method = parameters[@"method"] ?: @"GET";
    [JSONHTTPClient JSONFromURLWithString:urlString method:method params:parameters[@"data"] orBodyString:nil completion:^(id json, JSONModelError *err) {
        NSLog(@"%@, %@", json, err);
        if (err != nil) {
            [self _ajaxFailWithCode:-1 message:err.localizedDescription parameters:parameters];
        } else {
            [self _ajaxSuccess:json parameters:parameters];
        }

    }];
}

- (void)_ajaxSuccess:(NSDictionary *)json parameters:(NSDictionary *)parameters
{
    [self jsCallbackForId:parameters[@"callbackId"] withRetValue:@{
                                                                   @"code": @"0",
                                                                   @"responseText": [EFTEUtil json2string:json] ?: @""}];
}

- (void)_ajaxFailWithCode:(NSInteger)code message:(NSString *)message parameters:(NSDictionary *)parameters
{
    [self jsCallbackForId:parameters[@"callbackId"] withRetValue:@{
                                                                   @"code": @(code),
                                                                   @"message": message ?: @""}];
}

@end
