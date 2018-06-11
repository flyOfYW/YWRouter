//
//  YWRouter.h
//  YWRouter
//
//  Created by yaowei on 2018/5/10.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YWRouter : NSObject<NSCopying>
/**
 * 获取全局唯一的对象
 */
+ (instancetype)YWRouterSingletonInstance;
/**
 获取某个实体对象 --- 推荐用于~组件之间的通信
 
 @param targetName Target_%@的类名
 @param actionName Target_%@的类里面的action
 @param params 传递参数(可选)
 @param isNeedCacheTarget 是否需要Target_%@的类的对象缓存起来
 @return 实体对象
 */
- (id)performTarget:(NSString *)targetName
             action:(NSString *)actionName
             params:(NSDictionary *)params
    needCacheTarget:(BOOL)isNeedCacheTarget;
/**
 获取控制器
 *--格式-open://controller?class=控制器的类名&params=传递的参数(参数可选)
 @param ctrUrl url链接
 @return 控制器
 */
- (UIViewController *)OpenControllerWithURL:(NSString *)ctrUrl;
/**
 push控制器
 
 @param ctrUrl 链接
 @param animated 是否需要动画
 */
- (void)pushControllerWithURL:(NSString *)ctrUrl animated:(BOOL)animated;
@end

@interface UIViewController (YWRouter)
//控制器获取传递的参数，通过重写params的set方法，类似Android的bundle传值方式
@property (nonatomic, strong) NSDictionary *params;

@end
