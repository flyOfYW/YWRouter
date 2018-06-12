//
//  YWModalTiveViewController.m
//  YWRouterDemo
//
//  Created by yaowei on 2018/6/12.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWModalTiveViewController.h"

@interface YWModalTiveViewController ()

@end

@implementation YWModalTiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 200, 30);
    btn.backgroundColor = [UIColor redColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:@"dismiss一层控制器" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(80, 150, 200, 30);
    btn1.backgroundColor = [UIColor redColor];
    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn1 setTitle:@"dismiss到根层控制器" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(dismissRootAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
}

- (void)dismissAction{
    [YWRouter YW_dismissViewControllerWithLayer:1 Animated:YES completion:nil];
}

- (void)dismissRootAction{
    [YWRouter YW_dismissToRootViewControllerWithAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
