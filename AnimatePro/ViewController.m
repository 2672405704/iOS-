//
//  ViewController.m
//  AnimatePro
//
//  Created by 郭杰智 on 2018/9/20.
//  Copyright © 2018年 郭杰智. All rights reserved.
//

#import "ViewController.h"
#import "FMDBManager.h"
#import "MGPaomaView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //FMDB操作
    
//    [[FMDBManager sharedFMDBManagerInstance]cleanDeviceUserInfo];
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
//    btn.backgroundColor = [UIColor redColor];
//    [btn setTitle:@"点击" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//
//
//    [self setDeviceUserInfo];
   
    //封装跑马灯
    MGPaomaView *paoview = [[MGPaomaView alloc]initWithFrame:CGRectMake(40, 200, 240, 50)];
    [paoview settext:@"只是一个测试。rwed都是 v 速度速度速度。"];
    paoview.backgroundColor = UIColor.blackColor;
    paoview.textColor = UIColor.whiteColor;
    [self.view addSubview:paoview];
   
}
-(void)btnclick{
    [self getDeviceUserInfo];
}
-(void)setDeviceUserInfo{
    for (int i=0; i<3; i++) {
        DeviceInfo *device = [[DeviceInfo alloc]init];
        if (i==0) {
            device.userId = @"1111";
            device.userName = @"ni";
            device.userage = @"12";
        }else if (i==1){
            device.userId = @"2222";
            device.userName = @"wo";
            device.userage = @"23";
        }else{
            device.userId = @"3333";
            device.userName = @"ta";
            device.userage = @"45";
        }
        [[FMDBManager sharedFMDBManagerInstance]insertUserToDatabaseWithUserModel:device];
        
    }
    
}
-(void)getDeviceUserInfo{
    NSMutableArray *mutablearray = [NSMutableArray arrayWithCapacity:0];
    
    //从数据库取出添加群组保存的数据
    mutablearray = [[FMDBManager sharedFMDBManagerInstance]getAllDeviceUserInfo];
    
    for (int i=0; i<mutablearray.count; i++) {
        DeviceInfo *deviceinfo = mutablearray[i];
        NSLog(@"userid%d%@",i,deviceinfo.userId);
        NSLog(@"name%d%@",i,deviceinfo.userName);
        NSLog(@"age%d%@",i,deviceinfo.userage);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
