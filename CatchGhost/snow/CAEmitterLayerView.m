//
//  CAEmitterLayerView.m
//  youmiqianbao
//
//  Created by mac on 2018/1/5.
//  Copyright © 2018年 ZhaoYongtai. All rights reserved.
//

#import "CAEmitterLayerView.h"
@interface CAEmitterLayerView() {
    CAEmitterLayer *_emitterLayer;
}

@end
@implementation CAEmitterLayerView

+(Class)layerClass {
    return [CAEmitterLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _emitterLayer = (CAEmitterLayer *)self.layer;
    }
    return self;
}

- (void)setEmitterLayer:(CAEmitterLayer *)layer {
    _emitterLayer = layer;
}

- (CAEmitterLayer *)emitterLayer {
    return _emitterLayer;
}

- (void)show {
    
}

- (void)hide {
    
}


@end
