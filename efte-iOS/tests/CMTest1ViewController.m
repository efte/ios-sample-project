//
//  CMTest1ViewController.m
//  efet-iOS
//
//  Created by Maxwin on 14-5-31.
//  Copyright (c) 2014年 大众点评. All rights reserved.
//

#import "CMTest1ViewController.h"
#import "UIViewController+EFTENavigator.h"
#import "EFTEUtil.h"

@interface CMTest1ViewController ()

@end

@implementation CMTest1ViewController

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
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"test1, click to dismiss" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.center = self.view.center;
    [self.view addSubview:button];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 300, 300, 100)];
    textView.text = [NSString stringWithFormat:@"query: %@", [EFTEUtil json2string:self.efteQuery]];
    [self.view addSubview:textView];
}

- (void)dismiss
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
