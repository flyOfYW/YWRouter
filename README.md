# YWRouter
## 介绍
降低模块之间的耦合

主要功能:
* 支持URL后面拼接参数的push和modal;
* 支持参数作为字典传入;
* 支持dismiss一个或者多个控制器;

---
## 使用方法:

### 1. 把`YWRouter`这个文件夹拖到项目中.

### 2. 使用`cocoapods`:
pod 'YWRouter', '~> 0.0.2'

## 1. push和modal的使用
所有的push和modal方法都可以通过YWRouter的类方法或者对象来调用.这样在push和modal的时候就不需要拿到导航控制器或控制器再跳转了，当然也提供了目标控制器的返回，用开发者自身决定是否在控制器中进行push和modal。

1.1-push控制器
     [YWRouter YW_pushControllerWithURL:@"open://controller?class=YWModularDetailViewController&params=传递参数" animated:YES];
     或者
     //传目标控制器的类名和参数
     [YWRouter YW_pushControllerName:@"YWModularDetailViewController" params:@{@"value":@"传递参数"} animated:YES ];
     在或者（对象方法）
     [[YWRouter YWRouterSingletonInstance] pushControllerWithURL:@"open://controller?class=YWModularDetailViewController&params=传递参数" animated:YES];
     
1.2-modal控制器
//传目标控制器的类名和参数
[YWRouter YW_presentViewControllerName:@"YWModalTiveViewController" params:nil animated:YES completion:nil];
或者
/**
modal控制器

@param ctrUrl 链接 --格式-open://controller?class=控制器的类名&params=传递的参数(参数可选)
@param animated 是否需要动画
@param completion 完成回调
*/
+(void)YW_presentViewController:(NSString *_Nullable)ctrUrl animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

1.3-dismiss控制器
    //1-1层控制器，可以为多层
    [YWRouter YW_dismissViewControllerWithLayer:1 Animated:YES completion:nil];
    //dismiss掉到根层控制器
    [YWRouter YW_dismissToRootViewControllerWithAnimated:YES completion:nil];

更多使用请查看demo




