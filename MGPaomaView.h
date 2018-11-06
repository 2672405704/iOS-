//
//  MGPaomaView.h
//  AnimatePro
//
//  Created by 彭铭 on 2018/11/5.
//  Copyright © 2018年 郭杰智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGPaomaView : UIView
@property (nonatomic,strong)NSMutableArray *labels;
@property (nonatomic,strong)NSString *textString;
@property (nonatomic,strong)UIView *mainView;
@property (nonatomic,assign)NSTimeInterval duration;
@property (nonatomic,strong)UIFont *textFont;
@property (nonatomic,strong)UIColor *textColor;
@property (nonatomic,assign)BOOL canAnimate;
-(void)settext:(NSString *)text;
@end
