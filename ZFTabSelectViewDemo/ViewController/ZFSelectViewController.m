



//
//  ZFSelectViewController.m
//  ZFTabSelectViewDemo
//
//  Created by 张学飞 on 2019/6/19.
//  Copyright © 2019 zxf. All rights reserved.
//

#import "ZFSelectViewController.h"
#import "ZFJumpTableView.h"
#import "ZFTabSelectView.h"

@interface ZFSelectViewController ()
/**/
@property(nonatomic,strong) ZFTabSelectView *selectView;
@end

@implementation ZFSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSArray *dataArr =  @[@{@"title":@"测试 ",@"value":@"kTabSelectAnimationTypeDefault"},
                          @{@"title":@"测试 ",@"value":@"kAnimationTypeNextButton"},
                          @{@"title":@"测试 ",@"value":@"kAnimationTypeNextButton"},
                          @{@"title":@"测试 ",@"value":@"kAnimationTypeNextButton"},
                          @{@"title":@"测试 ",@"value":@"kAnimationTypeNextButton"},
                          
                          ];
    
    
    ZFJumpTableView *tab = [ZFJumpTableView tableViewVC:self dataArray:dataArr];
    tab.viewController = self;
        tab.jumpType = ZFJumpStatueCustom;
    tab.frame = CGRectMake(0,  88, CGRectGetWidth(self.view.frame), 200);
    [tab reloadData];
    [self.view addSubview:tab];
    tab.didSelect = ^(id obj, NSIndexPath *indexPath) {
        self.selectView.animationType = (NSInteger)indexPath.row + kTabSelectAnimationTypeDefault;
    };
    

    
    ZFTabSelectView *tabSelectView = [[ZFTabSelectView alloc] init];
    tabSelectView.layer.borderColor = [UIColor redColor].CGColor;
    tabSelectView.layer.borderWidth = 2;
    tabSelectView.tabsTitleArray = @[@"张三",@"旺旺罗",@"张三等待",@"张等待三",@"张三",@"张三等待",@"张三",@"旺旺罗",@"张三等待",@"张等待三",@"张三",@"张三等待",@"张三"];
    self.selectView = tabSelectView;
    [self.view addSubview:tabSelectView];
    tabSelectView.frame = CGRectMake(10, CGRectGetMaxY(tab.frame) + 100, self.view.frame.size.width - 20, 50);
    
    
    
    [self setupUI];
    
}

- (void)setupUI
{
    NSMutableArray * arr = [NSMutableArray array];
    for (NSInteger i = 0 ; i < 10 ; i ++) {
        [arr addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    ZFTabSelectView * tab1 = [self tabSelectView:arr topView:self.selectView];
    tab1.defaultSelectFirst = NO;
    tab1.didSelectAtIndexBlock = ^(ZFTabSelectView *view, NSInteger index) {
        self.selectView.tabsSelecteIndex = index;
    };
//    indexSelct.tabsSelecteIndex = 2;

}


//创建布局
- (ZFTabSelectView *)tabSelectView:(NSArray *)dataArr topView:(UIView *)topView
{
    ZFTabSelectView *tabSelectView = [[ZFTabSelectView alloc] init];
    tabSelectView.layer.borderColor = [UIColor redColor].CGColor;
    tabSelectView.layer.borderWidth = 2;
       tabSelectView.defaultSelectFirst = NO;
    tabSelectView.tabsTitleArray = dataArr;

    [self.view addSubview:tabSelectView];
    tabSelectView.frame = CGRectMake(10, CGRectGetMaxY(topView.frame) + 30, self.view.frame.size.width - 20, 50);
    
    return tabSelectView;

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
