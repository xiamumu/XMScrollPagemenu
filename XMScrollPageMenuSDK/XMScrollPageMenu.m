//
//  XMScrollPageMenu.m
//  KuaiPin
//
//  Created by 21_xm on 16/5/10.
//  Copyright © 2016年 21_xm. All rights reserved.
//


#define View_W self.frame.size.width
#define View_H self.frame.size.height

#define RGBColor(r, g, b)  [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]
#define RandomColor RGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#import "XMScrollPageMenu.h"

@class XMTopButtonsView;
@protocol XMTopButtonsViewDelegate <NSObject>

- (void)topView:(XMTopButtonsView *)topView didSelectedBtnAtIndex:(NSInteger)index;

@end

@interface XMTopButtonsView : UIView<UIScrollViewDelegate>

@property (nonatomic, assign) id <XMTopButtonsViewDelegate> delegate;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) NSInteger selectedPageIndex;

@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *slider;
@property (nonatomic, assign) CGFloat height;

// 标题文字
/** 上面的标题默认颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 上面的标题选中后颜色 */
@property (nonatomic, strong) UIColor *titleSelectedColor;
/** 上面的标题文字大小 */
@property (nonatomic, strong) UIFont *titleFont;
/** 上面的标题选中后文字大小 */
@property (nonatomic, strong) UIFont *titleSelectedFont;
/** 每一行所显示的按钮个数 */
@property (nonatomic, assign) NSInteger numberOfTitles;


// 滑块
/** 文字下面滑块的颜色 */
@property (nonatomic, strong) UIColor *sliderColor;
/** 文字下面滑块Size */
@property (nonatomic, assign) CGSize sliderSize;


@property (nonatomic, strong) NSMutableArray *btns;

@end

@implementation XMTopButtonsView
#pragma mark - 懒加载
- (NSMutableArray *)btns
{
    if (_btns == nil) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.height = 40;
//        self.sliderHeight = 2;
        self.backgroundColor = [UIColor whiteColor];
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.delegate = self;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
    }
    return self;
}
// 设置按钮上面的文字
- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    NSUInteger count = titles.count;
    
    for (int i = 0; i < count ; i++) {
        UIButton *btn = [self addBtnWithTitle:titles[i]];
        btn.tag = i;
        
        if (i == 0) {
            [self orderChangeAction:btn];
        }
        
        [self.scrollView addSubview:btn];
        [self.btns addObject:btn];
    }
    UIView *slider = [[UIView alloc] init];
    slider.backgroundColor = [UIColor orangeColor];
    [self.scrollView addSubview:slider];
    self.slider = slider;
    
}
// 设置默认选择第几个按钮
- (void)setSelectedPageIndex:(NSInteger)selectedPageIndex
{
    _selectedPageIndex = selectedPageIndex;
    
    [self orderChangeAction:self.btns[selectedPageIndex]];
}
// 设置自身高度
- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}
// 文字设置
- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    for (UIButton *btn in self.btns) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
}
- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor
{
    _titleSelectedColor = titleSelectedColor;
    for (UIButton *btn in self.btns) {
        [btn setTitleColor:titleSelectedColor forState:UIControlStateSelected];
    }
}
- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    for (UIButton *btn in self.btns) {
        btn.titleLabel.font = titleFont;
    }
}
- (void)setTitleSelectedFont:(UIFont *)titleSelectedFont
{
    _titleSelectedFont = titleSelectedFont;
    for (UIButton *btn in self.btns) {
        if (btn.selected == YES) {
            btn.titleLabel.font = titleSelectedFont;
        }
    }
}

// 滑块设置
- (void)setSliderColor:(UIColor *)sliderColor
{
    _sliderColor = sliderColor;
    self.slider.backgroundColor = sliderColor;
}

#pragma  mark - 私有方法
// 按钮点击
- (void)orderChangeAction:(UIButton *)btn
{
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;

    // 设置滑块的位置
    if (self.sliderSize.height != 0) {
        CGFloat sliderX = btn.frame.origin.x + (btn.frame.size.width- self.sliderSize.width) * 0.5;
        CGFloat sliderY = self.height - self.sliderSize.height;
        CGFloat sliderW = self.sliderSize.width;
        CGFloat sliderH = self.sliderSize.height;
        self.slider.frame = CGRectMake(sliderX, sliderY, sliderW, sliderH);
    }
    else
    {
        self.slider.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(btn.frame), btn.frame.size.width, 2);
    }

    // 设置文字和滑块滚动的位置
    CGPoint point = CGPointMake(btn.frame.origin.x, 0);
    CGFloat btnMaxX = CGRectGetMaxX(btn.frame);
    CGFloat maxX = (self.titles.count + 2) * btn.frame.size.width - View_W;
    
    if (btnMaxX < maxX) {
        [self.scrollView setContentOffset:point animated:YES];
    }
    
    // 重新设置文字大小
    self.titleSelectedFont = self.titleSelectedFont;
    for (UIButton *btn in self.btns) {
        if (btn.selected == NO) {
            btn.titleLabel.font = self.titleFont;
        }
    }
    
    // 传递代理
    if ([self.delegate respondsToSelector:@selector(topView:didSelectedBtnAtIndex:)]) {
        [self.delegate topView:self didSelectedBtnAtIndex:btn.tag];
    }
}

// 添加一个按钮
- (UIButton *)addBtnWithTitle:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(orderChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.btns.count;
    
    CGFloat btnW;
    NSUInteger numberOftitles = self.numberOfTitles;
    if (numberOftitles != 0) {
        btnW = View_W / numberOftitles;
    }
    else
    {
        if (count <= 5) {
            btnW = View_W / count;
        }
        else
        {
            btnW = View_W / 6 + 5;
        }
    }

    CGFloat sliderHeight = self.sliderSize.height;
    CGFloat sliderWidth = self.sliderSize.width;
    if (sliderHeight == 0) {
        sliderHeight = 2;
        
    }
    if (sliderWidth == 0) {
        sliderWidth = btnW;
    }
    
    self.slider.frame = CGRectMake((btnW - sliderWidth) * 0.5, self.height - sliderHeight, sliderWidth, sliderHeight);
    
    for (int i = 0; i < count ; i++) {
        UIButton *btn = self.btns[i];
        btn.frame = CGRectMake(btnW * i, 0, btnW, self.height - sliderHeight);
    }
    
    self.scrollView.frame = CGRectMake(0, 0, View_W, self.height);
    self.scrollView.contentSize = CGSizeMake(btnW * count, 0);
    
    // 更新默认选择显示第几页时滑块的位置
    CGFloat sliderCenter_X = self.slider.center.x;
    CGFloat selectedBtnCenter_X = self.selectedBtn.center.x;
    if (sliderCenter_X != selectedBtnCenter_X) {
        self.slider.center = CGPointMake(selectedBtnCenter_X, self.slider.center.y);
    }
}
@end



//=================================

@interface XMScrollPageMenu ()<XMTopButtonsViewDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) XMTopButtonsView *topView;
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation XMScrollPageMenu
#pragma mark - 初始化
+ (instancetype)menu
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    XMTopButtonsView *topView = [[XMTopButtonsView alloc] init];
    topView.delegate = self;
    [self addSubview:topView];
    self.topView = topView;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}
#pragma mark - 重写属性方法
/**
 *  整体设置
 */
// 设置下面的子View的数组
- (void)setChildViews:(NSArray *)childViews
{
    _childViews = childViews;
    
    NSInteger count = childViews.count;
    
    self.scrollView.contentSize = CGSizeMake(View_W * count, 0);
    for (int i = 0; i < count ; i++) {
        UIViewController *childVc = childViews[i];
        childVc.view.frame = CGRectMake(View_W * i, 0, View_W, View_H - 40);
        [self.scrollView addSubview:childVc.view];
    }
    
}
// 设置默认选择的按钮
- (void)setSelectedPageIndex:(NSInteger)selectedPageIndex
{
    _selectedPageIndex = selectedPageIndex;
    self.topView.selectedPageIndex = selectedPageIndex;
    [self topView:self.topView didSelectedBtnAtIndex:selectedPageIndex];
}

// 设置上面按钮的文字数组
- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    self.topView.titles = titles;
}
// 设置上面滚动条的高度
- (void)setTitleBarHeight:(CGFloat)titleBarHeight
{
    _titleBarHeight = titleBarHeight;
    self.topView.frame = CGRectMake(0, 0, View_W, titleBarHeight);
}
// 设置上面可以显示的按钮个数
- (void)setNumberOfTitles:(NSInteger)numberOfTitles
{
    _numberOfTitles = numberOfTitles;
    self.topView.numberOfTitles = numberOfTitles;
}

/**
 *  具体文字设置
 */
// 文字未选中时的颜色
- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    self.topView.titleColor = titleColor;
}
// 文字选中时的颜色
- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor
{
    _titleSelectedColor = titleSelectedColor;
    self.topView.titleSelectedColor = titleSelectedColor;
}

// 未选中文字的大小
- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    self.topView.titleFont = titleFont;
}
// 选中文字的大小
- (void)setTitleSelectedFont:(UIFont *)titleSelectedFont
{
    _titleSelectedFont = titleSelectedFont;
    self.topView.titleSelectedFont = titleSelectedFont;
}

/**
 *  滑块的具体设置
 */
// 滑块的颜色
- (void)setSliderColor:(UIColor *)sliderColor
{
    _sliderColor = sliderColor;
    self.topView.sliderColor = sliderColor;
}
// 滑块的高度
- (void)setSliderSize:(CGSize)sliderSize
{
    _sliderSize = sliderSize;
    self.topView.sliderSize = sliderSize;
}

#pragma mark - 私有方法
// 滚动的时候上面的按钮跟着变换
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger currentPage = scrollView.contentOffset.x / View_W;

    // 根据滚动的位置切换被选中的按钮
    self.topView.selectedPageIndex = currentPage;
}
// 点击按钮下面的View跟着滚动
- (void)topView:(XMTopButtonsView *)topView didSelectedBtnAtIndex:(NSInteger)index
{
    CGPoint point = CGPointMake(View_W * index, 0);
    [self.scrollView setContentOffset:point animated:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat topViewH = 40;
    if (!self.titleBarHeight) {
        self.topView.frame = CGRectMake(0, 0, View_W, topViewH);
    }
    CGFloat topViewMaxY = CGRectGetMaxY(self.topView.frame);
    self.scrollView.frame = CGRectMake(0, topViewMaxY, View_W, View_H - topViewMaxY);
}
@end


