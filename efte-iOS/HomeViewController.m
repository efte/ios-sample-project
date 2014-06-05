//
//  HomeViewController.m
//  efte-iOS
//
//  Created by Maxwin on 14-6-5.
//  Copyright (c) 2014年 大众点评. All rights reserved.
//

#import "HomeViewController.h"
#import "EFTEWebViewController.h"
#import "EFTEPageManager.h"
#import "EFTEDebugTableViewController.h"

@interface HomeViewController ()
@property (strong, nonatomic) EFTEWebViewController *efteWebViewController;
@end

@implementation HomeViewController

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
    self.title = @"EFTE";
    self.efteWebViewController = [EFTEWebViewController new];
    self.efteWebViewController.view.frame = self.view.bounds;
    self.efteWebViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.efteWebViewController.view];
    [self addChildViewController:self.efteWebViewController];
    
    self.efteWebViewController.page = @"home";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Debug Config" style:UIBarButtonItemStylePlain target:self action:@selector(onLeftBarButtonItemClick)];
}

- (void)onLeftBarButtonItemClick
{
    EFTEDebugTableViewController *vc = [EFTEDebugTableViewController new];
    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onEfteDebugLeftBarButtonItemClick)];
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentModalViewController:nvc animated:YES];
}

- (void)onEfteDebugLeftBarButtonItemClick
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
