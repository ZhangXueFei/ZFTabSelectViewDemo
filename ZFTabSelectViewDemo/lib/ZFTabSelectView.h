//
//  ZFTabSelectView.h
//  FBSnapshotTestCase
//
//  Created by lg_wd on 2018/3/20.
//

#import <UIKit/UIKit.h>
/*移动类型*/

typedef NS_ENUM(NSInteger , ZFTabSelectAnimationType) {
    
    kTabSelectAnimationTypeDefault = 1000,
    kAnimationTypeNextButton = 1001, //点击一次跳入下一个
    kAnimationTypeCenter = 1002,   //点击某一个，这个按钮跳到屏幕中间位置
    
    kTabSelectAnimationTypeNextButton , //点击一次跳入下一个
    kTabSelectAnimationTypeCenter ,   //点击某一个，这个按钮跳到屏幕中间位置
    kTabSelectAnimationTypeNone  //  点击按钮后，只响应代理事件，不会跳到下一个按钮也没有动画效果,需要手动设置
    
};

//展示类型
typedef NS_ENUM(NSInteger , ZFTabSelectViewShowType)
{
    kTabSelectViewShowDefault = 0, //默认展示类型
    kTabSelectViewShowHalfButtonType,   //如果默人个数能够一屏展示，则全部展示，如果展示不下，下一个按钮展示一半
    kTabSelectViewShowEqualWidthType, //每个按钮都是相等宽度
    kTabSelectViewShowTitleAdaptationType, //标题自适应大小，间距使用默认值，可修改
};



@class ZFTabSelectView;
@protocol ZFTabSelectViewDelegate <NSObject>
@optional
/*选项卡点击事件*/
-(void)tabView:(ZFTabSelectView *)topTabs didSelectAtIndex:(NSInteger)index;

/*选项卡是否需要点击 默认yes*/
-(BOOL)tabView:(ZFTabSelectView *)topTabs shouldSelectAtIndex:(NSInteger)index;


@end

//block 点击了某一个按钮
typedef void(^ZFDidSelectAtIndexBlock)(ZFTabSelectView * view ,NSInteger index);
//是否可以点击
typedef BOOL(^ZFShouldSelectAtIndexBlock)(ZFTabSelectView * view ,NSInteger index);


@interface ZFTabSelectView : UIView

@property(nonatomic,copy) ZFDidSelectAtIndexBlock  didSelectAtIndexBlock;//
@property(nonatomic,copy) ZFShouldSelectAtIndexBlock  shouldSelectAtIndexBlock;//

@property (nonatomic,weak)id <ZFTabSelectViewDelegate>mDelegate;

/*UIScrollView*/
@property (nonatomic,strong)UIScrollView * tabsScrolView;

/*底部灰色线*
 * bottomLine.alpha = 0.0;设置隐藏底部灰线
 */
@property (nonatomic,strong)UIImageView * bottomLine;

/**选择的线条**/
@property (nonatomic,strong)UIImageView * selectedLine;

/**选项卡数组**/
@property (nonatomic,strong) NSArray * tabsTitleArray;

#pragma mark  选项卡属性
/* 只读属性*当前选中选项卡，默认0**/
@property (nonatomic,assign,readonly) NSInteger currentSelectIndex;

/**设置选项卡位置且响应点击事件 **/
@property (nonatomic,assign,readwrite) NSInteger tabsSelecteIndex;

/**设置选项卡位置且不响应点击事件**/
@property (nonatomic,assign,readwrite) NSInteger tabsNotDoingSelecteIndex;

/**是否允许连续响应同一个选项卡点击事件，默认NO*不允许*/
@property (nonatomic,assign) BOOL allowTabsAlwaysTouch;

/**是否允许底部蓝线做动画 默认NO**/
@property (nonatomic,assign) BOOL animationSelectLine;
@property (nonatomic,assign) BOOL defaultSelectFirst; //默认选择第一个，默认YES

/**一屏展示个数默认5个*/
@property(nonatomic,assign) NSInteger showNumbers;
/**点击按钮视图滚动类型*
 kAnimationTypeNextButton,下一个按钮大小
 kAnimationTypeCenter,屏幕中心
 */
@property (nonatomic,assign) NSInteger animationType;

/*点击按钮动做类型*/
@property(nonatomic,assign) ZFTabSelectAnimationType tableSelectAnimationType;
/*按钮展示类型*/
@property(nonatomic,assign) ZFTabSelectViewShowType tableSelectShowType;

#pragma mark  方法
/**清理所有按钮，用于更换选项卡内容**/
-(void)clearAllTopTabs;
/**请除按钮样式*/
-(void)clearButtonStyle;

#pragma mark 设置背景图片和字体颜色
-(void) setButtonNormalImage:(NSString *)norImageName selectImage:(NSString *)selImageName normalTitleColor:(UIColor *)norColor selectTitleColor:(UIColor *)selectColor;

@end
