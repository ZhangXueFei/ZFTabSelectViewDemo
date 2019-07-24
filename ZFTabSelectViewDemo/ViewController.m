//
//  ViewController.m
//  ZFTabSelectViewDemo
//
//  Created by 张学飞 on 2019/6/19.
//  Copyright © 2019 zxf. All rights reserved.
//

#import "ViewController.h"
#import "ZFTabSelectView.h"
#import "ZFJumpTableView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"ZFTabSelectView";
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *dataArr =  @[@{@"title":@"selectView",@"value":@"ZFSelectViewController"},
                          @{@"title":@"selectView",@"value":@"ZFSelectViewController"},
                          @{@"title":@"selectView",@"value":@"ZFSelectViewController"},
                          @{@"title":@"selectView",@"value":@"ZFSelectViewController"},
                          ];

    
    
    
    ZFJumpTableView *tab = [ZFJumpTableView tableViewVC:self dataArray:dataArr];
    tab.viewController = self;
//    tab.jumpType = ZFJumpStatueCustom;
    tab.frame = CGRectMake(0,  88, CGRectGetWidth(self.view.frame), 200);
    [tab reloadData];
    [self.view addSubview:tab];
    tab.didSelect = ^(id obj, NSIndexPath *indexPath) {
//        selectView.animationType = (NSInteger)indexPath.row;
    };
    
    
    

}

-(void)tabView:(ZFTabSelectView *)tabView didSelectAtIndex:(NSInteger)index
{
    
}

-(BOOL)tabView:(ZFTabSelectView *)tabView shouldSelectAtIndex:(NSInteger)index
{
    return YES;
}@end
