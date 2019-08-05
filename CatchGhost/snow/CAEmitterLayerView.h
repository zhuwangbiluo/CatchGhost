//
//  CAEmitterLayerView.h
//  youmiqianbao
//
//  Created by mac on 2018/1/5.
//  Copyright © 2018年 ZhaoYongtai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAEmitterLayerView : UIView
//模仿setter，getter方法
- (void)setEmitterLayer:(CAEmitterLayer *)layer;
- (CAEmitterLayer *)emitterLayer;

//显示出当前view
- (void)show;
//隐藏
- (void)hide;
@end
