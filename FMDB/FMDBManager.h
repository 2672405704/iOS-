//
//  FMDBManager.h
//  Client
//
//  Created by 李黎明 on 16/1/13.
//  Copyright © 2016年 liliming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#import "DeviceInfo.h"
#import "FMDatabaseQueue.h"

@interface FMDBManager : NSObject
@property (nonatomic,copy)NSString *fmdbname;
@property (nonatomic,copy)NSString *dbpath;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

+ (FMDBManager *)sharedFMDBManagerInstance;

//创建用户表格
- (void)createUserTable;
//判断某条记录是否存在
- (BOOL)isExistRecord:(DeviceInfo *)userModel;
//插入用户
- (BOOL)insertUserToDatabaseWithUserModel:(DeviceInfo *)userModel;
//更改用户信息
- (BOOL)updateUserModel:(DeviceInfo *)userModel;
//查询单个用户
- (DeviceInfo *)getDeviceUserInfo:(DeviceInfo *)userModel;
//删除某个用户信息
- (BOOL)DeleteOneDeviceUserInfo:(DeviceInfo *)model;
//查询所有设备
- (NSMutableArray *)getAllDeviceUserInfo;
//清除用户信息
- (BOOL)cleanDeviceUserInfo;


//查询所有文件
- (NSMutableArray *)getAllFilesInfo;
//清除文件信息
- (BOOL)cleanAllFilesInfo;





//pm(新增)清除adobe图片编辑信息
- (BOOL)cleanAlleditadobeImageInfo;

@end
