//
//  MGDBmanager.m
//  AnimatePro
//
//  Created by 彭铭 on 2018/11/2.
//  Copyright © 2018年 郭杰智. All rights reserved.
//

#import "MGDBmanager.h"
//1.判断数据库版本号和保存数据库版本号
NSString * const kdbManagerVersion = @"DBManagerVersion";
const static NSInteger DB_MANAGER_VER = 2;

#ifdef DEBUG
#define debugLog(...)    NSLog(__VA_ARGS__)
#define debugMethod()    NSLog(@"%s", __func__)
#define debugError()     NSLog(@"Error at %s Line:%d", __func__, __LINE__)
#else
#define debugLog(...)
#define debugMethod()
#define debugError()
#endif

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
static NSString * const DEFAULT_DB_NAME = @"app.db";

static NSString *const CREATE_TABLE_SQL =
@"CREATE TABLE IF NOT EXISTS %@ ( \
id TEXT NOT NULL, \
json TEXT NOT NULL, \
createdTime TEXT NOT NULL, \
PRIMARY KEY(id)) \
";

@implementation MGDBmanager

@end
