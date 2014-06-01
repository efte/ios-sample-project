//
//  EFTEWebViewController+title.m
//  efet-iOS
//
//  Created by Maxwin on 14-5-31.
//  Copyright (c) 2014年 大众点评. All rights reserved.
//

#import "EFTEWebViewController+title.h"

@implementation EFTEWebViewController (title)
- (void)jsapi_setTitle:(NSDictionary *)parameters
{
    self.title = parameters[@"title"];
}
@end
