//
//  ZFTabSelectView.m
//  FBSnapshotTestCase
//
//  Created by lg_wd on 2018/3/20.
//

#import "ZFTabSelectView.h"

@interface ZFTabSelectView ()<UIScrollViewDelegate>
/**上一个选中按钮 默认第一个*/
@property (nonatomic,weak) UIButton * laseSelectBtn;

/**按钮数组**/
@property (nonatomic,strong) NSMutableArray * buttonsArray;

/**选项卡宽度**/
@property (nonatomic,assign) CGFloat tabsBtnWith;

/**是否正在移动(拖拽移动)**/
@property (nonatomic,assign) BOOL isMovingByDecelerate;

/**按钮背景例子**/
@property (nonatomic,strong) UIButton * exampleBgButton;
/**按钮正常背景图片**/
@property (nonatomic,strong) UIImage  * buttonNormalImage;
/**按钮选择按钮图片**/
@property (nonatomic,strong) UIImage * buttonSelectImage;
/**正常标题颜色**/
@property (nonatomic,strong) UIColor * titleNormalColor;
/**选择标题颜色**/
@property (nonatomic,strong) UIColor * titleSelectColor;



/** 注释 是否加载过布局 **/
@property(nonatomic,assign) BOOL isSetupEnd;

@end
@implementation ZFTabSelectView
/*按钮tag*/
NSInteger const kButtonTag = 1000;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //一屏展示个数
        [self showDefaultValue];
        [self clearTabsData];
        [self initTabsViews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        //一屏展示个数
        [self showDefaultValue];
        [self clearTabsData];
        [self initTabsViews];
        
        [self creatButtonWithArray:titleArray];
    }
    return self;
}


-(void)showDefaultValue
{
    _showNumbers = 5;
    _allowTabsAlwaysTouch = NO;
    _animationSelectLine = NO;
    _animationType = kAnimationTypeNextButton;
    _defaultSelectFirst = YES;
}

#pragma mark - Init methods
-(void)initTabsViews
{
    //滚动视图
    self.tabsScrolView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:self.tabsScrolView];
    
    //底部灰色线条
    self.bottomLine.frame = CGRectMake(0, self.tabsScrolView.frame.size.height-1, self.frame.size.width, 1);
    [self.tabsScrolView addSubview:self.bottomLine];
    
    //蓝色线条
    self.selectedLine.bounds = CGRectMake(0, 0, 60, 2);
    [self.bottomLine addSubview:self.selectedLine];
}


#pragma mark -scrollViewDelegate回调
//拖拽
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (self.tabsScrolView == scrollView) {
        self.isMovingByDecelerate = YES;
    }
}
//拖拽结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.tabsScrolView == scrollView) {
        self.isMovingByDecelerate = NO;
    }
}

#pragma mark - Action methods
#pragma mark 选项卡点击事件
-(void)tabsBtnAction:(UIButton *)button
{
    //按钮下标
    NSInteger  btnTag = button.tag - kButtonTag;
    //切换按钮 ，连续点击同一个按钮是否继续响应事件
    BOOL isAllow = [self allowSwitchToTabsButton:button];
    if (!isAllow) { return;  }
    //给_currentSelectIndex赋值
    _currentSelectIndex = btnTag;
    //蓝线动画
    [self bottomSelectLineAnimation];
    //滚动
    [self scrollAnimationTypeAtIndex:btnTag];
    
    //绑定点击事件
    [self delegateRespondsDidSelectAtIndex:btnTag];
}

#pragma mark 按钮响应事件
-(void)tabsSetSelecteIndexAction:(UIButton *)button
{
    //按钮下标
    NSInteger  btnTag = button.tag - kButtonTag;
    //选项卡切换
    BOOL isAllow = [self allowSwitchToTabsButton:button];
    if (!isAllow) { return; }
    //给_currentSelectIndex赋值
    _currentSelectIndex = btnTag;
    //蓝线动画
    [self bottomSelectLineAnimation];
    //滚动
    [self scrollAnimationTypeAtIndex:btnTag];
    //绑定点击事件
    [self delegateRespondsDidSelectAtIndex:btnTag];
}

#pragma mark - Public methods
#pragma mark 响应按钮点击事件(didSelectAtIndex:)
-(void)delegateRespondsDidSelectAtIndex:(NSInteger)atIndex
{
    //绑定点击事件
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(tabView:didSelectAtIndex:)]) {
        [self.mDelegate tabView:self didSelectAtIndex:atIndex];
        return;
    }
    
    if (self.didSelectAtIndexBlock) {
        self.didSelectAtIndexBlock(self, atIndex);
    }
}

#pragma mark 是否允许按钮响应 (YES 可以响应点击事件，NO不可响应)
-(BOOL)allowSwitchToTabsButton:(UIButton *)button
{
    //视图正在滚动不允许响应
    if (self.isMovingByDecelerate) {
        return NO;
    }
    NSInteger index = button.tag - kButtonTag;
    //按钮下标  //是否允许响应事件
    if ([self.mDelegate respondsToSelector:@selector(tabView:shouldSelectAtIndex:)]) {
        if ([self.mDelegate tabView:self
                shouldSelectAtIndex:index] == NO) {
            return NO;
        }
    }
        //block
    if (self.shouldSelectAtIndexBlock &&
        (self.shouldSelectAtIndexBlock(self,index) == NO)) {
        return NO;
    }
    
    //是否允许连续点击
    //选项卡切换 allowTabsAlwaysTouch=NO && 连续点击同一个按钮 ,不允许实现效果
    if (!self.allowTabsAlwaysTouch && self.laseSelectBtn == button) {
        return NO;
    }else{ //改变按钮呢状态
        [self changeButtonState:button];
    }
    return YES;
}

#pragma mark 根据下标改变选项卡状态
-(void)changeSelectTabsStateIndex:(NSInteger)index
{
    if ([self isUnableSelectIndex:index]) {
        return;
    }
    UIButton * btn = self.buttonsArray[index];
    [self changeButtonState:btn];
}

#pragma mark 切换按钮状态,并记录点击按钮(laseSelectBtn)
-(void)changeButtonState:(UIButton *)button
{
    self.laseSelectBtn.selected = NO;
    button.selected = YES;
    self.laseSelectBtn = button;
}

#pragma mark - 选中按钮滚动效果分类

#pragma mark 滚动效果 type:类型; index:滚动到对应按钮的下标
-(void)scrollAnimationTypeAtIndex:(NSInteger)index
{
    if (self.animationType == kAnimationTypeCenter) {
        [self tabsSetScrollOffSetToCenter:index];
    }else if (self.animationType == kAnimationTypeNextButton){
        [self tabsNeedScrollOffsetOneBtnWidthWithIndex:index];
    }else{
        [self tabsNeedScrollOffsetOneBtnWidthWithIndex:index];
    }
}

-(void)invalidFrame
{
    NSInteger remainder = self.showNumbers % 2;
    if (remainder == 0) {  //默认展示偶数项
        
    }else{                  //默认展示奇数项
        
    }
}

#pragma mark  - 点击按钮选项卡动画类型 滚动到屏幕中间/向左向右滚动一个按钮的宽度
// 滚动到屏幕中心位置
-(void)tabsSetScrollOffSetToCenter:(NSInteger)index
{
    UIButton * button = self.buttonsArray[index];
    CGFloat needOffset = button.center.x - self.tabsScrolView.frame.size.width/2.0;
    //更正偏移量 防止过界
    needOffset = [self needToScrollOffset:needOffset];
    [self.tabsScrolView setContentOffset:CGPointMake(needOffset, self.tabsScrolView.contentOffset.y) animated:YES];
}

/*index点击的位置 从0开始*/
// 根据点击后向左/右滚动一个按钮的宽度
-(void)tabsNeedScrollOffsetOneBtnWidthWithIndex:(NSInteger)index
{
    if ([self isUnableSelectIndex:index]) {
        return;
    }
    
    UIButton * button = self.buttonsArray[index];
    //按钮在相对于滚动视图(FlowProductstabView)的位置大小
    CGRect tabFrame =[button convertRect:button.bounds toView:self];
    //按钮
    CGPoint tabCenter = CGPointMake(tabFrame.origin.x + tabFrame.size.width *0.5, self.frame.size.height *0.5);
    //无效区域（FlowProductstabView视图中心tabsBtnWith宽度的区域无效）
    CGRect invalidFrame = CGRectMake((self.frame.size.width - self.tabsBtnWith )*0.5 +1 , 0, self.tabsBtnWith -2, self.frame.size.height);
    if (CGRectContainsPoint(invalidFrame, tabCenter)) {
        return;
    }
    
    CGFloat scrolOffset_X = self.tabsScrolView.contentOffset.x;
    CGFloat needOffset= 0;
    
    if (tabCenter.x < self.frame.size.width *0.5) { //点击按钮在左边
        needOffset = scrolOffset_X - self.tabsBtnWith;
    }
    if (tabCenter.x > self.frame.size.width *0.5){ //点击按钮在右边
        needOffset = scrolOffset_X + self.tabsBtnWith;
    }
    //更正偏移量
    needOffset = [self needToScrollOffset:needOffset];
    [self.tabsScrolView setContentOffset:CGPointMake(needOffset, self.tabsScrolView.contentOffset.y) animated:YES];
}


#pragma mark - 底部蓝色横线动画
// 通过animationSelectLine控制动画,YES需要做动画;默认NO
-(void)bottomSelectLineAnimation
{
    [self selectLineAnimation:self.animationSelectLine];
}

// 横线动画
-(void)selectLineAnimation:(BOOL)animation
{
    CGFloat point_y = self.bottomLine.frame.size.height - self.selectedLine.frame.size.height *0.5;
    if (!animation) {
        self.selectedLine.center = CGPointMake(self.laseSelectBtn.center.x,point_y);
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedLine.center = CGPointMake(self.laseSelectBtn.center.x, point_y);
    }];
}


#pragma mark - Private methods
// 更正偏移量,防止设置tabsScrolView过界
-(CGFloat)needToScrollOffset:(CGFloat)needOffset
{
    //最大偏移量
    CGFloat maxOffset =  self.tabsScrolView.contentSize.width - self.tabsScrolView.frame.size.width;
    if (needOffset<=0) {
        needOffset = 0;
    }else if (needOffset > maxOffset){ //最大偏移量
        needOffset = maxOffset;
    };
    return needOffset;
}

#pragma mark 判断弄弄是否可用
//是否允许按钮响应 (YES 可以响应点击事件，NO不可响应)
/**(YES 可以响应点击事件，NO不可响应)
 button 当前点击的按钮
 isMoving：是否正在滚动
 allowTabsAlwaysTouch：是否允许连续点击
 */
-(BOOL)allowResponseTabsButton:(UIButton *)button
                      isMoving:(BOOL)isMoving
          allowTabsAlwaysTouch:(BOOL)allowTabsAlwaysTouch
{
    //视图正在滚动不允许响应
    if (isMoving) {
        return NO;
    }
    //按钮下标响应了不允许按钮点击代理事件
    if ([self.mDelegate respondsToSelector:@selector(tabView:shouldSelectAtIndex:)]) {
        BOOL allow = [self.mDelegate tabView:self shouldSelectAtIndex:button.tag - kButtonTag];
        if (allow == NO) {
            return NO;
        }
    }
    //是否设置了允许连续点击开关属性
    //不允许连续点击且两次点击同一个按钮，只响应一次
    if (!allowTabsAlwaysTouch && self.laseSelectBtn == button) {
        return NO;
    }
    return YES;
}

// 验证下标非有效性  /*输入的index 小于0 超过按钮个数 ，YES 不可用*/
-(BOOL)isUnableSelectIndex:(NSInteger)index
{
    if (index < 0 || index >= self.buttonsArray.count || self.buttonsArray.count == 0) {
        return YES;
    }
    return NO;
}

// 检查数组是否可用
-(BOOL)isUnsableArray:(NSArray *)array
{
    if ( array == nil || [array isKindOfClass:[NSNull class]] ||array.count <=0) {
        return YES;
    }
    return NO;
}


#pragma mark 设置选项卡位置不响应点击事件
//清除数据
-(void)clearTabsData
{
    _tabsSelecteIndex = 0;
    _currentSelectIndex =0;
    _tabsNotDoingSelecteIndex = 0;
    _isMovingByDecelerate = NO;
    self.selectedLine.center = CGPointMake(-self.selectedLine.frame.size.width - 20, self.selectedLine.center.y);
    //允许连续响应同一个选项卡点击事件，默认NO
}

#pragma mark 清除数据
-(void)clearAllTopTabs
{
    for (UIButton *btn  in self.buttonsArray) {
        [btn removeFromSuperview];
        [self.buttonsArray removeObject:btn];
    }
    [self clearTabsData];
}

#pragma mark 请除按钮样式
-(void)clearButtonStyle
{
    self.buttonNormalImage = nil;
    self.buttonSelectImage = nil;
    self.titleNormalColor = nil;
    self.titleSelectColor = nil;
}

#pragma mark - 选项卡功能修改

// 设置背景图片和字体颜色
-(void) setButtonNormalImage:(NSString *)norImageName
                 selectImage:(NSString *)selImageName
            normalTitleColor:(UIColor *)norColor
            selectTitleColor:(UIColor *)selectColor;
{
    //图片
    if (norImageName) {
        self.buttonNormalImage = [UIImage imageNamed:norImageName];
    }
    if (selImageName) {
        self.buttonSelectImage = [UIImage imageNamed:selImageName];
    }
    
    //文字
    self.titleNormalColor = norColor;
    self.titleSelectColor = selectColor;
    if (self.buttonsArray.count > 0) {
        for (UIButton * btn in self.buttonsArray) {
            [self changeTabsButtonImageAndColor:btn];
        }
    }
}

// 设置按钮图片和文字颜色
-(void)changeTabsButtonImageAndColor:(UIButton *)button
{
    if (self.buttonNormalImage) {
        [button setBackgroundImage:self.buttonNormalImage forState:UIControlStateNormal];
    }
    if (self.buttonSelectImage) {
        [button setBackgroundImage:self.buttonSelectImage forState:UIControlStateSelected];
    }
    if (self.titleNormalColor) {
        [button setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
    }
    if (self.titleSelectColor) {
        [button setTitleColor:self.titleSelectColor forState:UIControlStateSelected];
    }
}
#pragma mark - Set mothods

// 设置选项卡标题 (tabsTitleArray)
-(void)setTabsTitleArray:(NSArray *)tabsTitleArray
{
    _tabsTitleArray = tabsTitleArray;
    if ([self isUnsableArray:tabsTitleArray]) {
        return;
    }
    if (tabsTitleArray.count<5) {//（1-5）
        self.showNumbers = tabsTitleArray.count;
    }
    if (self.showNumbers != 1) {
        self.selectedLine.hidden = NO;
    }
    self.bottomLine.hidden = NO;
    [self creatButtonWithArray:tabsTitleArray];
}

// 设置选项卡位置并响应点击事件(tabsSelecteIndex)
-(void)setTabsSelecteIndex:(NSInteger)tabsSelecteIndex
{
    _tabsSelecteIndex = tabsSelecteIndex;
    
    if ([self isUnableSelectIndex:tabsSelecteIndex]) {
        _tabsSelecteIndex = _currentSelectIndex;
        return;
    }
    
    UIButton * btn = self.buttonsArray[tabsSelecteIndex];
    [self tabsSetSelecteIndexAction:btn];
}

// 选择展示的选项卡 （不响应点击事件）(tabsNotDoingSelecteIndex)
-(void)setTabsNotDoingSelecteIndex:(NSInteger)tabsNotDoingSelecteIndex
{
    _tabsNotDoingSelecteIndex = tabsNotDoingSelecteIndex;
    if ([self isUnableSelectIndex:tabsNotDoingSelecteIndex]) {
        _tabsNotDoingSelecteIndex = 0;
        return;
    }
    _currentSelectIndex = tabsNotDoingSelecteIndex;
    [self changeSelectTabsStateIndex:tabsNotDoingSelecteIndex];
    [self bottomSelectLineAnimation];
    [self tabsSetScrollOffSetToCenter:tabsNotDoingSelecteIndex];
}

// 点击按钮视图滚动类型
-(void)setAnimationType:(NSInteger)animationType
{
    _animationType = animationType;
}



#pragma mark 初始化界面
#pragma mark 创建按钮按钮with array
-(void)creatButtonWithArray:(NSArray *)tabsArray
{
    if ([self isUnsableArray:tabsArray]) {
        return;
    }
    [self.buttonsArray removeAllObjects];
    
    CGFloat btnHeight = self.tabsScrolView.frame.size.height;
    CGFloat btnWidth = self.frame.size.width / (CGFloat)self.showNumbers;
    self.tabsBtnWith = btnWidth;
    NSString * title;
    for (NSInteger i = 0; i < tabsArray.count; i ++) {
        title = tabsArray[i];
        UIButton * btn = [self creatBtnWithTitle:title];
        btn.exclusiveTouch = YES; //避免屏幕内多个button被同时点击
        btn.tag = kButtonTag + i;
        btn.bounds = CGRectMake(0, 0, btnWidth, btnHeight);
        btn.center = CGPointMake(btnWidth *i + btnWidth * 0.5, self.tabsScrolView.frame.size.height * 0.5);
        [self.tabsScrolView addSubview:btn];
        [self changeTabsButtonImageAndColor:btn];
        [self.buttonsArray addObject:btn];
        if (i == self.currentSelectIndex && self.defaultSelectFirst) {
             btn.selected = YES;
            self.laseSelectBtn = btn;
            [self selectLineAnimation:NO];
        }
    }
    //tabsScrolView.contentSize
    self.tabsScrolView.contentSize = CGSizeMake(btnWidth * tabsArray.count,0);
    CGRect lineRect = self.bottomLine.frame;
    lineRect.size.width = MAX(self.tabsScrolView.contentSize.width, self.frame.size.width);
    self.bottomLine.frame = lineRect;
    [self.tabsScrolView bringSubviewToFront:self.bottomLine];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (CGRectIsEmpty(self.frame) || self.buttonsArray.count <= 0 || self.isSetupEnd) {
        return;
    }
    
    
    self.tabsScrolView.frame = self.bounds;
    
    CGFloat btnHeight = self.tabsScrolView.frame.size.height;
    CGFloat btnWidth = self.frame.size.width / (CGFloat)self.showNumbers;
    self.tabsBtnWith = btnWidth;
  
    for (NSInteger i = 0; i < self.buttonsArray.count; i ++) {
        UIButton * btn = self.buttonsArray[i];
        btn.bounds = CGRectMake(0, 0, btnWidth, btnHeight);
        btn.center = CGPointMake(btnWidth *i + btnWidth * 0.5, self.tabsScrolView.frame.size.height * 0.5);
        if (i == self.currentSelectIndex && self.defaultSelectFirst) {
           
            [self selectLineAnimation:NO];

        }
    }
    //tabsScrolView.contentSize
    self.tabsScrolView.contentSize = CGSizeMake(btnWidth * self.buttonsArray.count,0);
    CGRect lineRect = self.bottomLine.frame;
    lineRect.size.width = MAX(self.tabsScrolView.contentSize.width, self.frame.size.width);
    self.bottomLine.frame = lineRect;
    
    self.isSetupEnd = YES;
}




// 创建按钮按钮
-(UIButton *)creatBtnWithTitle:(NSString *)title
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.titleLabel.adjustsFontSizeToFitWidth = 6;
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    [btn addTarget:self action:@selector(tabsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - 懒加载
-(UIScrollView *)tabsScrolView
{
    if (_tabsScrolView == nil) {
        _tabsScrolView = [[UIScrollView alloc] init];
        _tabsScrolView.delegate = self;
        _tabsScrolView.bounces = NO;
        _tabsScrolView.showsHorizontalScrollIndicator = NO;
        _tabsScrolView.showsVerticalScrollIndicator = NO;
    }
    return _tabsScrolView;
}
// 选项卡按钮数组
-(NSMutableArray *)buttonsArray
{
    if (_buttonsArray == nil) {
        _buttonsArray = [[NSMutableArray alloc] init];
    }
    return _buttonsArray;
}
-(UIImageView *)bottomLine
{
    if (_bottomLine == nil) {
        _bottomLine = [[UIImageView alloc] init];
        _bottomLine.backgroundColor = [UIColor lightGrayColor];
        _bottomLine.hidden = YES;
    }
    return _bottomLine;
}
-(UIImageView *)selectedLine
{
    if (_selectedLine == nil) {
        _selectedLine = [[UIImageView alloc]init];
        _selectedLine.hidden = YES;
        _selectedLine.backgroundColor = [UIColor blueColor];
    }
    return _selectedLine;
}
//按钮背景图
-(UIButton *)exampleBgButton
{
    if (_exampleBgButton == nil) {
        _exampleBgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _exampleBgButton;
}
@end
