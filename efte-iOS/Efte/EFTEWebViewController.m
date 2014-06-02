//
//  EFTEWebViewController.m
//  efet-iOS
//
//  Created by Maxwin on 14-5-28.
//  Copyright (c) 2014年 大众点评. All rights reserved.
//

#import "UIViewController+EFTENavigator.h"
#import "EFTEWebViewController.h"
#import "NSURL+PathExt.h"
#import "EFTEPageManager.h"
#import <objc/runtime.h>

@interface EFTEWebViewController () <UIWebViewDelegate>
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation EFTEWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO;
    if (YES) { // ios6
    for (UIView *view in [[self.webView subviews].firstObject subviews]) {
            if ([view isKindOfClass:[UIImageView class]]) view.hidden = YES;
        }
    }
    
    [self.view addSubview:self.webView];
    
    self.webView.delegate = self;
    [self setupRefreshControl];
    
    // load page
    if (self.page) {
        [self loadPage];
    }
}

- (void)setPage:(NSString *)page
{
    _page = page;
    if (self.isViewLoaded) {
        [self loadPage];
    }
}

- (void)loadPage
{
    NSURL *url = [[EFTEPageManager sharedInstance] url4page:self.page];
    if (!url) { // page not found
        url = [[EFTEPageManager sharedInstance] url4page:@"404"];
        self.efteQuery = @{@"page": self.page};
    }
    [self.webView stopLoading];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [self.webView loadRequest:request];
}

#pragma mark - functions
- (void)setupRefreshControl
{
    if (!self.refreshControl) {
        self.refreshControl = [UIRefreshControl new];
    }
    [self.refreshControl addTarget:self action:@selector(onRefreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl addTarget:self action:@selector(onRefreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.webView.scrollView addSubview:self.refreshControl];
}

- (void)onRefreshControlValueChanged:(UIRefreshControl *)refreshControl
{
    NSString *ret = [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:(function(){if(typeof(DPApp.startRefresh) == 'function') {setTimeout(DPApp.startRefresh, 0);return 1}else{window.location.reload();return 2;}})()"];
    if ([ret intValue] == 2) {
        [self endRefreshing];
    }
}

- (void)endRefreshing
{
    [self.refreshControl endRefreshing];
}

- (void)jsapi_stopRefresh:(NSDictionary *)parameters
{
    [self endRefreshing];
}

#pragma mark - js bridge 
- (NSString *) jsScheme
{
    return @"js://";
}

- (BOOL)webView:(UIWebView *)web shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString hasPrefix:[self jsScheme]]) {
        [self handleMessage:[request.URL queryParams]];
        return NO;
    }
    return YES;
}

- (void)handleMessage:(NSDictionary *)param
{
    SEL selector = [self selectorForMethod:param[@"method"]];
    if (selector == nil) return;
    if (![self respondsToSelector:selector]) {
        NSLog(@"cannot handle[%@]", param);
        return ;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:selector withObject:[self string2json:param[@"args"]]];
#pragma clang diagnostic pop
    
}

- (SEL)selectorForMethod:(NSString *) method {
    if ([method length] == 0) return nil;
    NSString *objcMethod = [[@"jsapi_" stringByAppendingString:method] stringByAppendingString:@":"];
    return NSSelectorFromString(objcMethod);
}

- (NSDictionary *)string2json:(NSString *)str
{
    if (str == nil) return nil;
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (error != nil) { // parse json error
        NSLog(@"parse json error: %@", error);
    }
    return json;
}

- (NSString *) stringFromDictionary:(NSDictionary *) dictionary {
    if (![NSJSONSerialization isValidJSONObject:dictionary]) return @"";
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


- (void) jsCallbackForId:(NSString *) callbackId withRetValue:(NSDictionary *) ret {
    NSString *js = [NSString stringWithFormat:@"window.DPApp.callback(%@,%@);", callbackId, [self stringFromDictionary:ret]];
    [self.webView performSelector:@selector(stringByEvaluatingJavaScriptFromString:) withObject:js afterDelay:0];
}

- (NSString *)apiMethodPrefix {
    return @"jsapi_";
}

- (NSString *)apiNameFromMethodName:(NSString *) name {
    NSString *nameWithoutPrefix = [name substringFromIndex:[[self apiMethodPrefix] length]];
    NSString *apiName = [nameWithoutPrefix substringToIndex:[nameWithoutPrefix length] -1];
    return apiName;
}

- (NSArray *) jsapiMethodsListForClass:(Class)cls {
    NSUInteger count = 0;
    Method *methods = class_copyMethodList(cls, &count);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    for (NSInteger i = 0; i < count; i++) {
        NSString *methodName = @(sel_getName(method_getName(methods[i])));
        if ([methodName hasPrefix:[self apiMethodPrefix]]) {
            [array addObject:[self apiNameFromMethodName:methodName]];
        }
    }
    free(methods);
    return array;
}

- (NSArray *)jsapiMethodList {
    Class cls = self.class;
    NSMutableArray *methods = [NSMutableArray array];
    while (cls && [NSStringFromClass(cls) hasPrefix:@"NV"]) {
        [methods addObjectsFromArray:[self jsapiMethodsListForClass:cls]];
        cls = cls.superclass;
    }
    return methods;
}

- (BOOL)shouldInjectJs{
    return NO;
}

@end
