//
//  TTAlertView.h
//
//  Created by yangye on 14-10-14.
//  Copyright (c) 2014年. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RightBlock) (NSArray *selectedArrIndex);

@interface TTAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title
        contentText:(NSString *)content;


- (instancetype)initWithTitle:(NSString *)title
                   contentArr:(NSArray *)contentArr;


@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t contentTextrightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;
@property (nonatomic, copy) RightBlock contentArrRightBlock;

@property (nonatomic,strong)UIColor *titleColor;

@property (nonatomic,strong)UIColor *contentColor;
@property (nonatomic,strong)UIFont *contentFont;

@property (nonatomic,strong)UIColor *alertViewBgColor;


- (void)show;

@end


