//
//  YWRouter.m
//  YWRouter
//
//  Created by yaowei on 2018/5/10.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWRouter.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@interface YWRouter()

@property (nonatomic, strong) NSMutableDictionary *targetCache;
@property (nonatomic, strong) NSMutableDictionary *registerClassCache;


@end

static YWRouter *singletonInstance;

@implementation YWRouter
/**
 * 严谨单例的写法
 */
+ (instancetype)YWRouterSingletonInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singletonInstance = [[self alloc] init];
    });
    return singletonInstance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singletonInstance = [super allocWithZone:zone];
    });
    return singletonInstance;
}
- (id)copyWithZone:(struct _NSZone *)zone{
    return singletonInstance;
}

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
    needCacheTarget:(BOOL)isNeedCacheTarget{
    
    NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    
    NSString *actionString = [NSString stringWithFormat:@"Action_%@:", actionName];
    
    Class targetClass;
    //以类名做缓存池的key
    NSObject *target = self.targetCache[targetClassString];
    
    if (target == nil) {
       targetClass = NSClassFromString(targetClassString);
       target = [[targetClass alloc] init];
    }
    
    SEL action = NSSelectorFromString(actionString);
    
    //判断target是否真的存在
    if (target == nil) {
        //如果没有可以响应的target，就直接return了。实际开发过程中可以搞个target专门处理这种情况
        [self NoTargetActionResponseWithTargetString:targetClassString selectorString:actionString];
        return nil;
    }
    //当isNeedCacheTarget==YES需要缓存
    if (isNeedCacheTarget) {
        self.targetCache[targetClassString] = target;
    }
    
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target params:params];
    } else {
        //这里其实还有种可能是target是Swift对象
        //这里就不做Swift的判断了，直接调用target里面的notFound方法统一处理
        SEL action_not = NSSelectorFromString(@"notFound:");
        
        if ([target respondsToSelector:action_not]) {
            return [self safePerformAction:action_not target:target params:params];
        } else {
            // 在notFound都没有的时候，直接return了。实际开发过程中可以搞个target专门处理这种情况
            [self NoTargetActionResponseWithTargetString:targetClassString selectorString:actionString];

            [self.targetCache removeObjectForKey:targetClassString];
            return nil;
        }
    }
}

- (void)releaseCachedTargetWithTargetName:(NSString *)targetName
{
    NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    [self.targetCache removeObjectForKey:targetClassString];
}

#pragma mark - private methods
- (void)NoTargetActionResponseWithTargetString:(NSString *)targetString selectorString:(NSString *)selectorString{

}
/**
iOS方法调用有两种，
 一种是 performSelector:withObject 参数只能一个
 再一种就是 NSInvocation 可以接收多个消息
1、performSelector:withObject-的如果有返回值，返回参数是传入SEL的方法返回的参数，但是
2、NSInvocation 不会返回SEL的参数，而是会返回自己传入设定的返回值。
*/
- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params
{
//    通过action去获取该函数的函数签名
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    
    if(methodSig == nil) {
        return nil;
    }
//    获取返回值类型,对象的时候是"@"
    const char* retType = [methodSig methodReturnType];
    
//    ⚠️[invocation setArgument:&params atIndex:2];传入的参数的标题，必须从2，3，4，开始计算，因为第一个argumengt第一个数据和第二个数据被处理者self和即将被调用的方法引用
    
//    没有返回值，则消息声明为void
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
//    还有CGFloat NSUInteger等,除了这些基本情况下，剩下就是对象了

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}

/**
 获取控制器
 *--格式-open://controller?class=控制器的类名&params=传递的参数(参数可选)
 @param ctrUrl url链接
 @return 控制器
 */
- (UIViewController *)OpenControllerWithURL:(NSString *)ctrUrl{
    
    NSDictionary *params = [self paramsResolveRoute:ctrUrl];
    
    Class controllerClass = NSClassFromString(params[@"class"]);
    
    UIViewController *viewController = [[controllerClass alloc] init];
    
    if ([viewController respondsToSelector:@selector(setParams:)]) {
        [viewController performSelector:@selector(setParams:)
                             withObject:[params copy]];
    }else{
        NSLog(@"----------------- 该控制器没有实现setParams,导致传递参数失败------ \n");
    }
    return viewController;
    
}

/**
 push控制器

 @param ctrUrl 链接
 @param animated 是否需要动画
 */
- (void)pushControllerWithURL:(NSString *)ctrUrl animated:(BOOL)animated{
    
    NSDictionary *params = [self paramsResolveRoute:ctrUrl];
    
    Class controllerClass = NSClassFromString(params[@"class"]);
    
    UIViewController *viewController = [[controllerClass alloc] init];
    
    if ([viewController respondsToSelector:@selector(setParams:)]) {
        [viewController performSelector:@selector(setParams:)
                             withObject:[params copy]];
    }else{
        NSLog(@"----------------- 该控制器没有实现setParams,导致传递参数失败------ \n");
    }
    
    [[self currentNavigationViewController] pushViewController:viewController animated:animated];
    
}


/**
 解析参数

 @param url 链接
 @return 参数
 */
- (NSDictionary *)paramsResolveRoute:(NSString *)url{
    
    //open://controller?class=ctr&params=str
    
    NSArray *pSet = [url componentsSeparatedByString:@"?"];
    
    NSString *paramStr = pSet.lastObject;
    
    NSArray *pSet1 = [paramStr componentsSeparatedByString:@"&"];

    NSMutableDictionary *params = [NSMutableDictionary new];
    
    for (NSString *str in pSet1) {
    
        NSArray *pSetKeyValue = [str componentsSeparatedByString:@"="];

        [params setObject:pSetKeyValue.lastObject forKey:pSetKeyValue.firstObject];
    }
    
    return params;

}
- (NSString *)stringFromFilterAppUrlScheme:(NSString *)string
{
    // filter out the app URL compontents.
    for (NSString *appUrlScheme in [self appUrlSchemes]) {
        if ([string hasPrefix:[NSString stringWithFormat:@"%@:", appUrlScheme]]) {
            return [string substringFromIndex:appUrlScheme.length + 2];
        }
    }
    
    return string;
}

- (NSArray *)appUrlSchemes
{
    NSMutableArray *appUrlSchemes = [NSMutableArray array];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    for (NSDictionary *dic in infoDictionary[@"CFBundleURLTypes"]) {
        NSString *appUrlScheme = dic[@"CFBundleURLSchemes"][0];
        [appUrlSchemes addObject:appUrlScheme];
    }
    
    return [appUrlSchemes copy];
}
//MARK: --- 跟控制器相关
- (UIViewController*)currentViewController {
    UIViewController* rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self currentViewControllerFrom:rootViewController];
}
- (UINavigationController*)currentNavigationViewController {
    UIViewController* currentViewController = self.currentViewController;
    return currentViewController.navigationController;
}
// 通过递归拿到当前控制器
- (UIViewController*)currentViewControllerFrom:(UIViewController*)viewController {
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController* navigationController = (UINavigationController *)viewController;
         // 如果传入的控制器是导航控制器,则返回最后一个
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
    }else if([viewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController* tabBarController = (UITabBarController *)viewController;
        // 如果传入的控制器是tabBar控制器,则返回选中的那个
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
        
    }else if(viewController.presentedViewController != nil) {
        // 如果传入的控制器发生了modal,则就可以拿到modal的那个控制器
        return [self currentViewControllerFrom:viewController.presentedViewController];
        
    }else {
        return viewController;
    }
}

- (NSMutableDictionary *)targetCache{
    
    if (!_targetCache) {
        _targetCache = [NSMutableDictionary new];
    }
    return _targetCache;
    
}
- (NSMutableDictionary *)registerClassCache{
    
    if (!_registerClassCache) {
        _registerClassCache = [NSMutableDictionary new];
    }
    return _registerClassCache;
}

@end
#pragma mark - UIViewController Category

@implementation UIViewController (YWRouter)

static char kAssociatedParamsObjectKey;

- (void)setParams:(NSDictionary *)paramsDictionary
{
    objc_setAssociatedObject(self, &kAssociatedParamsObjectKey, paramsDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)params
{
    return objc_getAssociatedObject(self, &kAssociatedParamsObjectKey);
}

@end

