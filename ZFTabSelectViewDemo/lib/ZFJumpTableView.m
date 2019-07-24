//
//  ZFJumpTableView.m
//  UITableViewDemo
//
//  Created by lg_wd on 2018/6/1.
//  Copyright © 2018年 lg_wd. All rights reserved.
//

#import "ZFJumpTableView.h"

@interface ZFJumpTableView ()<UITableViewDelegate,UITableViewDataSource>
/****/
@property (nonatomic,strong) NSMutableArray * dataSourceArray;

@end

@implementation ZFJumpTableView

+ (ZFJumpTableView *)tableViewVC:(id)vc dataArray:(NSArray *)dataArray
{
    ZFJumpTableView *table = [ZFJumpTableView tableViewVC:vc
                                                dataArray:dataArray
                                                 jumpType:ZFJumpStatueViewController];
    return table;
}
+ (ZFJumpTableView *)tableViewVC:(id)vc
                       dataArray:(NSArray *)dataArray
                        jumpType:(ZFJumpStatueType)jumpType
{
    ZFJumpTableView *table = [[ZFJumpTableView alloc]initWithFrame:CGRectZero];
    table.viewController = vc;
    table.jumpType = jumpType;
    if (dataArray) {
        table.dataArray = dataArray;
    }
    return table;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.rowHeight = 44.0;
    }
    return self;
}


- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.dataSourceArray removeAllObjects];
    if (dataArray) {
        [self.dataSourceArray setArray:dataArray];
    }
    [self reloadData];
}

#pragma mark - Delegate回调
#pragma mark -tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    }
    
    [self stringCellForRow:self.dataSourceArray[indexPath.row] cell:cell];
    return cell;
}

- (void)stringCellForRow:(id)obj cell:(UITableViewCell *)cell
{
    if ([obj isKindOfClass:[NSString class]]) {
        cell.textLabel.text = (NSString *)obj;
        
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        NSDictionary * dic = (NSDictionary *)obj;
        cell.textLabel.text =  dic[@"title"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",dic[@"value"]];
    
    }else{
        cell.textLabel.text =  [NSString stringWithFormat:@"%@",obj];
    }
}

//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = self.dataSourceArray[indexPath.row];
    if (self.jumpType == ZFJumpStatueViewController && self.viewController) {
        [self jumpViewController:self.viewController obj:obj];
        return;
    }
    
    else if (self.didSelect) {
        self.didSelect(self.dataSourceArray[indexPath.row], indexPath);
    }
}

#pragma mark 控制器跳转
- (void)jumpViewController:(UIViewController *)supVC obj:(id)obj
{
    NSString * classStr = @"";
    if ([obj isKindOfClass:[NSString class]]) {
        classStr = (NSString *)obj;
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        NSDictionary * dic = (NSDictionary *)obj;
        classStr = dic[@"value"];
    }
    Class  class =  NSClassFromString(classStr);
    if (class) {
        UIViewController * vc = [(UIViewController *)[class alloc] init];
        if (supVC.navigationController) {
            [supVC.navigationController pushViewController:vc animated:YES];
        }else{
            [supVC presentViewController:vc animated:YES completion:nil];
        }
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
