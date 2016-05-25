//
//  XMScrollPageMenu.h
//  KuaiPin
//
//  Created by 21_xm on 16/5/10.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMScrollPageMenu : UIView
// 整体设置
/** 子控制器数组 */
@property (nonatomic, strong) NSArray *childViews;
/** 上面的标题需要显示的问题的数组 */
@property (nonatomic, strong) NSArray *titles;
/** 默认选中的页面 */
@property (nonatomic, assign) NSInteger selectedPageIndex;
/** 每一行所显示的按钮个数 */
@property (nonatomic, assign) NSInteger numberOfTitles;
/** 上面滚动标题的整体高度 */
@property (nonatomic, assign) CGFloat titleBarHeight;


// 标题文字
/** 上面的标题默认颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 上面的标题选中后颜色 */
@property (nonatomic, strong) UIColor *titleSelectedColor;
/** 上面的标题默认文字大小 */
@property (nonatomic, strong) UIFont *titleFont;
/** 上面的标题选中后文字大小 */
@property (nonatomic, strong) UIFont *titleSelectedFont;


// 滑块
/** 文字下面滑块的颜色 */
@property (nonatomic, strong) UIColor *sliderColor;
/** 文字下面滑块frame */
@property (nonatomic, assign) CGSize sliderSize;


/**
 *  类方法初始化
 */
+ (instancetype)menu;

@end
