//
//  UIViewController+EFTENavigator.h
//  efet-iOS
//
//  Created by Maxwin on 14-5-31.
//  Copyright (c) 2014年 大众点评. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (EFTENavigator)
@property (strong, nonatomic) NSDictionary *efteQuery;

- (void)efteOpenPage:(NSString *)page;
- (void)efteOpenPage:(NSString *)page withQuery:(NSDictionary *)query;
- (void)efteOpenPage:(NSString *)page withQuery:(NSDictionary *)query modal:(BOOL)modal animated:(BOOL)animated;
@end
