//
//  EndViewController.m
//  CatchGhost
//
//  Created by yiner on 2017/11/16.
//  Copyright © 2017年 yiner. All rights reserved.
//

#import "EndViewController.h"
#import <Masonry/Masonry.h>

@interface EndViewController ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, assign) BOOL isSelected;
@end

#define BUTTON_WIDTH ([[UIScreen mainScreen] bounds].size.width - 40)/3

@implementation EndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记住自己的词开始撕逼吧";
    self.isSelected = YES;
    [self.view addSubview:self.bgImg];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.bgView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"裁判" style:UIBarButtonItemStyleDone target:self action:@selector(anwser:)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self configureUI];
}

- (void)configureUI
{
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(70);
        make.left.right.equalTo(self.view);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)setSortedArray:(NSMutableArray *)sortedArray
{
    NSInteger i = sortedArray.count;
    while (--i > 0) {
        int j = arc4random()%(i+1);
        [sortedArray exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    
    _sortedArray = sortedArray;
    
    for (int i = 0; i<sortedArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.enabled = i == 0;
        button.tag = 101+i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.titleLabel.numberOfLines = 0;
        button.frame = CGRectMake((i%3)*BUTTON_WIDTH + (i%3+1)*10, (i/3)*50+(i/3+1)*30, BUTTON_WIDTH, 50);
        button.backgroundColor = [UIColor blackColor];
        [button setTitle:[NSString stringWithFormat:@"%i",i+1] forState:UIControlStateNormal];
        [button setTitle:sortedArray[i] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:button];
    }
}

- (void)selectButton:(UIButton *)sender
{
    if (sender.enabled && !sender.selected) {
        sender.selected = !sender.selected;
    }
    else {
        sender.enabled = NO;
        sender.selected = !sender.selected;
        [sender setTitle:[NSString stringWithFormat:@"%li",sender.tag - 100] forState:UIControlStateNormal];
        sender.backgroundColor = [UIColor grayColor];
        
        UIButton *button = (UIButton *)[self.bgView viewWithTag:sender.tag + 1];
        button.enabled = YES;
    }
}

- (void)anwser:(id)sender
{
//    for (UIView *view in self.bgView.subviews) {
//        if ([view isKindOfClass:[UIButton class]]) {
//            UIButton *btn = (UIButton *)view;
//            if (![btn.titleLabel.text isEqualToString:@"不能翻喽"] && !btn.enabled) {
//
//                return;
//            }
//        }
//    }
    
    UIButton *btn = (UIButton *)[self.bgView viewWithTag:100 + self.sortedArray.count - 1];
    if (btn.backgroundColor != [UIColor grayColor]) {
        return;
    }
    
    [self.bgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = (UIButton *)obj;
        btn.enabled = YES;
        btn.selected = self.isSelected;
    }];
    self.isSelected = !self.isSelected;
}

#pragma mark - set & get -
- (UIImageView *)bgImg
{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"corekit_rootViewBg"]];
    }
    return _bgImg;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"要按顺序查看，不然点坏屏幕别怪我。。。看完记得翻过来🚩🚩";
        _tipLabel.numberOfLines = 0;
        _tipLabel.textColor = [UIColor blackColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:13];
    }
    return _tipLabel;
}

@end
