//
//  WGSegmentMenuView.m
//  WGNavMenuView
//
//  Created by wanggang on 2019/3/28.
//  Copyright © 2019 bozhong. All rights reserved.
//

#import "WGSegmentMenuView.h"

//最小Item之间的间距
#define MinItemSpace 20.f
//WGSegmentMenuView高度
#define SegmentViewH  _bottomLineView.hidden?(_size.height):(_size.height-_bottomLineH)
#define DefaultTitleColor_normal [UIColor blackColor]
#define DefaultTitleColor_selected [UIColor blueColor]
#define DefaultTiteFont_normal 15
#define DefaultTitleFont_selected 22
#define DefaultSliderColor [UIColor blueColor]
#define DefaultSliderH 1
#define DefaultSliderW 30

@interface WGSegmentMenuView()

//WGSagmentMenuView的大小
@property (nonatomic, assign) CGSize size;
//标题Btn数组
@property (nonatomic, strong) NSMutableArray *titleBtnArr;
//按钮title到边的间距
@property (nonatomic, assign) CGFloat buttonSpace;
/** 存放按钮的宽度 */
@property (nonatomic, strong) NSMutableArray *widthBtnArr;
/** segmentView头部标题视图 */
@property (nonatomic, strong) UIScrollView *segmentView;
/** 指示杆 */
@property (nonatomic, strong) UIView *sliderView;
/** 分割线View */
@property (nonatomic, strong) UIView *spaceView;
/** 当前被选中的按钮 */
@property (nonatomic, strong) UIButton *selectedButton;
/** 底部分割线 */
@property (nonatomic, strong) UIView *bottomLineView;
@end

@implementation WGSegmentMenuView

//初始化
-(instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr{
    self = [super initWithFrame:frame];
    if (self) {
        
        _dataArr = titleArr;
        _size = frame.size;
        _titleColor_normal = DefaultTitleColor_normal;
        _titleColor_selected = DefaultTitleColor_selected;
        _titleFont_normal = DefaultTiteFont_normal;
        _titleFont_selected = DefaultTitleFont_selected;
        _sliderColor = DefaultSliderColor;
        _sliderWidth = DefaultSliderW;
        _sliderHeight = DefaultSliderH;
        _segmentViewBGColor = [UIColor whiteColor];
        _bottomLineH = 3;
        
        
        _buttonSpace = [self calculateSpace];
        [self buildView];
        
    }
    return self;
}

- (void)buildView{
    
    [self addSubview:self.segmentTitleView];
    [self addSubview:self.bottomLineView];

    CGFloat item_x = 0;
    NSString *title;
    for (NSInteger i=0; i<_dataArr.count; i++) {
        title = _dataArr[i];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:_titleFont_selected]}];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(item_x, 0, _buttonSpace*2+titleSize.width, SegmentViewH-_sliderHeight);
        button.tag = i;
        //设置标题
        [button setTitle:title forState:UIControlStateNormal];
        //默认字体颜色
        [button setTitleColor:_titleColor_normal forState:UIControlStateNormal];
        //选中字体颜色
        [button setTitleColor:_titleColor_selected forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_segmentView addSubview:button];
        //存放按钮
        [self.titleBtnArr addObject:button];
        //存放按钮的宽度
        [self.widthBtnArr addObject:[NSNumber numberWithFloat:CGRectGetWidth(button.frame)]];
        //递增宽度
        item_x += _buttonSpace * 2 + titleSize.width;
        if (i == 0) {
            //第一个,默认选中
            button.selected = YES;
            _selectedButton = button;
            _selectedButton.titleLabel.font = [UIFont boldSystemFontOfSize:_titleFont_selected];
            self.sliderView.frame = CGRectMake(_buttonSpace, SegmentViewH-_sliderHeight, titleSize.width, _sliderHeight);
            [_segmentView addSubview:_sliderView];
        }else{
            button.titleLabel.font = [UIFont boldSystemFontOfSize:_titleFont_normal];
        }
    }
    _segmentView.contentSize = CGSizeMake(item_x, SegmentViewH);
}

- (void)buttonClicked:(UIButton *)sender{
    
    if (sender != _selectedButton) {
        //更新状态
        _selectedButton.selected = !_selectedButton.selected;
        _selectedButton.titleLabel.font = [UIFont boldSystemFontOfSize:_titleFont_normal];
        sender.selected = YES;
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:_titleFont_selected];
        _selectedButton = sender;
        
        [self scrollSegementView];
        [self scrollSliderView];
    }
    if (self.wgSegmentMenuViewDelegate && [self.wgSegmentMenuViewDelegate respondsToSelector:@selector(selectItemWithIndex:)]) {
        [self.wgSegmentMenuViewDelegate selectItemWithIndex:_selectedButton.tag];
    }
}

//根据选中调整segementView的offset
- (void)scrollSegementView{
    
    CGFloat selectedWidth = _selectedButton.frame.size.width;
    CGFloat offsetX = (_size.width - selectedWidth) / 2;
    
    if (_selectedButton.frame.origin.x <= _size.width / 2) {
        [_segmentView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (CGRectGetMaxX(_selectedButton.frame) >= (_segmentView.contentSize.width - _size.width / 2)) {
        [_segmentView setContentOffset:CGPointMake(_segmentView.contentSize.width - _size.width, 0) animated:YES];
    } else {
        [_segmentView setContentOffset:CGPointMake(CGRectGetMinX(_selectedButton.frame) - offsetX, 0) animated:YES];
    }
}

//根据选中的按钮滑动滚动条
- (void)scrollSliderView{
    
    CGSize titleSize = [_selectedButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:_titleFont_selected]}];
    __weak __typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        weakSelf.sliderView.frame = CGRectMake(CGRectGetMinX(weakSelf.selectedButton.frame)+weakSelf.buttonSpace, CGRectGetMinY(weakSelf.sliderView.frame), titleSize.width, weakSelf.sliderHeight);
        
    } completion:^(BOOL finished) {
        
    }];
}

//外界滑动到某一部分
- (void)slidItemWithIndex:(NSInteger)index{
    
    UIButton *sender = self.titleBtnArr[index];
    if (sender != _selectedButton) {
        //更新状态
        _selectedButton.selected = !_selectedButton.selected;
        _selectedButton.titleLabel.font = [UIFont boldSystemFontOfSize:_titleFont_normal];
        sender.selected = YES;
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:_titleFont_selected];
        _selectedButton = sender;
        
        [self scrollSegementView];
        [self scrollSliderView];
    }
}

//需要移动的距离
- (CGFloat)widthAtIndex:(NSInteger)index {
    if (index < 0 || index > _dataArr.count - 1) {
        return .0;
    }
    return [[_widthBtnArr objectAtIndex:index] doubleValue];
}

/** 按钮title到边的间距 */
- (CGFloat)calculateSpace {
    CGFloat space = 0.f;
    CGFloat totalWidth = 0.f;
    
    for (NSString *title in _dataArr) {
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:_titleFont_selected]}];
        totalWidth += titleSize.width;
    }
    
    space = (_size.width - totalWidth) / _dataArr.count / 2;
    if (space > MinItemSpace / 2) {
        return space;
    } else {
        return MinItemSpace / 2;
    }
}

#pragma mark -set方法
-(void)setTitleColor_selected:(UIColor *)titleColor_selected{
    
    _titleColor_selected = titleColor_selected;
    for (UIButton *btn in self.titleBtnArr) {
        [btn setTitleColor:_titleColor_selected forState:UIControlStateSelected];
    }
}

-(void)setTitleColor_normal:(UIColor *)titleColor_normal{
    
    _titleColor_normal = titleColor_normal;
    for (UIButton *btn in self.titleBtnArr) {
        [btn setTitleColor:_titleColor_normal forState:UIControlStateNormal];
    }
}

-(void)setTitleFont_selected:(CGFloat)titleFont_selected{
    
    _titleFont_selected = titleFont_selected;
    for (UIButton *btn in self.titleBtnArr) {
        if (btn.selected) {
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:_titleFont_selected];
        }
    }
}

-(void)setTitleFont_normal:(CGFloat)titleFont_normal{
    
    _titleFont_normal = titleFont_normal;
    for (UIButton *btn in self.titleBtnArr) {
        if (!btn.selected) {
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:_titleFont_normal];
        }
    }
}

-(void)setSegmentViewBGColor:(UIColor *)segmentViewBGColor{
    _segmentViewBGColor = segmentViewBGColor;
    _segmentView.backgroundColor = _segmentViewBGColor;
}

-(void)setSliderColor:(UIColor *)sliderColor{
    
    _sliderColor = sliderColor;
    _sliderView.backgroundColor = _sliderColor;
}

#pragma mark -懒加载
-(UIScrollView *)segmentTitleView{
    if (!_segmentView) {
        _segmentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _size.width, SegmentViewH)];
        _segmentView.backgroundColor = _segmentViewBGColor;
        _segmentView.showsVerticalScrollIndicator = NO;
        _segmentView.showsHorizontalScrollIndicator = NO;
    }
    return _segmentView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, SegmentViewH, _size.width, _bottomLineH)];
        _bottomLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _bottomLineView;
}

- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[UIView alloc] init];
        _sliderView.backgroundColor = _sliderColor;
        _sliderView.layer.cornerRadius = _sliderHeight/2;
        _sliderView.layer.masksToBounds = YES;
    }
    return _sliderView;
}

-(NSMutableArray *)titleBtnArr{
    if (!_titleBtnArr) {
        _titleBtnArr = [[NSMutableArray alloc] init];
    }
    return _titleBtnArr;
}

-(NSMutableArray *)widthBtnArr{
    if (!_widthBtnArr) {
        _widthBtnArr = [[NSMutableArray alloc] init];
    }
    return _widthBtnArr;
}

@end
