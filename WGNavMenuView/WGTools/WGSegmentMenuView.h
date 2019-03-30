//
//  WGSegmentMenuView.h
//  WGNavMenuView
//
//  Created by wanggang on 2019/3/28.
//  Copyright © 2019 bozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WGSegmentMenuViewDelegate <NSObject>

@optional
- (void)selectItemWithIndex:(NSInteger)index;

@end

@interface WGSegmentMenuView : UIView

//数据源数组
@property (nonatomic, strong) NSArray *dataArr;
//更新标签标题数组
@property (nonatomic, strong) NSArray *changeTitleArr;

//未选中时:标签字体颜色
@property (nonatomic, strong) UIColor *titleColor_normal;

//选中时:标签字体颜色
@property (nonatomic, strong) UIColor *titleColor_selected;

//未选中时:标签字体大小
@property (nonatomic, assign) CGFloat titleFont_normal;

//选中时:标签字体大小
@property (nonatomic, assign) CGFloat titleFont_selected;

//滑动条颜色
@property (nonatomic, strong) UIColor *sliderColor;

//滑动条宽度
@property (nonatomic, assign) CGFloat sliderWidth;

//滑动条高度
@property (nonatomic, assign) CGFloat sliderHeight;

//segmentView背景色
@property (nonatomic, strong) UIColor *segmentViewBGColor;
//底部分界面高度
@property (nonatomic, assign) CGFloat bottomLineH;

@property (nonatomic, weak) id<WGSegmentMenuViewDelegate>wgSegmentMenuViewDelegate;

//初始化
-(instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr;

//外界滑动到某一部分
- (void)slidItemWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
