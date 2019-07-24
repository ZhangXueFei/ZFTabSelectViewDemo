//
//  ZFJumpTableView.h
//  UITableViewDemo
//
//  Created by lg_wd on 2018/6/1.
//  Copyright © 2018年 lg_wd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,ZFJumpStatueType)
{
    ZFJumpStatueDefault = 0 ,
    ZFJumpStatueViewController,
    ZFJumpStatueCustom
};

@interface ZFJumpTableView : UITableView

/****/
@property (nonatomic,weak) UIViewController *viewController;

/****/
@property (nonatomic,strong) NSArray * dataArray;

/****/
@property (nonatomic,assign) ZFJumpStatueType jumpType;

/****/
@property (nonatomic,copy)void (^didSelect)(id obj ,NSIndexPath *indexPath);

+ (ZFJumpTableView *)tableViewVC:(id)vc dataArray:(NSArray *)dataArray;
+ (ZFJumpTableView *)tableViewVC:(id)vc
                       dataArray:(NSArray *)dataArray
                        jumpType:(ZFJumpStatueType)jumpType;
@end
