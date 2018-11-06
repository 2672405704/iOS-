//
//  FMManager.m
//  Monk
//
//  Created by yili on 14-7-24.
//  Copyright (c) 2014年 com.kuying. All rights reserved.
//

#import "FMManager.h"

static NSString *dbName = @"OneMile.db";

@implementation FMManager

#pragma mark - Singleton
+ (FMManager *)sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static FMManager *sharedManager = nil;
    dispatch_once(&pred, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self creatDB];
    }
    return self;
}

- (void)creatDB
{
    NSString *dbPath = [self pathForName:dbName];
    self.db = [FMDatabase databaseWithPath:dbPath];
}

//获得指定名字的文件的全路径
- (NSString *)pathForName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths lastObject];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:name];
    
    return dbPath;
}

- (void)deleteDB
{
    NSString *dbPath = [self pathForName:dbName];
    [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
}

#pragma mark - SQLite Methods
- (BOOL)openDB
{
    BOOL open = NO;
    if (self.db != NULL) {
        open = [self.db open];
    } else {
        [self creatDB];
        open = [self.db open];
    }
    return open;
}

- (BOOL)cleanTableIgnore:(NSString *)ignoreTableName
{
    BOOL rst = NO;
    if (![[FMManager sharedManager].db open]) {
        return rst;
    }
    
    NSString *sql = @"select name from sqlite_master where type = 'table' ";
    FMResultSet *result =  [[FMManager sharedManager].db executeQuery:sql];
    while ([result next]) {
        NSString *tableName = [result stringForColumn:@"name"];
        if ([tableName isEqualToString:ignoreTableName]) {
            rst = YES;
            continue;
        }
        
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ ", tableName];
        rst = [[FMManager sharedManager].db executeUpdate:sql];
        
        NSString *seq = [NSString stringWithFormat:@"UPDATE sqlite_sequence SET seq = 0 WHERE name = '%@' ", tableName];
        [[FMManager sharedManager].db executeUpdate:seq];
    }
    [[FMManager sharedManager].db close];
    
    return rst;
}

- (void)closeDB
{
    if (self.db != NULL) {
        if ([self.db open]) {
            [self.db close];
        }
    }
}

@end
