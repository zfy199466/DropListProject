//
//  DropListVC.h
//  FoldListView
//
//  Created by lezhudai on 2018/5/31.
//  Copyright © 2018年 lezhudai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropListVC;

typedef enum : NSUInteger {
    PositionCenter,
    PositionLeft,
    PositionRight,
} ArrowPosition;

@interface DropConfig : NSObject
/** 字体 默认系统14.0 */
@property (nonatomic, strong) UIFont *titleFont;
/** 字体颜色 默认黑色 */
@property (nonatomic, strong) UIColor *titleTextColor;
/** cell的背景色 默认白色 */
@property (nonatomic, strong) UIColor *cellBackgroundColor;
/** tableview的背景色 默认白色 */
@property (nonatomic, strong) UIColor *tableViewBackgroundColor;
/** cell的高度 默认40 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 整个视图的高度 默认150 */
@property (nonatomic, assign) CGFloat FVHeight;
/** 是否要展示分割线 默认YES */
@property (nonatomic, assign) BOOL isShowSeparatorLine;
/** 分割线左侧间距 只有isShowSeparatorLine=YES生效，默认0 */
@property (nonatomic, assign) CGFloat separatorLeftInset;
/** 分割线右侧间距 只有isShowSeparatorLine=YES生效，默认0 */
@property (nonatomic, assign) CGFloat separatorRightInset;
/** 分割线颜色 只有isShowSeparatorLine=YES生效，默认grayColor */
@property (nonatomic, strong) UIColor *separatorColor;
/** 是否要自定义cell 默认NO */
@property (nonatomic, assign) BOOL customCell;
/** 背景色 */
@property (nonatomic, strong) UIColor *customBackgroundColor;
/** 展示列表是否需要圆角,默认显示 */
@property (nonatomic, assign) BOOL isShowCornerRadius;
/** 展示列表圆角的值，isShowCornerRadius=YES生效，默认5.0 */
@property (nonatomic, assign) CGFloat cornerRadiusNum;
/** 是否需要展示一个向上的三角形箭头，默认显示 */
@property (nonatomic, assign) BOOL isShowUpArrowView;
/** 三角箭头展示的位置,默认显示在中间 */
@property (nonatomic, assign) ArrowPosition arrowPosition;
/** 箭头居左的时候的左边间隙，默认为15 */
@property (nonatomic, assign) CGFloat arrowLeftMargin;
/** 箭头居右的时候的左边间隙，默认为15 */
@property (nonatomic, assign) CGFloat arrowRightMargin;
@end

@protocol DropListVCDelegate <NSObject>
@optional
/** 点击cell事件委托 */
- (void)dropListView:(DropListVC *)dropListVC selectedResult:(NSString *)result selectedIndex:(NSInteger)index;
@optional
/** 自定义cell的布局。如果defaultConfig.customCell = YES一定要实现此协议 */
- (UITableViewCell *)dropListViewCustomCell:(DropListVC *)dropListVC tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end

@interface DropListVC : UIViewController
/** 初始化对象类方法 */
+ (instancetype)dropListView;
/** 需要展示列表的相对控件（必传） */
@property (nonatomic, strong) UIView *orginView;
/** 展示的数据源数组 */
@property (nonatomic, strong) NSArray<NSString*> *datas;
/** 界面的一些属性配置 */
@property (nonatomic, strong) DropConfig *defaultConfig;
/** 委托协议 */
@property (nonatomic, weak) id<DropListVCDelegate> dropDelegate;
/** Flag标签 */
@property (nonatomic, assign) NSInteger flagTag;
/** 展示方法 */
- (void)showDropListWithViewController:(UIViewController *)vc;
@end
