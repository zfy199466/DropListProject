//
//  ViewController.m
//  DropListProject
//
//  Created by HT on 2019/7/17.
//  Copyright © 2019 HT. All rights reserved.
//

#import "ViewController.h"
#import "DropListVC.h"

@interface ViewController ()<DropListVCDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)navShowDropListAction:(UIButton *)sender {
    DropListVC *list = [DropListVC dropListView];
    list.orginView = sender;
    list.datas = @[@"导航条第一个",@"导航条第二个",@"导航条第三个",@"导航条第四个"];
    list.dropDelegate = self;
    [list showDropListWithViewController:self];
}


- (IBAction)showDropListViewAction:(UIButton *)sender {
    DropListVC *list = [DropListVC dropListView];
    list.orginView = sender;
    list.datas = @[@"111111",@"222222",@"333333",@"4444444"];
    list.dropDelegate = self;
    [list showDropListWithViewController:self];
}

- (IBAction)showSecondDropListAction:(UIButton *)sender {
    DropListVC *list = [DropListVC dropListView];
    list.orginView = sender;
    list.datas = @[@"AAAAAA",@"BBBBB",@"CCCCC",@"DDD"];
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
