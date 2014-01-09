//
//  YsqAlertView.m
//  YsqAlertView
//
//  Created by YSQ on 14-1-9.
//  Copyright (c) 2014年 ysq. All rights reserved.
//

#import "YsqAlertView.h"




#define BlackColor 0x000000
#define WhiteColor 0xffffff
#define GreenColor 0x339900

#define AlertViewWidth 290    //view的大小

#define AlertViewBgColor WhiteColor   //view的背景颜色
#define AlertViewBgAlpha 0          //view的背景透明度


#define AlertViewTopAndBottomHeight 40*2     //文字部分（包括title和label的那部分=》_centerView）顶部和底部的高度

#define AlertViewHeadViewHeight 40   //头部的高度
#define AlertViewHeadViewColor 0x5388b2   //头部view的颜色
#define AlertViewHeadTextFontSize 18    //头部文字的大小
#define AlertViewHeadTextFontColor WhiteColor
#define AlertViewHeadTextMargin 10     //头部文字左右的margin

#define AlertViewBtnViewHeight 40       //按钮层的高度
#define AlertViewBtnHeight 30     //按钮的高度
#define AlertViewBtnWidth 120  //按钮的宽度  超过两个的在代码中自适应
#define AlertViewBtnFontSize 14     //按钮的文字大小
#define AlertViewBtnViewBgColor 0x999999     //按钮层的背景色
#define AlertViewBtnBgColor 0xdadada       //按钮的背景色
#define AlertViewBtnPressColor 0xbababa   //按钮按下的颜色
#define ALertViewBtnMargin 10  //btn的左右margin

#define AlertViewTitleFontSize 18    //title的文字大小
#define AlertViewTitleLabelHeight 30   //title的label的高度


#define AlertViewLabelFontSize 15     //label的文字大小
#define AlertViewOneLabelHeight 26    //每个label的高度
#define AlertViewLabelPadding 10   //label的左右padding


#define AlertViewTableMaxHeight 44*7  //为tableView视图的时候，最大的高度

#define AlertViewCellBgColor WhiteColor     //cell的背景颜色
#define AlertViewCellFontColor BlackColor      //cell的字体颜色
#define AlertViewCellTouchColor GreenColor     //cell点击的颜色

#define kTransitionDuration 0.2   //动画的时间参考值

#define AlertCenterBorderWidth 2  //中间视图的border宽度


#define AppFontWithSize(a) [UIFont fontWithName:@"Helvetica" size:(a)]
#define AppBoldFontWithSize(a) [UIFont fontWithName:@"Helvetica-Bold" size:(a)]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBAndAlpha(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]


#define degreesToRadinas(x) (M_PI * (x)/180.0)




@interface YsqAlertView ()
@property(unsafe_unretained,nonatomic)BOOL useReloadImage; //在warning弹出层定义是否加上动画图片
@property(unsafe_unretained,nonatomic)float warningDurations;  //warning显示的时间
@property(unsafe_unretained,nonatomic)endWarning endWarningBlock;    //结束warning的块

@property(unsafe_unretained,nonatomic)BOOL useCloseButton;  //加上关闭按钮

@end


@implementation YsqAlertView{
    
    
    UIView *_contentView;
    
    NSString *_headText;   //头部文字
    NSString *_title;       //title
    NSArray *_labelTextArr;     //label文字数组
    NSArray *_btnTextArr;       //按钮数组
    btnPress _btnPressBlock;     //按钮回调block
    NSTextAlignment _option;      //label文字设置
    
    UIView *_headView;             //头部视图
    UIView *_centerView;         //中间视图
    UIView *_btnView;          //按钮视图
    
    UIButton *_checkBox;       //中间视图中的checkBox
    
    UITableView *_centerTableView;      //中间视图的tableView
    
    UIImageView *_loadingImageView;    //加载的图片视图
    UIButton *_closeButton;     //关闭warning的按钮
}




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithHeadText:(NSString *)headText title:(NSString *)title labelTextArr:(NSArray *)labelTArr btnTextArr:(NSArray *)btnTArr btnClickInIndex:(btnPress)pressBlock option:(NSTextAlignment)labelTextAlignment{
    if (self=[super init]) {
        
        self.frame = [[UIScreen mainScreen]bounds];
        self.backgroundColor = UIColorFromRGBAndAlpha(AlertViewBgColor, AlertViewBgAlpha);
        
        if (headText) {
            _headText = headText;
        }
        if (title) {
            _title = title;
        }
        if (labelTArr) {
            _labelTextArr = [[NSArray alloc]initWithArray:labelTArr];
        }
        if (btnTArr) {
            _btnTextArr = [[NSArray alloc]initWithArray:btnTArr];
        }else{
            _btnTextArr = @[@"确定"];
        }
        if (pressBlock) {
            _btnPressBlock = pressBlock;
        }
        
        _option = labelTextAlignment;
        
        self.lastBtnIsOnlyText = NO;
        self.lastTextLabelWithCheckBox = NO;
        
        
        self.tableViewCellBgColor = UIColorFromRGB(AlertViewCellBgColor);
        self.tableViewCellFontColor = UIColorFromRGB(AlertViewCellFontColor);
        self.tableViewCellTouchColor = UIColorFromRGB(AlertViewCellTouchColor);
        
        
        [self loadView];
    }
    return self;
}


-(id)initWithWarningString:(NSString *)warningString withLoadingImage:(BOOL)option durations:(float)durations endWarning:(void (^)(void))endWarningBlock{
    if (self=[super init]) {
        self.frame = [[UIScreen mainScreen]bounds];
        self.backgroundColor = UIColorFromRGBAndAlpha(AlertViewBgColor, AlertViewBgAlpha);
        
        self.type = AlertViewWithWarning;
        
        if (warningString) {
            _labelTextArr = @[warningString];
        }
        _option = NSTextAlignmentCenter;
        
        self.warningDurations = durations;
        self.endWarningBlock = endWarningBlock;
        
        [self loadView];
        
        self.useReloadImage = option;
    }
    return self;
}

-(id)initWithWarningString:(NSString *)warningString withLoadingImage:(BOOL)option withCloseButton:(BOOL)useClose endWarning:(endWarning)endWarningBlock{
    if (self=[super init]) {
        self.frame = [[UIScreen mainScreen]bounds];
        self.backgroundColor = UIColorFromRGBAndAlpha(AlertViewBgColor, AlertViewBgAlpha);
        
        self.type = AlertViewWithWarning;
        
        if (warningString) {
            _labelTextArr = @[warningString];
        }
        _option = NSTextAlignmentCenter;
        
        self.warningDurations = -1;
        self.endWarningBlock = endWarningBlock;
        
        [self loadView];
        
        self.useReloadImage = option;
        self.useCloseButton = useClose;
    }
    return self;
}


#pragma 加载视图

-(void)loadView{
    
    
    [self defineCenterView];
    
    if (self.type!=AlertViewWithWarning) {
        [self defineBtnView];
        [self defineHeadView];
    }
    
}


-(void)defineCenterView{
    
    
    //centerView的高度
    int tempHeight = AlertViewTopAndBottomHeight + AlertViewTitleLabelHeight * (_title ? 1:0) +AlertViewOneLabelHeight * (_labelTextArr?[_labelTextArr count]:0);
    
    _centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AlertViewWidth, tempHeight) ];
    _centerView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + (_headText?  AlertViewHeadViewHeight/2 :0) -(_btnTextArr?AlertViewBtnViewHeight/2:0) ); //居中显示
    
    _centerView.backgroundColor = UIColorFromRGB( (_headText?WhiteColor:BlackColor) );
    
    
    CALayer *paddingLayer = [CALayer layer];
    paddingLayer.frame=CGRectMake(0, -AlertCenterBorderWidth, _centerView.frame.size.width, _centerView.frame.size.height+AlertCenterBorderWidth*2);
    paddingLayer.borderColor=  UIColorFromRGB(AlertViewBtnViewBgColor).CGColor;
    paddingLayer.borderWidth=AlertCenterBorderWidth;
    [_centerView.layer addSublayer:paddingLayer];
    

    //title
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, AlertViewTopAndBottomHeight/2, AlertViewWidth, AlertViewTitleLabelHeight)];
    titleLabel.backgroundColor = UIColorFromRGBAndAlpha(WhiteColor, 0);
    titleLabel.font = AppFontWithSize(AlertViewTitleFontSize);
    titleLabel.text = _title;
    titleLabel.textColor = UIColorFromRGB((_headText?BlackColor:WhiteColor));
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_centerView addSubview:titleLabel];
    titleLabel = nil;
    
    //label
    for (int i=0;i<[_labelTextArr count];i++) {
        UILabel *subText = [[UILabel alloc]initWithFrame:CGRectMake(AlertViewLabelPadding, AlertViewTopAndBottomHeight/2+AlertViewOneLabelHeight *i + (_title?AlertViewTitleLabelHeight:0), AlertViewWidth - AlertViewLabelPadding*2, AlertViewOneLabelHeight)];
        subText.backgroundColor = UIColorFromRGBAndAlpha(WhiteColor, 0);
        subText.font = AppFontWithSize(AlertViewLabelFontSize);
        subText.text = _labelTextArr[i];
        subText.textColor = UIColorFromRGB((_headText?BlackColor:WhiteColor));
        subText.textAlignment = _option;
        [_centerView addSubview:subText];
        subText = nil;
    }
    
    [self addSubview:_centerView];
}


-(void)defineBtnView{
    //按钮层
    _btnView = [[UIView alloc]initWithFrame:CGRectMake(0, _centerView.frame.origin.y + _centerView.frame.size.height, AlertViewWidth, AlertViewBtnViewHeight)];
    _btnView.center = CGPointMake(self.frame.size.width/2, _btnView.center.y);
    _btnView.backgroundColor = UIColorFromRGB(AlertViewBtnViewBgColor);
    
    
    float tempBtnWidth = [_btnTextArr count] <=2 ? AlertViewBtnWidth : (AlertViewWidth-ALertViewBtnMargin*2 - ALertViewBtnMargin * [_btnTextArr count])/[_btnTextArr count];    //计算btn的宽度 超过两个自适应
    
    //按钮
    for (int i=0; i<[_btnTextArr count]; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0 , tempBtnWidth, AlertViewBtnHeight)];
        
        int centerX = [_btnTextArr count]==1 ? AlertViewWidth/2 :( [_btnTextArr count]==2? AlertViewWidth / 2 + (ALertViewBtnMargin /2 + AlertViewBtnWidth/2) *( i==0?-1:1 ) :  ( i * tempBtnWidth + i * ALertViewBtnMargin + tempBtnWidth/2 + ALertViewBtnMargin ) );  //计算中心x轴
        btn.center = CGPointMake(centerX, AlertViewBtnViewHeight/2) ;
        btn.tag = i;
        [btn setTitle:_btnTextArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(BlackColor) forState:UIControlStateNormal];
        if (!(self.lastBtnIsOnlyText && i==[_btnTextArr count]-1)) {
            [btn setBackgroundColor:UIColorFromRGB(AlertViewBtnBgColor)];
        }
        [btn addTarget:self action:@selector(changeBtnBgColorWithTouchDown:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(changeBtnBgColorWithCancel:) forControlEvents:UIControlEventTouchUpOutside];
        [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.titleLabel.font = AppFontWithSize(AlertViewBtnFontSize);
        [_btnView addSubview:btn];
        btn = nil;
    }
    
    
    [self addSubview:_btnView];
}

-(void)defineHeadView{
    
    if (_headText==nil) {
        return;
    }
    
    //头部层
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, _centerView.frame.origin.y - AlertViewHeadViewHeight, AlertViewWidth, AlertViewHeadViewHeight)];
    _headView.center = CGPointMake(self.frame.size.width/2, _headView.center.y);
    _headView.backgroundColor = UIColorFromRGB(AlertViewHeadViewColor);
    
    UILabel *head = [[UILabel alloc]initWithFrame:CGRectMake(AlertViewHeadTextMargin, 0, AlertViewWidth - AlertViewHeadTextMargin*2, AlertViewHeadViewHeight)];
    head.text = _headText;
    head.font = AppFontWithSize(AlertViewHeadTextFontSize);
    head.textColor = UIColorFromRGB(AlertViewHeadTextFontColor);
    head.backgroundColor = UIColorFromRGBAndAlpha(WhiteColor, 0);
    head.textAlignment = self.headViewTextAlignment;
    
    [_headView addSubview:head];
    head = nil;
    
    [self addSubview:_headView];
}

#pragma 头部文字设置

-(void)setHeadViewTextAlignment:(NSTextAlignment)headViewTextAlignment{
    
    _headViewTextAlignment = headViewTextAlignment;
    
    if (_headText==nil) {
        return;
    }
    
    UILabel *headLabel =  _headView.subviews[0];
    headLabel.textAlignment = headViewTextAlignment;
    
}

#pragma 按钮颜色变化及响应

-(void)changeBtnBgColorWithTouchDown:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundColor:UIColorFromRGB(AlertViewBtnPressColor)];
}
-(void)changeBtnBgColorWithCancel:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (!(self.lastBtnIsOnlyText && btn.tag==[_btnTextArr count]-1)) {
        [btn setBackgroundColor:UIColorFromRGB(AlertViewBtnBgColor)];
    }else{
        [btn setBackgroundColor:UIColorFromRGBAndAlpha(WhiteColor, 0)];
    }
}
-(void)pressBtn:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (!(self.lastBtnIsOnlyText && btn.tag==[_btnTextArr count]-1)) {
        [btn setBackgroundColor:UIColorFromRGB(AlertViewBtnBgColor)];
    }else{
        [btn setBackgroundColor:UIColorFromRGBAndAlpha(WhiteColor, 0)];
    }
    
#warning  在这里订制选择按钮返回的数据
    
    NSLog(@"点击第%d个按钮",btn.tag+1);
    if (self.lastTextLabelWithCheckBox) {
        NSLog(@"checkBox：%hhd",_checkBox.selected);
    }
    
    _btnPressBlock(btn.tag,self.lastTextLabelWithCheckBox?[NSString stringWithFormat:@"%hhd",_checkBox.selected]:@"无内容");
    
    [self hide];
}

#pragma 设置最后一个按钮的样式

-(void)setLastBtnIsOnlyText:(BOOL)lastBtnIsOnlyText{
    _lastBtnIsOnlyText = lastBtnIsOnlyText;
    if (!lastBtnIsOnlyText) {
        return;
    }
    if (self.type==AlertViewWithWarning) {
        return;
    }
    UIButton *lastBtn = (UIButton *)[_btnView.subviews lastObject];
    [lastBtn setBackgroundColor:UIColorFromRGBAndAlpha(WhiteColor, 0)];
}
#pragma 设置最后一个label是否带上选择框

-(void)setLastTextLabelWithCheckBox:(BOOL)lastTextLabelWithCheckBox{
    _lastTextLabelWithCheckBox = lastTextLabelWithCheckBox;
    
    if (!lastTextLabelWithCheckBox || self.type!=AlertViewWithLabel) {
        return;
    }
    
    UILabel *lastLabel = (UILabel *)[_centerView.subviews lastObject];
    
    _checkBox = [[UIButton alloc]initWithFrame:CGRectMake(lastLabel.frame.origin.x, 0, 18, 18)];
    _checkBox.center = CGPointMake(_checkBox.center.x, lastLabel.center.y);
    [_checkBox setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [_checkBox setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateSelected];
    [_checkBox addTarget:self action:@selector(checkBoxPress) forControlEvents:UIControlEventTouchUpInside];
    [_centerView addSubview:_checkBox];
    
    lastLabel.frame = CGRectMake(30, lastLabel.frame.origin.y, lastLabel.frame.size.width-30, lastLabel.frame.size.height);
}
-(void)checkBoxPress{
    _checkBox.selected = !_checkBox.selected;
}


#pragma 当是warning视图的时候设置是否加载动画

-(void)setUseReloadImage:(BOOL)useReloadImage{
    _useReloadImage = useReloadImage;
    if (useReloadImage && self.type==AlertViewWithWarning) {
        
        _loadingImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading"]];
        _loadingImageView.frame = CGRectMake( [self warningStringMaring] - 30, 0, 25, 25);
        
        _loadingImageView.center = CGPointMake(_loadingImageView.center.x, AlertViewOneLabelHeight/2 + AlertViewTopAndBottomHeight/2);
        
        if (![_labelTextArr firstObject]) {
            _loadingImageView.center = CGPointMake(AlertViewWidth/2, AlertViewTopAndBottomHeight/2);
        }
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.delegate = self;
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI , 0, 0, 1.0)];
        animation.duration = 0.3;
        animation.cumulative = YES;
        animation.repeatCount = INT_MAX;
        
        [_loadingImageView.layer addAnimation:animation forKey:@"animation"];
        
        [_centerView addSubview:_loadingImageView];
    }
}
//计算warning的文字距离边框的位置
-(float)warningStringMaring{
    return (AlertViewWidth - [[_labelTextArr firstObject]sizeWithFont:AppFontWithSize(AlertViewLabelFontSize)].width)/2;
}


#pragma 当是warning视图的时候设置是否加上关闭按钮
-(void)setUseCloseButton:(BOOL)useCloseButton{
    _useCloseButton = useCloseButton;
    if (useCloseButton && self.type==AlertViewWithWarning) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _closeButton.frame = CGRectMake( _centerView.frame.size.width -25, 7, 17, 17);
        [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(touchCloseButton) forControlEvents:UIControlEventTouchUpInside];
        [_centerView addSubview:_closeButton];
    }
}
-(void)touchCloseButton{
    [self hide];
}

#pragma 重新布局

-(void)setType:(AlertViewType)type{
    
    _type = type;
    
    if (type==AlertViewWithTable) {
        
        self.lastTextLabelWithCheckBox = NO;
        
        //重新布局
        for (UIView *view in _centerView.subviews) {
            [view removeFromSuperview];
        }
        
        
        int tableViewHeight = [_labelTextArr count]>=7?AlertViewTableMaxHeight:44*[_labelTextArr count];
        
        _centerView.frame = CGRectMake(0, 0, AlertViewWidth, tableViewHeight);
        _centerView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + (_headText?  AlertViewHeadViewHeight/2 :0) -(_btnTextArr?AlertViewBtnViewHeight/2:0) ); //居中显示
        
        
        _centerTableView = [[UITableView alloc]initWithFrame:CGRectMake(AlertCenterBorderWidth, 0, AlertViewWidth-AlertCenterBorderWidth*2, tableViewHeight) style:UITableViewStylePlain];
        
        _centerTableView.delegate = self;
        _centerTableView.dataSource = self;
        
        
        [_centerView addSubview:_centerTableView];
        
        
        //按钮层
        _btnView.frame = CGRectMake(0, _centerView.frame.origin.y + _centerView.frame.size.height, AlertViewWidth, AlertViewBtnViewHeight);
        _btnView.center = CGPointMake(self.frame.size.width/2, _btnView.center.y);
        
        
        if (_headText!=nil) {
            //头部层
            _headView.frame = CGRectMake(0, _centerView.frame.origin.y - AlertViewHeadViewHeight, AlertViewWidth, AlertViewHeadViewHeight);
            _headView.center = CGPointMake(self.frame.size.width/2, _headView.center.y);
        }
        
    }
}



#pragma 重新布局的tableview视图


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_labelTextArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentify = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify];
    
    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentify];
        
    }
    
    
    cell.frame = CGRectMake(0, 0, AlertViewWidth, cell.frame.size.height);
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = self.tableViewCellTouchColor;
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0) ;
    }
    
    cell.backgroundColor = self.tableViewCellBgColor;
    cell.textLabel.textColor = self.tableViewCellFontColor;
    cell.textLabel.font = AppFontWithSize(AlertViewLabelFontSize);
    
    cell.textLabel.text = _labelTextArr[indexPath.row];
    
    
    if (self.cellAccessoryType==AlertViewCellWithAccessoryView) {
        UIImageView *accessoryViewImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:indexPath.row==self.cellInitSelectIndex?@"cellSelected":@"cellUnselected"]];
        accessoryViewImage.frame = CGRectMake(0, 0, 19, 19);
        cell.accessoryView = accessoryViewImage;
        accessoryViewImage = nil;
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning 在这里订制选择tableView返回的数据
    
    
    NSLog(@"选择第%d个cell,内容为：%@",indexPath.row+1,_labelTextArr[indexPath.row]);
    
    _btnPressBlock(-1,_labelTextArr[indexPath.row]);
    
    [self hide];
}


#pragma 更改tableview的颜色布局

-(void)setTableViewCellBgColor:(UIColor *)tableViewCellBgColor{
    
    _tableViewCellBgColor = tableViewCellBgColor;
    
    if (self.type!=AlertViewWithTable) {
        return;
    }
    
    [_centerTableView reloadData];
}
-(void)setTableViewCellFontColor:(UIColor *)tableViewCellFontColor{
    
    _tableViewCellFontColor = tableViewCellFontColor;
    
    if (self.type!=AlertViewWithTable) {
        return;
    }
    
    [_centerTableView reloadData];
}
-(void)setTableViewCellTouchColor:(UIColor *)tableViewCellTouchColor{
    
    _tableViewCellTouchColor = tableViewCellTouchColor;
    
    if (self.type!=AlertViewWithTable) {
        return;
    }
    
    [_centerTableView reloadData];
}


#pragma 更改tableview中cell的布局

-(void)setCellAccessoryType:(AlertViewCellAccessoryType)cellAccessoryType{
    _cellAccessoryType = cellAccessoryType;
    if (cellAccessoryType==AlertViewCellWithAccessoryView && self.type==AlertViewWithTable) {
        [_centerTableView reloadData];
    }
}

-(void)setCellInitSelectIndex:(int)cellInitSelectIndex{
    _cellInitSelectIndex = cellInitSelectIndex;
    
    if (self.cellAccessoryType==AlertViewCellWithAccessoryView && self.type==AlertViewWithTable) {
        [_centerTableView reloadData];
    }
}

#pragma 动画

-(void)show{
    
    //动画   0.05 -> 1.1 -> 0.9 ->1.0
    float beginNumber = 0.05;
    NSMutableArray *scaleNumbers = [[NSMutableArray alloc]initWithObjects:@1.1,@0.9,@1.0, nil];
    NSMutableArray *times = [[NSMutableArray alloc]initWithObjects:@(kTransitionDuration/1.5),@(kTransitionDuration/2),@(kTransitionDuration/2), nil];
    [self animationBeginScaleNumber:beginNumber toScaleNumbers:scaleNumbers withDurations:times beginAnimation:^{
        [[[UIApplication sharedApplication]keyWindow]addSubview:self];
        
    } endAnimation:^{
        
        
        //当为warning视图时，在规定的时间内自动隐藏
        if (self.type==AlertViewWithWarning) {
            if (self.warningDurations>=0) {
                double delayInSeconds = self.warningDurations;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    NSLog(@"warning自动隐藏");
                    [self hide];
                });
            }
        }
        
    }];
    scaleNumbers = nil;
    times = nil;
}

-(void)hide{
    
    //    //动画   1.0 -> 0.9 -> 1.1 -> 0.05 -> remove
    //    float beginNumber = 1.0;
    //    NSMutableArray *scaleNumbers = [[NSMutableArray alloc]initWithObjects:@0.9,@1.1,@0.05, nil];
    //    NSMutableArray *times = [[NSMutableArray alloc]initWithObjects:@(kTransitionDuration/1.5),@(kTransitionDuration/2),@(kTransitionDuration/1), nil];
    //    [self animationBeginScaleNumber:beginNumber toScaleNumbers:scaleNumbers withDurations:times beginAnimation:^{
    //    } endAnimation:^{
    //        if (self.type==AlertViewWithWarning) {
    //            self.endWarningBlock();
    //        }
    //        [self removeFromSuperview];
    //    }];
    //    scaleNumbers = nil;
    //    times = nil;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            
            if (self.type==AlertViewWithWarning) {
                self.endWarningBlock();
            }
            
            [self removeFromSuperview];
        }
    }];
}


/**
 *  弹出层动画
 *
 *  @param begin 开始的view scale大小
 *  @param ends  过渡的view scale大小
 *  @param times 每个过渡的时间
 */
-(void)animationBeginScaleNumber:(float)begin toScaleNumbers:(NSMutableArray *)ends withDurations:(NSMutableArray *)times beginAnimation:(void(^)(void))beginAnimation endAnimation:(void(^)(void))endAnimation{
    //动画开始的执行
    beginAnimation();
    //开始scale的大小
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, begin, begin);
    //执行动画
    [self animationWithNumbers:ends andDurations:times endAnimation:[endAnimation copy]];
}
-(void)animationWithNumbers:(NSMutableArray *)numbers andDurations:(NSMutableArray *)times endAnimation:(void(^)(void))endAnimation{
    
    [UIView animateWithDuration:[[times firstObject]floatValue ] animations:^{
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, [[numbers firstObject] floatValue], [[numbers firstObject] floatValue]);
    } completion:^(BOOL finished) {
        if (finished) {
            if ([numbers count]>1) {
                [numbers removeObjectAtIndex:0];
                [times removeObjectAtIndex:0];
                //依次执行动画
                [self animationWithNumbers:numbers andDurations:times endAnimation:[endAnimation copy]];
            }else{
                //动画结束的执行
                endAnimation();
            }
        }
    }];
    
}


-(void)dealloc{
    
    _headText = nil;
    _title = nil;
    _labelTextArr = nil;
    _btnTextArr = nil;
    _btnPressBlock = nil;
    _headView = nil;
    _centerView = nil;
    _btnView = nil;
    _checkBox = nil;
    _centerTableView = nil;
    _loadingImageView = nil;
}
@end
