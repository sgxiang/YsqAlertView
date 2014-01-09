//
//  YsqAlertView.h
//  YsqAlertView
//
//  Created by YSQ on 14-1-9.
//  Copyright (c) 2014年 ysq. All rights reserved.
//

#import <UIKit/UIKit.h>



//回调block
//当为label模式时 index为按钮的位置   info=》有checkBox时返回checkBox是否被选择 无checkBox时返回@“无内容”
//当为table模式时：
//若点击cell   index返回-1  info返回点击的cell的内容
//若点击按钮    index返回按钮的位置    info为无内容
typedef void(^btnPress)(int index,NSString *info);
typedef void(^endWarning)(void);

typedef enum{
    AlertViewWithLabel = 0,    //默认为label
    AlertViewWithTable,        //设置为带tableView的  (title属性不可用 option属性不可用)
    AlertViewWithWarning     //只是一个waring的弹出层 没有按钮层
}AlertViewType;

typedef enum{
    AlertViewCellNOWithAccessoryView = 0,   //默认没有带有提示的圆形按钮
    AlertViewCellWithAccessoryView          //带有提示的圆形按钮
}AlertViewCellAccessoryType;

@interface YsqAlertView : UIView<UITableViewDataSource,UITableViewDelegate>


@property(unsafe_unretained,nonatomic)NSTextAlignment headViewTextAlignment;   //头部文字格式

@property(unsafe_unretained,nonatomic)BOOL lastBtnIsOnlyText;  //设置最后按钮是否只是文本格式 默认为NO
@property(unsafe_unretained,nonatomic)BOOL lastTextLabelWithCheckBox;  //设置最后一个label是否带上一个checkBox选择框，默认为NO
@property(unsafe_unretained,nonatomic)AlertViewType type;   //弹出层类型

//当弹出层为tableView时
@property(strong,nonatomic)UIColor *tableViewCellBgColor;   //cell的背景色
@property(strong,nonatomic)UIColor *tableViewCellFontColor;   //cell的字体颜色
@property(strong,nonatomic)UIColor *tableViewCellTouchColor;  //cell的点击后的背景颜色

@property(unsafe_unretained,nonatomic)AlertViewCellAccessoryType cellAccessoryType;       //cell的类型
@property(unsafe_unretained,nonatomic)int cellInitSelectIndex;  //一开始选中的cell的位置


//丰富的弹出层
-(id)initWithHeadText:(NSString *)headText
                title:(NSString *)title
         labelTextArr:(NSArray *)labelTArr
           btnTextArr:(NSArray *)btnTArr
      btnClickInIndex:(btnPress)pressBlock
               option:(NSTextAlignment)labelTextAlignment;

//比较简单的一个提示框
-(id)initWithWarningString:(NSString *)warningString  withLoadingImage:(BOOL)option durations:(float)durations endWarning:(endWarning)endWarningBlock;
//提示框不带时间  需要手动调用hide函数
-(id)initWithWarningString:(NSString *)warningString  withLoadingImage:(BOOL)option withCloseButton:(BOOL)useClose endWarning:(endWarning)endWarningBlock;

-(void)show;
-(void)hide;

@end