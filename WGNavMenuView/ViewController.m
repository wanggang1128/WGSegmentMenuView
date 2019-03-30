//
//  ViewController.m
//  WGNavMenuView
//
//  Created by wanggang on 2019/3/27.
//  Copyright © 2019 bozhong. All rights reserved.
//

#import "ViewController.h"
#import "WGTools/WGSegmentMenuView.h"

@interface ViewController ()<WGSegmentMenuViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) WGSegmentMenuView * taggedNavView;
@property (nonatomic, strong) UIScrollView * bgScroll;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ViewController";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *titleArr = @[@"精选",@"2018世界杯",@"明日之子",@"电影",@"电视剧",@"NBA",@"花样年华"];
    self.taggedNavView = [[WGSegmentMenuView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 44) titleArr:titleArr];
    self.taggedNavView.wgSegmentMenuViewDelegate = self;
    self.taggedNavView.segmentViewBGColor = [UIColor whiteColor];
    self.taggedNavView.titleColor_normal = [UIColor blueColor];
    self.taggedNavView.titleColor_selected = [UIColor redColor];
    self.taggedNavView.titleFont_normal = 10;
    self.taggedNavView.titleFont_selected = 22;
    self.taggedNavView.sliderHeight = 20;
    self.taggedNavView.sliderColor = [UIColor greenColor];
    [self.view addSubview:self.taggedNavView];
    
    self.bgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 200)];
    self.bgScroll.contentSize = CGSizeMake(self.view.frame.size.width*7, 0);
    self.bgScroll.delegate = self;
    self.bgScroll.pagingEnabled = YES;
    [self.view addSubview:self.bgScroll];
    
    for (int i = 0; i<titleArr.count; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, self.bgScroll.frame.size.height)];
        label.backgroundColor = [UIColor yellowColor];
        label.text = [NSString stringWithFormat:@"%d\n%@",i,titleArr[i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [_bgScroll addSubview:label];
    }
}

-(void)selectItemWithIndex:(NSInteger)index{
    
    self.bgScroll.contentOffset = CGPointMake(self.view.frame.size.width*index, 0);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger selectedIndx = scrollView.contentOffset.x/self.view.frame.size.width;
    [self.taggedNavView slidItemWithIndex:selectedIndx];
}

@end
