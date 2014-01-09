//
//  YsqAlertViewViewController.m
//  YsqAlertView
//
//  Created by YSQ on 14-1-9.
//  Copyright (c) 2014年 ysq. All rights reserved.
//

#import "YsqAlertViewViewController.h"
#import "YsqAlertView.h"

@interface YsqAlertViewViewController ()

@end

@implementation YsqAlertViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchAlertViewWithHead:(id)sender {
    
    YsqAlertView *alert = [[YsqAlertView alloc]initWithHeadText:@"提示"
                                                          title:@"登陆错误"
                                                   labelTextArr:@[@"用户名或密码错误",@"请重新登陆"]
                                                     btnTextArr:@[@"确定",@"忘记密码？"]
                                                btnClickInIndex:^(int index, NSString *info) {
                                                    NSLog(@"index = %d,info = %@",index,info);
                                                }
                                                         option:NSTextAlignmentCenter]; //option属性是设置提示框中文字的排版
    
    alert.lastBtnIsOnlyText = YES;
    [alert show];
}
- (IBAction)touchAlertViewNoHead:(id)sender {
    
    YsqAlertView *alert  =[[YsqAlertView alloc]initWithHeadText:nil
                                                          title:nil
                                                   labelTextArr:@[@"这将会扣除你1金币",@"下次不再提示"]
                                                     btnTextArr:nil
                                                btnClickInIndex:^(int index, NSString *info) {
                                                    NSLog(@"index = %d,info = %@",index,info);
                                                }
                                                         option:NSTextAlignmentLeft];
    
    alert.lastTextLabelWithCheckBox = YES;
    [alert show];
}
- (IBAction)touchAlertVIewWithTable:(id)sender {
    
    YsqAlertView *alert = [[YsqAlertView alloc]initWithHeadText:@"选择地区"
                                                          title:nil
                                                   labelTextArr:@[@"广东省",@"浙江省",@"江苏省",@"山东省",@"北京",@"辽宁省",@"河北省",@"广西省",@"湖南省",@"湖北省"]
                                                     btnTextArr:@[@"取消"]
                                                btnClickInIndex:^(int index, NSString *info) {
                                                    NSLog(@"index = %d,info = %@",index,info);
                                                }
                                                         option:NSTextAlignmentLeft];
    
    
    alert.type = AlertViewWithTable;
//    alert.tableViewCellBgColor = someColor;
//    alert.tableViewCellFontColor = someColor;
//    alert.tableViewCellTouchColor = someColor;
    [alert show];
}
- (IBAction)touchWarningAutoHide:(id)sender {
    
    YsqAlertView *alert = [[YsqAlertView alloc]initWithWarningString:@"收藏成功"
                                                    withLoadingImage:NO
                                                           durations:1
                                                          endWarning:^{
                                                              NSLog(@"自动隐藏了");
                                                          }];
    [alert show];
    
}
- (IBAction)touchWarningByHandToHide:(id)sender {
    
    YsqAlertView *alert = [[YsqAlertView alloc]initWithWarningString:@"正在提交"
                                                    withLoadingImage:YES
                                                     withCloseButton:YES
                                                          endWarning:^{
                                                              NSLog(@"手动隐藏");
                                                          }];
    [alert show];
    //需要手动调用[alert hide]关闭 或者设置withCloseButton为YES 可以通过点击按钮关闭
    
    //模拟请求了3秒以后关闭
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [alert hide];
    });
}
@end
