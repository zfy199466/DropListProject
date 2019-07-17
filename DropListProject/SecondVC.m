//
//  SecondVC.m
//  NavBackgroundColorDemo
//
//  Created by HT on 2019/7/15.
//  Copyright © 2019 HT. All rights reserved.
//

#import "SecondVC.h"
#import "DropListVC.h"

@interface SecondVC ()<DropListVCDelegate>

@end

@implementation SecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)showFirstDropListAction:(UIButton *)sender {
    DropListVC *list = [DropListVC dropListView];
    list.orginView = sender;
    list.datas = @[@"AAAAAA",@"BBBBB",@"CCCCC",@"DDD"];
    list.dropDelegate = self;
    [list showDropListWithViewController:self];
}

- (IBAction)showSecondDropListAction:(UIButton *)sender {
    DropListVC *list = [DropListVC dropListView];
    list.orginView = sender;
    list.datas = @[@"111111",@"222222",@"333333",@"4444444"];
    list.dropDelegate = self;
    [list showDropListWithViewController:self];
}

- (IBAction)showThirdDropListAction:(UIButton *)sender {
    DropListVC *list = [DropListVC dropListView];
    list.orginView = sender;
    list.datas = @[@"苹果",@"菠萝",@"哈密瓜",@"桃子"];
    list.dropDelegate = self;
    [list showDropListWithViewController:self];
}

#pragma mark - DropListVCDelegate
- (void)dropListView:(DropListVC *)dropListVC selectedResult:(NSString *)result selectedIndex:(NSInteger)index{
    NSLog(@"%@",result);
}

@end
