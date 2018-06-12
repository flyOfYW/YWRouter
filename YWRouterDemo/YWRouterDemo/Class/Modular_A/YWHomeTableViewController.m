//
//  YWHomeTableViewController.m
//  YWRouterDemo
//
//  Created by yaowei on 2018/6/11.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWHomeTableViewController.h"

@interface YWHomeTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation YWHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.dataList = @[].mutableCopy;
    [self.dataList addObject:@"push到本模块的详情页（类方法）"];
    [self.dataList addObject:@"push到本模块的详情页（对象方法）"];
    [self.dataList addObject:@"push到本模块的详情页（类方法，直接传值）"];
    [self.dataList addObject:@"modal到本模块的详情页（类方法）"];


}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
 
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
    }
    if (indexPath.row < self.dataList.count) {
        cell.textLabel.text = self.dataList[indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{
            NSString *url = [NSString stringWithFormat:@"open://controller?class=YWModularDetailViewController&params=%@",self.dataList[0]];
            [YWRouter YW_pushControllerWithURL:url animated:YES];
            break;
        }
        case 1:
            [[YWRouter YWRouterSingletonInstance] pushControllerWithURL:@"open://controller?class=YWModularDetailViewController&params=push到本模块的详情页)" animated:YES];
            break;
            
        case 2:
            [YWRouter YW_pushControllerName:@"YWModularDetailViewController" params:@{@"value":self.dataList[2]} animated:YES ];
            break;
        case 3:{
            NSString *url = [NSString stringWithFormat:@"open://controller?class=YWModalViewController&params=%@",self.dataList[3]];
            [YWRouter YW_presentViewController:url animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
