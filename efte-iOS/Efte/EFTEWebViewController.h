//
//  EFTEWebViewController.h
//  efet-iOS
//
//  Created by Maxwin on 14-5-28.
//  Copyright (c) 2014年 大众点评. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFTEWebViewController : UIViewController

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *page;

- (void) jsCallbackForId:(NSString *) callbackId withRetValue:(NSDictionary *) ret;
@end
