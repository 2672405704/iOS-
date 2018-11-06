//
//  ViewController.h
//  AnimatePro
//
//  Created by 郭杰智 on 2018/9/20.
//  Copyright © 2018年 郭杰智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
+(void)setAnimationDelegate:(id)delegate;//设置动画代理对象，当动画开始的或者结束的时候会发消息给代理对象
+(void)setAnimationWillStartSelector:(SEL)selector;//当动画开始的时候执行delegate对像的selector并且把beginAnimations:context:中传人的参数传进selector
+(void)setAnimationDidStopSelector:(SEL)selector;//当动画结束的时候，执行delegate对象的selector并且beginAniamtions:context:中传人的参数传进selector

@end

