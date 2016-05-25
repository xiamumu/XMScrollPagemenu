//
//  ViewController.m
//  XMScrollPageMenu
//
//  Created by 21_xm on 16/5/23.
//  Copyright © 2016年 sean.xia. All rights reserved.
//

#import "ViewController.h"
#import "XMScrollPageMenu.h"
#import "TestViewControllerOne.h"
#import "TestViewControllerTow.h"
#import "TestViewControllerThree.h"
#import "TestViewControllerFour.h"
#import "TestViewControllerFive.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    XMScrollPageMenu *menu = [XMScrollPageMenu menu];
    menu.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    
    TestViewControllerOne *one = [[TestViewControllerOne alloc] init];
    TestViewControllerTow *tow = [[TestViewControllerTow alloc] init];
    TestViewControllerThree *three = [[TestViewControllerThree alloc] init];
    TestViewControllerFour *four = [[TestViewControllerFour alloc] init];
    TestViewControllerFive *five = [[TestViewControllerFive alloc] init];
    
    TestViewControllerOne *one1 = [[TestViewControllerOne alloc] init];
    TestViewControllerTow *tow2 = [[TestViewControllerTow alloc] init];
    TestViewControllerThree *three3 = [[TestViewControllerThree alloc] init];
    TestViewControllerFour *four4 = [[TestViewControllerFour alloc] init];
    TestViewControllerFive *five5 = [[TestViewControllerFive alloc] init];
    
    TestViewControllerOne *one6 = [[TestViewControllerOne alloc] init];
    TestViewControllerTow *tow7 = [[TestViewControllerTow alloc] init];
    TestViewControllerThree *three8 = [[TestViewControllerThree alloc] init];
    TestViewControllerFour *four9 = [[TestViewControllerFour alloc] init];
    TestViewControllerFive *five0 = [[TestViewControllerFive alloc] init];
    
    
    menu.childViews = @[one, tow, three, four, five, one1, tow2, three3, four4, five5, one6, tow7, three8, four9, five0];
    menu.titles = @[@"首页", @"订阅", @"科技", @"娱乐", @"新闻", @"首页", @"订阅", @"科技", @"娱乐", @"新闻", @"首页", @"订阅", @"科技", @"娱乐", @"新闻"];
    menu.selectedPageIndex = 0;
    menu.titleColor = [UIColor redColor];
    menu.titleSelectedColor = [UIColor blackColor];
    menu.titleFont = [UIFont systemFontOfSize:20];
    menu.titleSelectedFont = [UIFont systemFontOfSize:15];
    menu.sliderColor = [UIColor blueColor];
    menu.numberOfTitles = 6;
//    menu.titleBarHeight = 100;
    [self.view addSubview:menu];
    
}



@end
