//
//  TTAlertView.m
//
//  Created by yangye on 14-10-14.
//  Copyright (c) 2014年. All rights reserved.
//

#import "GWLAlertView.h"
#import "TLAttributedLabel.h"
#define kTitleYOffset 18.0f

#define KSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define KSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TTAlertView ()
{
    BOOL _leftLeave;
    BOOL _initByArr;
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) TLAttributedLabel *alertContentLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *backImageView;

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, strong) NSMutableArray *selectedIndexArrM;
@end

@implementation TTAlertView

- (NSMutableArray *)selectedIndexArrM {
    
    if (_selectedIndexArrM == nil) {
        
        self.selectedIndexArrM = [NSMutableArray array];
    }
    return _selectedIndexArrM;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)calculateScale {
    if(KSCREEN_WIDTH == 320){
        self.scale = 1.0f;
        
    }else if (KSCREEN_WIDTH == 375 ){
        self.scale = 1.171875f;
        
    }else if (KSCREEN_WIDTH == 414){
        self.scale = 1.29375f;
        
    }else{
        self.scale = 1.0f;
    }
}

- (instancetype)initWithTitle:(NSString *)title
        contentText:(NSString *)content
{
    if (self = [super init]) {
        
        [self calculateScale];
        
        _initByArr = NO;
        
        self.layer.cornerRadius = 10.0;
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, kTitleYOffset, [self getAlertW] - 30, 20)];
        self.alertTitleLabel.text = title;
        self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.alertTitleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        [self addSubview:self.alertTitleLabel];
        self.titleColor = [UIColor whiteColor];

        CGFloat contentLabelWidth = [self getAlertW] - 20;
        self.alertContentLabel = [[TLAttributedLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.alertTitleLabel.frame) + 15, contentLabelWidth, 50)];
        self.alertContentLabel.lineSpacing = 0.0f;
        self.alertContentLabel.imageSize = CGSizeMake(15.5, 15.5);
        self.alertContentLabel.font = [UIFont systemFontOfSize:20.0];
        self.alertContentLabel.textAlignment = kCTTextAlignmentCenter;
        [self.alertContentLabel setText:content];
        [self addSubview:self.alertContentLabel];
        self.contentColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, [self getAlertH] - 44, [self getAlertW], 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        
        CGRect leftBtnFrame = CGRectMake(18, [self getAlertH] - 28, 12, 12);
        CGRect rightBtnFrame = CGRectMake([self getAlertW] - 32, [self getAlertH] - 28, 15.5, 15.5);

        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        self.leftBtn.frame = leftBtnFrame;
        self.rightBtn.frame = rightBtnFrame;
        
        [self.rightBtn setImage:[UIImage imageNamed:@"pet_ok"] forState:UIControlStateNormal];
        [self.leftBtn setImage:[UIImage imageNamed:@"pet_cancle"] forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
        self.backgroundColor = UIColorFromRGB(0x1D1E1C);
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                   contentArr:(NSArray *)contentArr
{
    if (self = [super init]) {
        
        _initByArr = YES;
        [self calculateScale];

        self.layer.cornerRadius = 10.0;
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, kTitleYOffset, [self getAlertW] - 30, 20)];
        self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.alertTitleLabel.text = title;
        self.alertTitleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        [self addSubview:self.alertTitleLabel];
        
        CGFloat originY = CGRectGetMaxY(self.alertTitleLabel.frame) + 20 ;
        
        for (int index = 0; index < contentArr.count; index ++) {
            
            CGFloat btnY = originY + index * (15.5 + 15 * self.scale);
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(75/2.0, btnY, 15.5, 15.5)];
            btn.tag = index + 1;
            [btn setImage:[UIImage imageNamed:@"radio_unselect"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"radio_select"] forState:UIControlStateSelected];
            [self addSubview:btn];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, btnY, 120, 14)];
            contentLabel.textColor = [UIColor grayColor];
            contentLabel.font = [UIFont systemFontOfSize:14.0];
            contentLabel.text = contentArr[index];
            [self addSubview:contentLabel];
            
            self.titleColor = [UIColor blackColor];
            self.backgroundColor = [UIColor whiteColor];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, [self getAlertH] - 44, [self getAlertW], 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        
        CGRect leftBtnFrame = CGRectMake(18, [self getAlertH] - 28, 12, 12);
        CGRect rightBtnFrame = CGRectMake([self getAlertW] - 32, [self getAlertH] - 28, 15.5, 15.5);
        
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.leftBtn.frame = leftBtnFrame;
        self.rightBtn.frame = rightBtnFrame;
        
        [self.rightBtn setImage:[UIImage imageNamed:@"pet_ok"] forState:UIControlStateNormal];
        [self.leftBtn setImage:[UIImage imageNamed:@"pet_cancle"] forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
    }
    
    return self;
}

- (void)btnAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [self.selectedIndexArrM addObject:@(btn.tag)];
    }else {
        [self.selectedIndexArrM removeObject:@(btn.tag)];
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.alertTitleLabel.textColor = titleColor;
}

- (void)setContentColor:(UIColor *)contentColor {
    _contentColor = contentColor;
    self.alertContentLabel.textColor = contentColor;
}
- (void)setContentFont:(UIFont *)contentFont{
    _contentFont = contentFont;
    self.alertContentLabel.font = contentFont;
}

- (void)setAlertViewBgColor:(UIColor *)alertViewBgColor {
    _alertViewBgColor = alertViewBgColor;
    self.backgroundColor = alertViewBgColor;
}

- (void)leftBtnClicked:(id)sender
{
    _leftLeave = YES;
    [self dismissAlert];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightBtnClicked:(id)sender
{
    _leftLeave = NO;
    
    [self dismissAlert];
    
    if (_initByArr && self.contentArrRightBlock) {
        
        self.contentArrRightBlock([self.selectedIndexArrM copy]);
    }
    
    if (self.contentTextrightBlock) {
        
        self.contentTextrightBlock();
    }
}

- (CGFloat)getAlertW {
    
    if (_initByArr) {
        
        return 452/2.0 * self.scale;
    }
    
    return 540/2.0 *self.scale;
}

- (CGFloat)getAlertH {
    
    if (_initByArr) {
        return 482/2.0 * self.scale;
    }
    return 263/2.0 * self.scale;
}

- (CGFloat)getAlertOriginX {
    UIViewController *topVC = [self appRootViewController];
    
    return (CGRectGetWidth(topVC.view.bounds) - [self getAlertW])/2.0;
}

- (CGFloat)getAlertOriginY {
    return (KSCREEN_HEIGHT - [self getAlertH]) / 2.0;
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake([self getAlertOriginX], [self getAlertOriginY], [self getAlertW], [self getAlertH]);
    [topVC.view addSubview:self];
}

- (void)dismissAlert
{
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)removeFromSuperview
{
    UIViewController *topVC = [self appRootViewController];
    
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - [self getAlertW]) * 0.5, CGRectGetHeight(topVC.view.bounds), [self getAlertW], [self getAlertH]);
    
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        
        if (_leftLeave) {
            
            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
        }else {
            
            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
        }
        
        self.backImageView.alpha = 0.2;

    } completion:^(BOOL finished) {
        
        [super removeFromSuperview];
        
        [self.backImageView removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        if (_initByArr) {
            self.backImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        }else {
            self.backImageView.backgroundColor = [UIColor clearColor];
        }
       
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:self.backImageView];
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake([self getAlertOriginX], [self getAlertOriginY], [self getAlertW], [self getAlertH]);
    [UIView animateWithDuration:0.0f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
}

@end

