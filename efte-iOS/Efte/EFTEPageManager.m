//
//  EFTEPageManager.m
//  efet-iOS
//
//  Created by Maxwin on 14-5-29.
//  Copyright (c) 2014年 大众点评. All rights reserved.
//

#import "EFTEPageManager.h"
#import "EFTEUtil.h"
#import "EFTEDebugTableViewController.h"

@interface EFTEPageManager ()
@end

@implementation EFTEPageManager

+ (instancetype)sharedInstance
{
    static EFTEPageManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self class] new];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _pageConfig = [self loadBundlePageConfig];
    }
    return self;
}

- (NSDictionary *)loadBundlePageConfig
{
    NSString *bundleConfigPath = [[NSBundle mainBundle] pathForResource:@"pages" ofType:@"json"];
    return [self jsonFromURL:[NSURL fileURLWithPath:bundleConfigPath]];
}

- (NSDictionary *)jsonFromURL:(NSURL *)url
{
    NSError *error;
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        return [EFTEUtil string2json:jsonString];
    }
    return nil;
}

- (NSURL *)url4page:(NSString *)page
{
    NSString *prefix = [EFTEDebugTableViewController prefixPath];
    if (prefix) {
        NSString *path = [NSString stringWithFormat:@"%@/%@.html", prefix, page];
        return [NSURL URLWithString:path];
    }
    NSDictionary *config = self.pageConfig[page];
    if (config && config[@"url"]) {
        return [NSURL URLWithString:config[@"url"]];
    } else {
        // TODO: 1. load from download dir
        // load from bundle
        NSString *path = [[NSBundle mainBundle] pathForResource:page ofType:@"html"];
        if (path)
            return [NSURL fileURLWithPath:path];
        return nil;
    }
}

@end
