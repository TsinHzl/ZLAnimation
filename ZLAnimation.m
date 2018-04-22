//
//  ZLAnimation.m
//  ZLPlayNews
//
//  Created by hezhonglin on 16/11/22.
//  Copyright © 2016年 TsinHzl. All rights reserved.
//

#import "ZLAnimation.h"

@interface ZLAnimation()<NSCopying>

@property(nonatomic, strong)UIWindow *window;
@property(nonatomic, strong)NSMutableArray *animImages;
@property(nonatomic, strong)UIImageView *animView;
@property(nonatomic, strong)UIViewController *vc;

@end

static CGFloat const ZLAnimationInterval = 0.06f;
static CGFloat const ZLShowAnimationInterval = 0.2f;

static ZLAnimation *anim_ = nil;

@implementation ZLAnimation

#pragma mark - 单例
+ (instancetype)sharedAnimation {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        anim_ = [[ZLAnimation alloc] init];
    });
    return anim_;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        anim_ = [super allocWithZone:zone];
    });
    return anim_;
}

- (id)copyWithZone:(NSZone *)zone {
    return anim_;
}

#pragma mark - 懒加载
- (UIImageView *)animView {
    if (!_animView) {
        UIImageView *animView = [[UIImageView alloc] initWithFrame:self.window.rootViewController.view.bounds];
        _animView = animView;
    }
    return _animView;
}

- (NSMutableArray *)animImages {
    if (!_animImages) {
        _animImages = [NSMutableArray array];
    }
    return _animImages;
}

#pragma mark - 隐藏加载视图并同时进行性能优化
- (void)zl_hide
{
    [self.animView stopAnimating];
    [self.animView removeFromSuperview];
    [self.animImages removeAllObjects];
    self.window.hidden = YES;
    self.window = nil;
}
#pragma mark - 显示加载视图

- (void)zl_show {
    [self zl_showIsCover:NO isAnimation:NO];
}
- (void)zl_showIsCover:(BOOL)isCover isAnimation:(BOOL)isAnimation
{
    NSMutableArray *imageNames = [NSMutableArray array];
    for (int i = 1; i < 22; i++) {
        NSString *imageName = [NSString stringWithFormat:@"ZLAnimation.bundle/list_loading_0%02d.png",i];
        [imageNames addObject:imageName];
    }
    [self zl_showWithAnimationImages:imageNames imageSize:CGSizeMake(200, 200) timeInterval:ZLAnimationInterval isCover:isCover isAnimation:isAnimation viewController:nil];
}

- (void)zl_showWithAnimationImages:(NSArray<NSString *> *)imageNames imageSize:(CGSize)size isCover:(BOOL)isCover isAnimation:(BOOL)isAnimation viewController:(UIViewController *)viewController {
    [self zl_showWithAnimationImages:imageNames imageSize:size timeInterval:0 isCover:isCover isAnimation:isAnimation viewController:viewController];
}

- (void)zl_showWithAnimationImages:(NSArray<NSString *> *)imageNames imageSize:(CGSize)size timeInterval:(CGFloat)interval isCover:(BOOL)isCover isAnimation:(BOOL)isAnimation viewController:(UIViewController *)viewController {
    
    UIViewController *rootViewController = [[UIViewController alloc] init];
    rootViewController.view.backgroundColor = [UIColor clearColor];
    self.window = [[UIWindow alloc] init];
    self.window.rootViewController = rootViewController;
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.hidden = NO;
    self.window.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:isCover];
    self.window.userInteractionEnabled = NO;
    
    NSInteger count = imageNames.count;
    for (int i = 0; i < count; i++) {
        UIImage *img = [UIImage imageNamed:imageNames[i]];
        [self.animImages addObject:img];
    }
    self.animView.frame = CGRectMake(0, 0, size.width, size.height);
    self.animView.center = CGPointMake(self.window.frame.size.width/2, self.window.frame.size.height/2);
    self.animView.animationImages = self.animImages;
    if (interval == 0) {
        interval = ZLAnimationInterval;
    }
    self.animView.animationDuration = interval * self.animImages.count;
    self.animView.animationRepeatCount = 0;
    [self.window.rootViewController.view addSubview:self.animView];
    [self.animView startAnimating];
    if (isAnimation) {
        self.window.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [UIView animateWithDuration:ZLShowAnimationInterval animations:^{
            CGRect frame = self.window.frame;
            frame.origin.x = 0;
            self.window.frame = frame;
        }];
    }
    if (viewController) {
        self.vc = viewController;
        self.window.userInteractionEnabled = YES;
        [self addTapGr];
    }
}

- (void)addTapGr {
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quitAnimWindow)];
    [self.window.rootViewController.view addGestureRecognizer:tapGr];
}

- (void)quitAnimWindow {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:ZLShowAnimationInterval animations:^{
        CGRect frame = weakSelf.window.frame;
        frame.origin.x = weakSelf.window.frame.size.width;
        weakSelf.window.frame = frame;
        [weakSelf.vc.navigationController popViewControllerAnimated:NO];
    } completion:^(BOOL finished) {
        [weakSelf zl_hide];
    }];
}

@end
