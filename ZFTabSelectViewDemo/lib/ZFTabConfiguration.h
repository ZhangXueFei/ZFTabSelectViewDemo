//
//  ZFTabConfiguration.h
//  UiButtonAfterAction
//
//  Created by 张学飞 on 2019/6/18.
//  Copyright © 2019 lg_wd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZFTabConfiguration : NSObject


@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineH;
@property (nonatomic, assign) CGFloat lineW;

@property (nonatomic, assign) CGFloat btnHeight;
@property (nonatomic, assign) CGFloat btnWidth;

@property (nonatomic, assign) CGFloat betweenH;
@property (nonatomic, assign) CGFloat betweenV;

@property (nonatomic, assign) CGFloat leftSpace;
/**  **/
@property(nonatomic,assign) CGFloat topSpace;

/** 一行展示个数 **/
@property(nonatomic,assign) NSInteger oneRowNum;

@property (nonatomic, strong) UIColor *btnColor;
@property (nonatomic, strong) UIColor *btnSeletedColor;
@property (nonatomic, strong) UIColor *btnTitleColor;
@property (nonatomic, strong) UIFont *btnTitleFont;

/**限制一直可点击 **/
@property(nonatomic,assign) BOOL isCanTouchAlways;
@property(nonatomic,assign) BOOL isChangeLastButton; //是否改变上次按钮样式


@end

