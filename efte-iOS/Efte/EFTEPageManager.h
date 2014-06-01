//
//  EFTEPageManager.h
//  efet-iOS
//
//  Created by Maxwin on 14-5-29.
//  Copyright (c) 2014年 大众点评. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFTEPageManager : NSObject

@property (strong, nonatomic, readonly) NSDictionary *pageConfig;

+ (instancetype)sharedInstance;

- (NSURL *)url4page:(NSString *)page;

@end
