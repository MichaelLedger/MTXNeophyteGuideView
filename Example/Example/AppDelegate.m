//
//  AppDelegate.m
//  Example
//
//  Created by MountainX on 2019/1/9.
//  Copyright © 2019年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "MTXNeophyteGuideView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //1.创建Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //a.初始化一个tabBar控制器
    UITabBarController *tb=[[UITabBarController alloc]init];
    //设置控制器为Window的根控制器
    self.window.rootViewController=tb;
    
    //b.创建子控制器
    NSArray <NSString *> *titles = @[@"Home", @"Message", @"Discover", @"Profile"];
    NSArray <NSString *> *tabBarImages = @[@"tabbar_home", @"tabbar_message_center", @"tabbar_discover", @"tabbar_profile"];
    NSArray <NSString *> *tabBarSelectedImages = @[@"tabbar_home_selected", @"tabbar_message_center_selected", @"tabbar_discover_selected", @"tabbar_profile_selected"];
    NSArray <NSString *> *tabBarBadges = @[@"", @"1", @"", @"99+"];
    NSArray <NSString *> *bgImages = @[@"sea", @"laker", @"rain", @"beauty"];
    
    NSMutableArray *viewcontrollers = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i ++) {
        HomeViewController *vc=[[HomeViewController alloc]init];
        vc.title = titles[i];
        vc.bgImageName = bgImages[i];
        vc.tabBarItem.title=titles[i];
        vc.tabBarItem.image = [[UIImage imageNamed:tabBarImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:tabBarSelectedImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if (tabBarBadges[i].length) vc.tabBarItem.badgeValue = tabBarBadges[i];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [viewcontrollers addObject:nav];
    }
    
    //c.添加子控制器到ITabBarController中
    tb.viewControllers = viewcontrollers;
    
    //d.配置TabbarItem标题
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName:[UIFont fontWithName:@"Marion-Italic" size:14.0]}            forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor orangeColor],NSFontAttributeName:[UIFont fontWithName:@"Marion-Italic" size:14.0]}            forState:UIControlStateSelected];
    
    //2.设置Window为主窗口并显示出来
    [self.window makeKeyAndVisible];
    
    //3.添加新手引导
    [self setupNeophyteGuide];
    
    return YES;
}

#pragma mark - 新手引导
- (void)setupNeophyteGuide {
    NSArray <UIImage *> *opaqueImages = @[[UIImage imageNamed:@"book_activity"],[UIImage imageNamed:@"bookshelf_download_book"],[UIImage imageNamed:@"whiteboard_pen"]];
    NSArray <NSValue *> *opaqueRects = @[[NSValue valueWithCGRect:CGRectMake(50, 100, 300, 100)],[NSValue valueWithCGRect:CGRectMake(50, 360, 300, 150)],[NSValue valueWithCGRect:CGRectMake(50, [UIScreen mainScreen].bounds.size.height - 250, 200, 150)]];
    NSArray <UIImage *> *lucencyImages = @[[UIImage imageNamed:@"dashed_rect"],[UIImage imageNamed:@"dashed_rect"],[UIImage imageNamed:@"dashed_rect"]];
    NSArray <NSValue *> *lucencyRects = @[[NSValue valueWithCGRect:CGRectMake(20, 200, 100, 50)],[NSValue valueWithCGRect:CGRectMake(100, 260, 100, 100)],[NSValue valueWithCGRect:CGRectMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height - 100, 100, 100)]];
    // 快速创建初始化新手引导视图
    MTXNeophyteGuideView *guideView = [[MTXNeophyteGuideView alloc] initWithOpaqueImages:opaqueImages opaqueRects:opaqueRects lucencyImages:lucencyImages lucencyRects:lucencyRects];
    // 每次单击回调，回调参数为单击次数
    guideView.clickBlock = ^(NSInteger clickTimes) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UITabBarController *tab = (UITabBarController *)delegate.window.rootViewController;
        [tab setSelectedIndex:clickTimes < 4 ? clickTimes : 3];
    };
    // 所有的图片是否在同一时间展示，默认为NO，即单击一次显示一张直到消失
    //guideView.showAtOnce = YES;
    // 所有图片圆角大小，默认为5
    //guideView.cornerRadius = 10.f;
    // 展示的渐变动画时长，默认为0.5
    guideView.showTime = 1.f;
    // 隐藏的渐变动画时长，默认为0.5
    guideView.hideTime = .5f;
    // 引导视图的填充颜色，默认为[UIColor colorWithWhite:0 alpha:0.6]
    //guideView.fillColor = [UIColor colorWithRed:46/255.f green:152/255.f blue:152/255.f alpha:0.2];
    // 所有图片是否取消自适应图片原始尺寸，默认为NO，即自适应图片大小
    // guideView.disableAutoFitSize = YES;
    [guideView show];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
