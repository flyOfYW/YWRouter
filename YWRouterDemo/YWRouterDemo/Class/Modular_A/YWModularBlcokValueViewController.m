//
//  YWModularBlcokValueViewController.m
//  YWRouterDemo
//
//  Created by yaowei on 2018/6/13.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWModularBlcokValueViewController.h"

@interface YWModularBlcokValueViewController ()

@end

@implementation YWModularBlcokValueViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回并反向传值" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)backAction{
    
    self.ywReturnBlock(@"反向传值");
    
    [YWRouter YW_popViewControllerAnimated:YES];
    
}
- (void)dealloc{
    NSLog(@"%s",__func__);
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
