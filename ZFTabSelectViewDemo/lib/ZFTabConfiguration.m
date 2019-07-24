//
//  ZFTabConfiguration.m
//  UiButtonAfterAction
//
//  Created by 张学飞 on 2019/6/18.
//  Copyright © 2019 lg_wd. All rights reserved.
//

#import "ZFTabConfiguration.h"

@implementation ZFTabConfiguration


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self defaultConfiguration];
    }
    return self;
}

- (void)defaultConfiguration
{
    
    self.btnWidth = 40;
    self.btnHeight = 40;
    self.betweenV = 10;
    self.betweenH = 10;
    self.leftSpace = 0;
    self.topSpace = 0;
    
    self.oneRowNum = 0; //表示一行
    
    self.btnTitleFont = [UIFont systemFontOfSize:14];
    
    self.isCanTouchAlways = NO;

}

@end
