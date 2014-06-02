//
//  UIViewController+EFTENavigator.m
//  efet-iOS
//
//  Created by Maxwin on 14-5-31.
//  Copyright (c) 2014年 大众点评. All rights reserved.
//

#import "EFTEPageManager.h"
#import "EFTEWebViewController.h"
#import "UIViewController+EFTENavigator.h"
#import <objc/runtime.h>

static const char *efteQueryTag = "efteQueryTag";

@implementation UIViewController (EFTENavigator)

@dynamic efteQuery;

- (void)setEfteQuery:(NSDictionary *)efteQuery
{
    objc_setAssociatedObject(self, efteQueryTag, efteQuery, OBJC_ASSOCIATION_RETAIN);
}

- (NSDictionary *)efteQuery
{
    return objc_getAssociatedObject(self, efteQueryTag);
}

- (void)efteOpenPage:(NSString *)page
{
    [self efteOpenPage:page withQuery:nil modal:NO animated:YES];
}

- (void)efteOpenPage:(NSString *)page withQuery:(NSDictionary *)query
{
    [self efteOpenPage:page withQuery:query modal:NO animated:YES];
}

- (void)efteOpenPage:(NSString *)page withQuery:(NSDictionary *)query modal:(BOOL)modal animated:(BOOL)animated
{
    UIViewController *vc = [self viewControllerForPage:page];
    if (!vc) {
        return ;
    }
    vc.efteQuery = query;
    if (modal) {
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentModalViewController:nvc animated:animated];
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIViewController *)viewControllerForPage:(NSString *)page
{
    NSDictionary *pageConfig = [EFTEPageManager sharedInstance].pageConfig[page];
    if (pageConfig[@"class"]) { // native class
        Class clz = NSClassFromString(pageConfig[@"class"]);
        if (clz) {
            UIViewController *vc = [clz new];
            if ([vc respondsToSelector:@selector(setEfteQuery:)]) {
                return vc;
            } else {
                NSLog(@"error: page[%@], class[%@] not UIViewController+EFTENavigator", page, clz);
            }
        }
    }
    
    // efte webviewcontroller
    EFTEWebViewController *vc = [EFTEWebViewController new];
    vc.page = page;
    return vc;
}

@end
