
//
//  DropListVC.m
//  FoldListView
//
//  Created by lezhudai on 2018/5/31.
//  Copyright © 2018年 lezhudai. All rights reserved.
//

#import "DropListVC.h"

/** 动画时间 */
#define kAnimatedDuration 0.25
/** 延迟加载时间 */
#define kAfterDuration 0.05
/** 箭头的宽度 */
#define kArrowWidth 16
/** 箭头的高度 */
#define kArrowHeight 14

@implementation DropConfig
- (instancetype)init{
    if (self = [super init]) {
        _titleFont = [UIFont systemFontOfSize:14.0f];
        _titleTextColor = [UIColor blackColor];
        _cellBackgroundColor = [UIColor whiteColor];
        _tableViewBackgroundColor = [UIColor whiteColor];
        _cellHeight = 40.0f;
        _FVHeight = 150.0f;
        _isShowSeparatorLine = YES;
        _separatorLeftInset = 0.0f;
        _separatorRightInset = 0.0f;
        _separatorColor = [UIColor grayColor];
        _customCell = NO;
        _customBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        _isShowCornerRadius = YES;
        _cornerRadiusNum = 5.0f;
        _isShowUpArrowView = YES;
        _arrowPosition = PositionCenter;
        _arrowLeftMargin = 15.0f;
        _arrowRightMargin = 15.0f;
    }
    return self;
}
@end

@interface DropListCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleTextLable;
@end

@implementation DropListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleTextLable = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleTextLable];
        self.titleTextLable.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleTextLable attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleTextLable attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleTextLable attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }
    return self;
}
@end

@interface DropListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGRect orginViewFrame;
@end

@implementation DropListVC

- (NSArray<NSString *> *)datas{
    if (!_datas) {
        _datas = [NSArray array];
    }return _datas;
}

- (DropConfig *)defaultConfig{
    if (!_defaultConfig) {
        _defaultConfig = [DropConfig new];
    }return _defaultConfig;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = self.defaultConfig.customBackgroundColor;
    
    if (self.orginView == nil) {
        return;
    }
    
    /** 此行代码是重点，通过控件的位置相对屏幕转换来获取在屏幕中的位置 */
    self.orginViewFrame = [self.orginView convertRect:self.orginView.bounds toCoordinateSpace:[UIScreen mainScreen].coordinateSpace];
    [self addTableView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    //如果是从横屏切到竖屏(或竖屏切到横屏)直接移除
    CGRect orginViewFrame = [self.orginView convertRect:self.orginView.bounds toCoordinateSpace:[UIScreen mainScreen].coordinateSpace];
    //通过判断两个frame不同从而得知旋转了屏幕
    if (!CGRectEqualToRect(orginViewFrame, self.orginViewFrame)) {
        [self closeTableView];
    }
}

#pragma mark - Private Function
/** 类方法初始化本对象类 */
+ (instancetype)dropListView{
    return [[self alloc]init];
}
/** 添加tableview */
- (void)addTableView{
    
    CGFloat screenH = self.view.frame.size.height;
    CGRect tbFrame = self.orginViewFrame;
    CGFloat tbX = tbFrame.origin.x;
    CGFloat tbY = tbFrame.origin.y + tbFrame.size.height;
    CGFloat tbW = tbFrame.size.width;
    CGFloat tbH = self.defaultConfig.FVHeight;
    
    //添加向上的箭头图标
    if (self.defaultConfig.isShowUpArrowView) {
        CGFloat positionX = 0;
        if (self.defaultConfig.arrowPosition == PositionLeft) {
            positionX = tbX + self.defaultConfig.arrowLeftMargin;
        } else if (self.defaultConfig.arrowPosition == PositionCenter) {
            positionX = tbW / 2 + tbX - (kArrowWidth / 2);
        } else {
            positionX = tbX + tbW - kArrowWidth - self.defaultConfig.arrowRightMargin;
        }
        UIView *arrowView = [[UIView alloc]initWithFrame:CGRectMake(positionX, tbY, kArrowWidth, kArrowHeight)];
        //arrowView.backgroundColor = [UIColor grayColor];
        CAShapeLayer *layer = [[CAShapeLayer alloc]init];
        UIBezierPath *path = [[UIBezierPath alloc]init];
        [path moveToPoint:CGPointMake(0, kArrowHeight)];
        [path addLineToPoint:CGPointMake(kArrowWidth * 0.5, 0)];
        [path addLineToPoint:CGPointMake(kArrowWidth, kArrowHeight)];
        layer.path = path.CGPath;
        layer.fillColor = self.defaultConfig.tableViewBackgroundColor.CGColor;
        [arrowView.layer addSublayer:layer];
        [self.view addSubview:arrowView];
    }
    //判断底部间隙
    if (screenH - tbY < self.defaultConfig.FVHeight) {
        //如果间隙大于等于2个cell的高度就直接取间隙的高度
        if (screenH - tbY >= 2 * self.defaultConfig.cellHeight) {
            tbH = screenH - tbY;
        }
        //否则就把列表展示在上方
        else {
            tbY = screenH - (screenH - tbY) - self.defaultConfig.FVHeight - tbFrame.size.height;
        }
    }
    //判断如果有箭头，tableview的Y需要加上箭头的高度
    if (self.defaultConfig.isShowUpArrowView) {
        tbY = tbY + kArrowHeight;
    }
    //如果宽度小于屏幕的1/4，默认宽度为1/4
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (tbW < screenWidth * 0.25) {
        tbW = screenWidth * 0.25;
    }
    //如果X+控件宽度大于屏幕宽度的时候，就往左边移动
    CGFloat value1 = tbX + tbW;
    if (value1 > screenWidth) {
        //计算右边的间隙，然后屏幕宽度-间隙-控件宽度，得出来的就是X点
        CGFloat margin = screenWidth - tbFrame.origin.x - tbFrame.size.width;
        tbX = screenWidth - margin - tbW;
    }
    //如果X+控件宽度没有大于屏幕宽度，而且控件宽度又小于屏幕宽度的1/4，这种情况没有做特殊的处理，这个看个人需求而添加了
    //TODO:Code
    //添加tableview列表
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(tbX, tbY, tbW, 0)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //设置tableview的圆角
    if (self.defaultConfig.isShowCornerRadius) {
        self.tableView.layer.cornerRadius = self.defaultConfig.cornerRadiusNum;
    }
    //设置tableview的分割线
    if (self.defaultConfig.isShowSeparatorLine) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorInset = UIEdgeInsetsMake(0, self.defaultConfig.separatorLeftInset, 0, self.defaultConfig.separatorRightInset);
        self.tableView.separatorColor = self.defaultConfig.separatorColor;
    } else {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    //设置tableview的背景色
    self.tableView.backgroundColor = self.defaultConfig.tableViewBackgroundColor;
    [self.view addSubview:self.tableView];

    /** 延迟进行一个加载，让tableview的高度慢慢展示，好有一个下拉平移展示效果 */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAfterDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kAnimatedDuration animations:^{
            self.tableView.frame = CGRectMake(tbX, tbY, tbW, tbH);
        }];
    });
}
/** 关闭列表页面 */
- (void)closeTableView{
    CGRect tbframe = self.tableView.frame;
    tbframe.size.height = 0;
    [UIView animateWithDuration:kAnimatedDuration animations:^{
        self.tableView.frame = tbframe;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:NULL];
    }];
}
/** 点击空白页面移除页面 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //判断如果点击不在tableview才进行关闭
    CGPoint point = [[touches anyObject] locationInView:self.view];
    point = [self.view.layer convertPoint:point toLayer:self.view.layer];
    if ([self.view.layer containsPoint:point]) {
        [self closeTableView];
    }
}
/** 展示当前类 */
- (void)showDropListWithViewController:(UIViewController *)vc{
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [vc presentViewController:self animated:NO completion:NULL];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.defaultConfig.customCell) {
        if (self.dropDelegate && [self.dropDelegate respondsToSelector:@selector(dropListViewCustomCell:tableView:indexPath:)]) {
            UITableViewCell *cell = [self.dropDelegate dropListViewCustomCell:self tableView:tableView indexPath:indexPath];
            return cell;
        }
        return nil;
    } else {
        DropListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DropListCell"];
        if (cell == nil) {
            cell = [[DropListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DropListCell"];
        }
        cell.titleTextLable.text = self.datas[indexPath.row];
        cell.titleTextLable.font = self.defaultConfig.titleFont;
        cell.titleTextLable.textColor = self.defaultConfig.titleTextColor;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.defaultConfig.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dropDelegate && [self.dropDelegate respondsToSelector:@selector(dropListView:selectedResult:selectedIndex:)]) {
        [self.dropDelegate dropListView:self selectedResult:self.datas[indexPath.row] selectedIndex:indexPath.row];
    }
    [self closeTableView];
}

- (void)dealloc{
    NSLog(@"DropList Dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
