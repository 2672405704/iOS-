//
//  MGPaomaView.m
//  AnimatePro
//
//  Created by 彭铭 on 2018/11/5.
//  Copyright © 2018年 郭杰智. All rights reserved.
//

#import "MGPaomaView.h"

@interface MGPaomaView ()<CAAnimationDelegate>

@end

@implementation MGPaomaView
//设置字体
-(instancetype)initWithFrame:(CGRect)frame{
    
   self = [super initWithFrame:frame];
    
    if (self) {
        [self setupview];
    }
    
    return self;
}

-(void)setupview{
    _labels  = [NSMutableArray arrayWithCapacity:10];
    self.canAnimate = false;
    self.clipsToBounds = true;
    _textString = @"";
    _textFont = [self defaultSystemFont:14];
    _textColor = UIColor.blackColor;
}
-(void)setAttributeText:(NSAttributedString *)attr{
    
    if (_labels.count>0) {
        [_labels removeAllObjects];
    }
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    if (_canAnimate) {
        _canAnimate = false;
        [self stopAnimation];
        
    }
    UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = _textColor;
    label.font  = _textFont;
    label.attributedText = attr;
    [self addSubview:label];
}
-(void)settext:(NSString *)text{
    if (_labels.count>0) {
        [_labels removeAllObjects];
    }
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    if (_canAnimate) {
        _canAnimate = false;
        [self stopAnimation];
    }
    
    for (UILabel *lab in _labels) {
        lab.textColor = _textColor;
    }
    
    _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _mainView.backgroundColor = UIColor.redColor;
    [self addSubview:_mainView];
    _textString = text;
    
    CGSize size = [self getsize:text withsize:CGSizeMake(100000, 20) withfont:_textFont];
    if (size.width +10 > self.frame.size.width) {
        for (int i=0; i<2; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((i)*(size.width+20), 0, size.width+10, self.frame.size.height)];
            label.text = text;
            label.textColor = _textColor;
            label.textAlignment = NSTextAlignmentLeft;
            label.font = _textFont;
            label.backgroundColor = UIColor.greenColor;
            [_mainView addSubview:label];
            [_labels addObject:label];
        }
        
        if (!_canAnimate) {
            _canAnimate = true;
            [self startAnimation:size.width +20];
        }
    }else{
       UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width+20, self.frame.size.height)];
        label.text = text;
        label.textColor = _textColor;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = _textFont;
        [_mainView addSubview:label];
        _canAnimate = false;
    }
    
}
-(void)stopAnimation{
    
    if (_labels.count>0) {
        UILabel *labelone = _labels.firstObject;
        UILabel *labeltwo = _labels.lastObject;
        [labelone.layer removeAnimationForKey:@"frountAnimate"];
        [labeltwo.layer removeAnimationForKey:@"behindAnimate"];
    }
    
}
-(void)startAnimation:(CGFloat)textWidth{
   
    if (textWidth>self.frame.size.width) {
        _duration = _textString.length/4;
        UILabel *lab1 = _labels.firstObject;
        UILabel *lab2 = _labels.lastObject;
        
       CABasicAnimation *frountAnimat = [CABasicAnimation animationWithKeyPath:@"position"];
        frountAnimat.fromValue = [NSValue valueWithCGPoint:CGPointMake(lab1.center.x, lab1.center.y)];
        frountAnimat.toValue = [NSValue valueWithCGPoint:CGPointMake(lab1.center.x - textWidth, lab1.center.y)];
        frountAnimat.duration = _duration;
        frountAnimat.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        frountAnimat.repeatCount = MAXFLOAT;
//        frountAnimat.removedOnCompletion = false;
        CABasicAnimation *behindAnima = [CABasicAnimation animationWithKeyPath:@"position"];
        behindAnima.fromValue = [NSValue valueWithCGPoint:CGPointMake(lab2.center.x, lab2.center.y)];
        behindAnima.toValue = [NSValue valueWithCGPoint:CGPointMake(lab2.center.x - textWidth, lab2.center.y)];
        behindAnima.duration = _duration;
        behindAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        behindAnima.repeatCount = MAXFLOAT;
//        behindAnima.removedOnCompletion = false;
        
        
        [lab1.layer addAnimation:frountAnimat forKey:@"frountAnimate"];
        [lab2.layer addAnimation:behindAnima forKey:@"behindAnima"];
    }
    
}
-(void)setfont:(UIFont *)font{
    if (_canAnimate) {
        UILabel *labelone = _labels[0];
        UILabel *labeltwo = _labels[1];
        labelone.font = font;
        labeltwo.font = font;
    }
}

- (UIFont *)defaultSystemFont:(CGFloat)withSize{
    
    return [UIFont systemFontOfSize:withSize];
}

//获取文字的size
-(CGSize)getsize:(NSString *)withstring withsize:(CGSize)size withfont:(UIFont *)font{
     NSDictionary *attributes = @{NSFontAttributeName:font};
    CGSize newsize = [withstring boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
   
    return newsize;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
