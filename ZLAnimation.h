//
//  ZLAnimation.h
//  ZLPlayNews
//
//  Created by hezhonglin on 16/11/22.
//  Copyright © 2016年 TsinHzl. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface ZLAnimation : NSObject

+ (instancetype)sharedAnimation;

/** 显示加载视图 */
- (void)show;
- (void)showIsCover:(BOOL)isCover isAnimation:(BOOL)isAnimation;
/** 隐藏 */
- (void)hide;
/** 根据指定动画图片显示加载视图 */
- (void)showWithAnimationImages:(NSArray<NSString *> *)imageNames imageSize:(CGSize)size isCover:(BOOL)isCover isAnimation:(BOOL)isAnimation viewController:(UIViewController *)viewController;
/** 根据指定动画图片显示加载视图 */
- (void)showWithAnimationImages:(NSArray<NSString *> *)imageNames imageSize:(CGSize)size timeInterval:(CGFloat)interval isCover:(BOOL)isCover isAnimation:(BOOL)isAnimation viewController:(UIViewController *)viewController;


@end
