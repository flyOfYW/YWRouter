//
//  YWModularDetailViewController.m
//  YWRouterDemo
//
//  Created by yaowei on 2018/6/11.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWModularDetailViewController.h"

@interface YWModularDetailViewController ()

@property (nonatomic, weak) UILabel *parmLabel;

@property (nonatomic, strong) NSDictionary *pa;

@end

@implementation YWModularDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
        
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *l = ({
        l = [UILabel new];
        l.frame = CGRectMake(100, 100, 200, 20);
        l.textColor = [UIColor redColor];
        [self.view addSubview:l];
        _parmLabel = l;
        l;
    });
   
    if (_pa[@"value"]) {
        //     对应于 ---  [YWRouter YW_pushController:@"YWModularDetailViewController" params:@{@"value":self.dataList[2]} animated:YES ];
        _parmLabel.text = _pa[@"value"];
    }else{
        _parmLabel.text = _pa[@"params"];
    }
    
}


- (void)setParams:(NSDictionary *)params{
    
    NSLog(@"%@",params);
    _pa = params;
    
    
}


@end
