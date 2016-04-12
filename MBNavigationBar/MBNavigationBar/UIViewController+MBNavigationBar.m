//
//  UIViewController+MBNavigationBar.m
//  MBNavigationBar
//
//  Created by user on 16/4/11.
//  Copyright © 2016年 mobin. All rights reserved.
//

#import "UIViewController+MBNavigationBar.h"
#import <objc/runtime.h>

@interface  UIViewController()

@property (nonatomic,strong) UIImage *navBarBackgroundImage;
@end

@implementation UIViewController (MBNavigationBar)

#pragma mark -- 通过关联分类添加属性
static const char  kObserverViewKey ;
static const char  kLeftBarAlphaKey ;
static const char  kRightBarAlphaKey ;
static const char  kTitleBarAlphaKey ;
static const char  kScrollOffsetYkey ;
static const char  kNavBarBackgroundIamgeKey ;
#define force_inline __inline__ __attribute__((always_inline))


//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
-(UIScrollView *)observerScrollView
{

    return objc_getAssociatedObject(self, &kObserverViewKey);
}

- (void)setObserverScrollView:(UIScrollView *)observerScrollView
{

    objc_setAssociatedObject(self, &kObserverViewKey, observerScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isLeftBarAlpha
{
    return [objc_getAssociatedObject(self, &kLeftBarAlphaKey)boolValue];

}

- (void)setLeftBarAlpha:(BOOL)leftBarAlpha
{
    objc_setAssociatedObject(self, &kLeftBarAlphaKey, @(leftBarAlpha), OBJC_ASSOCIATION_ASSIGN);

}

- (BOOL)isRightBarAlpha
{
    return [objc_getAssociatedObject(self, &kRightBarAlphaKey)boolValue];
}

- (void)setRightBarAlpha:(BOOL)rightBarAlpha
{
    objc_setAssociatedObject(self, &kRightBarAlphaKey, @(rightBarAlpha), OBJC_ASSOCIATION_ASSIGN);

}


- (BOOL)isTitileBarAlpha
{
    return [objc_getAssociatedObject(self, &kTitleBarAlphaKey) boolValue];
}

- (void)setTitleBarAlpha:(BOOL)titleBarAlpha
{
    
    objc_setAssociatedObject(self, &kTitleBarAlphaKey, @(titleBarAlpha), OBJC_ASSOCIATION_ASSIGN);
}

-(CGFloat)scrollOffsetY
{
   return  [objc_getAssociatedObject(self, &kScrollOffsetYkey) floatValue];

}

- (void)setScrollOffsetY:(CGFloat)scrollOffsetY
{
    objc_setAssociatedObject(self, &kScrollOffsetYkey, @(scrollOffsetY), OBJC_ASSOCIATION_ASSIGN);

}

-(UIImage *)navBarBackgroundImage
{
      return  objc_getAssociatedObject(self, &kNavBarBackgroundIamgeKey);
}

- (void)setNavBarBackgroundImage:(UIImage *)navBarBackgroundImage
{
    objc_setAssociatedObject(self, &kNavBarBackgroundIamgeKey, navBarBackgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

#pragma mark -- 对外接口实现
- (void)setInViewWillAppear
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.navBarBackgroundImage = [self.navigationController.navigationBar
                                      backgroundImageForBarMetrics:UIBarMetricsDefault];
    });
    
    [self.navigationController.navigationBar setBackgroundImage:self.navBarBackgroundImage
                                                  forBarMetrics:UIBarMetricsDefault];
    
    // 消除边框
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    CGFloat offsetY = self.observerScrollView? self.observerScrollView.contentOffset.y -1:-1;
    getScrollView(self).contentOffset = CGPointMake(0, offsetY);
    NSLog(@"-----contenoffset1---%f",offsetY);
    getScrollView(self).contentOffset = CGPointMake(0, offsetY +1);
    NSLog(@"-----contenoffset2---%f",offsetY + 1);
    

    
}

static CGFloat alpha = 0;
static CGFloat const scrollOffsetConstY = 300;
- (void)scrollViewDidScrollToControl
{

    if (getScrollView(self)) {
        
        alpha = getScrollView(self).contentOffset.y/(self.scrollOffsetY? self.scrollOffsetY :scrollOffsetConstY);
    }else{
        return;
    }
    
    alpha = (alpha <=0)?0:alpha;
    NSLog(@"alpha2------%f",alpha);

    alpha = (alpha >=1)?1:alpha;
    NSLog(@"alpha3------%f",alpha);

    self.navigationItem.leftBarButtonItem.customView.alpha = self.isLeftBarAlpha?alpha : 1;
    self.navigationItem.rightBarButtonItem.customView.alpha = self.isRightBarAlpha?alpha : 1;
    self.navigationItem.titleView.alpha = self.isTitileBarAlpha?alpha : 1;
    
    NSLog(@"alpha----%f",alpha);
    self.navigationController.navigationBar.subviews[0].alpha = alpha;
}

- (void)setInViewWillDisappear
{

    [[self.navigationController.navigationBar subviews]objectAtIndex:0].alpha = 1;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

#pragma mark -- private method
//get tableView or collectionView
static force_inline UIScrollView  *getScrollView(__unsafe_unretained  UIViewController*vc)
{
   
    if ([vc isKindOfClass:[UITableViewController class]] ||
        [vc isKindOfClass:[UICollectionViewController class]]) {
        return  (UIScrollView *)vc.view;
    }else{
    
        for (UIView *view in vc.view.subviews) {
            if ([view isEqual:objc_getAssociatedObject(vc, &kObserverViewKey)] &&
                [view isKindOfClass:[UIScrollView class]]) {
                return (UIScrollView *)view;
            }
        }
    }
    return nil;
}








@end
