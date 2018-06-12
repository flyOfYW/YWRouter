//
//  YWModalViewController.m
//  YWRouterDemo
//
//  Created by yaowei on 2018/6/12.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWModalViewController.h"

@interface YWModalViewController ()

@property (nonatomic, weak) UILabel *parmLabel;

@property (nonatomic, strong) NSDictionary *pa;

@end

@implementation YWModalViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *l = ({
        l = [UILabel new];
        l.frame = CGRectMake(100, 100, 200, 20);
        l.textColor = [UIColor redColor];
        [self.view addSubview:l];
        _parmLabel = l;
        l;
    });
    
    if (_pa[@"custom"]) {
        NSDictionary *custom = _pa[@"params"];
        _parmLabel.text = custom[@"value"];
    }else{
        _parmLabel.text = _pa[@"params"];
    }
    
    
 
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(200, 200, 100, 30);
    btn.backgroundColor = [UIColor redColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:@"modal控制器" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(modalAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(80, 250, 200, 30);
    btn1.backgroundColor = [UIColor redColor];
    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn1 setTitle:@"dismiss到根层控制器" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(dismissRootAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    
}

- (void)modalAction{
    
    [YWRouter YW_presentViewControllerName:@"YWModalTiveViewController" params:nil animated:YES completion:nil];
    
}

- (void)dismissRootAction{
    [YWRouter YW_dismissToRootViewControllerWithAnimated:YES completion:nil];
}

- (void)setParams:(NSDictionary *)params{
    
    NSLog(@"%@",params);
    _pa = params;
    
    
}


@end
