//
//  demoHitEventView.m
//  youmiqianbao
//
//  Created by mac on 2018/1/5.
//  Copyright © 2018年 ZhaoYongtai. All rights reserved.
//

#import "demoHitEventView.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@implementation demoHitEventView{
    WKWebView * _wkWebView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //return self.superview.subviews.firstObject;
    UIView * tview = [super hitTest:point withEvent:event];
    if (tview == self) {
        return [self.subviews firstObject];
    }
    return tview;
}

-(void)createUI{
    [self snowShow];
}

-(void)snowShow{
    self.emitterLayer.masksToBounds = YES;
    self.emitterLayer.emitterShape = kCAEmitterLayerLine;
    self.emitterLayer.emitterMode = kCAEmitterLayerSurface;
    self.emitterLayer.emitterSize = self.frame.size;
    self.emitterLayer.emitterPosition = CGPointMake(self.bounds.size.width / 2.f, -40);
}

- (void)show {
    //配置
    CAEmitterCell *snowFlake = [CAEmitterCell emitterCell];
    snowFlake.birthRate = 1.5f;//粒子产生率
    snowFlake.speed = 4.f;  //下落速度
    snowFlake.velocity = 1.f; //速度值
    snowFlake.velocityRange = 10.f;////速度值的微调值
    snowFlake.yAcceleration = 10.f;
    snowFlake.emissionRange = 0.5 * M_PI;
    snowFlake.spin = 0.0f; //旋转度
    snowFlake.spinRange = 0.25 * M_PI; //旋转容差
    snowFlake.contents = (__bridge id _Nullable)([UIImage imageNamed:@"ic_snow"].CGImage);
    snowFlake.color = [UIColor whiteColor].CGColor; //粒子颜色
    snowFlake.lifetime = 180.f;//粒子的生存时间
    snowFlake.scale = 0.5; //缩放大小
    snowFlake.scaleRange = 0.8;//缩放容差
    snowFlake.scaleSpeed = 0.0;//缩放速度
    
    //添加动画
    self.emitterLayer.emitterCells = @[snowFlake];
}
@end
