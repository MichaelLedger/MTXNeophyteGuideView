//
//  HomeViewController.m
//  Example
//
//  Created by MountainX on 2019/1/9.
//  Copyright © 2019年 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.bgImageName) {
        // 背景图片
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.bgImageName]];
        iv.frame = self.view.bounds;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:iv];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
