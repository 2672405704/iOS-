//
//  FMManager.h
//  Monk
//
//  Created by yili on 14-7-24.
//  Copyright (c) 2014年 com.kuying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface FMManager : NSObject
{
    
}
@property (nonatomic, strong) FMDatabase *db;

+ (FMManager *)sharedManager;

- (BOOL)openDB;

- (void)deleteDB;

- (BOOL)cleanTableIgnore:(NSString *)ignoreTableName;

//当前视图如果用到数据库，在dealloc方法中必须调用这个方法
- (void)closeDB;

@end
