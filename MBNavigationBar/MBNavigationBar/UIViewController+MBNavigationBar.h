//
//  UIViewController+MBNavigationBar.h
//  MBNavigationBar
//
//  Created by user on 16/4/11.
//  Copyright © 2016年 mobin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MBNavigationBar)

/** 监听的scrollView*/
@property (nonatomic,weak) UIScrollView *observerScrollView;

/** 是否随着滑动变化透明度,默认No*/
@property (nonatomic,assign,getter=isLeftBarAlpha) BOOL leftBarAlpha;
@property (nonatomic,assign,getter=isRightBarAlpha) BOOL rightBarAlpha;
@property (nonatomic,assign,getter=isTitileBarAlpha) BOOL titleBarAlpha;

/** ScrollView的Y轴偏移量大于scrolOffsetY的距离后,导航条的alpha为1 */
@property (nonatomic,assign) CGFloat scrollOffsetY;

- (void)setInViewWillAppear;
- (void)setInViewWillDisappear;

- (void)scrollViewDidScrollToControl;



@end
