//
//  FMDBManager.m
//  Client
//
//  Created by 李黎明 on 16/1/13.
//  Copyright © 2016年 liliming. All rights reserved.
//

#import "FMDBManager.h"
#import "FMDatabaseAdditions.h"
#import "DeviceInfo.h"
static NSString *dbName = @"Animatepohqqh.db";
static NSString *DBVersion = @"3";
@implementation FMDBManager

#pragma mark - Singleton
+ (FMDBManager *)sharedFMDBManagerInstance
{
    static dispatch_once_t pred = 0;
    
    __strong static FMDBManager *sharedFMDBManagerInstance = nil;
    dispatch_once(&pred, ^{
        sharedFMDBManagerInstance = [[self alloc] init];
    });
    return sharedFMDBManagerInstance;
}

- (id)init
{
    
    self = [super init];
   
    if (self) {
        NSString *dbPath = [self pathForName:dbName];
        _dbpath = dbPath;
     
        NSLog(@"FMdbpath=%@",dbPath);
      
        //pm新增
        int currVersion = (int)[[NSUserDefaults standardUserDefaults]objectForKey:@"DBVersion"];
       BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];//数据是否存在
        
       self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        NSLog(@"fileExist=%d",fileExist);
        if (currVersion <= DBVersion.intValue && fileExist) {//DBVersion最新的版本号
            _fmdbname = @"DeviceUserInfo";
             [self upgradeDB];
            
//       _fmdbname = [NSString stringWithFormat:@"%@%d",@"DeviceUserInfo",currVersion];
        }else{
         _fmdbname = @"DeviceUserInfo";
             [self createUserTable];
        }
    }
    return self;
}

//获得指定名字的文件的全路径
- (NSString *)pathForName:(NSString *)name
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory =  paths.lastObject;
////
//    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:name];
    NSString *dbPath = NSHomeDirectory();
    [dbPath stringByAppendingPathComponent:@"documents"];
//    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cachePath = [cacPath objectAtIndex:0];
 dbPath =  [dbPath stringByAppendingPathComponent:name];
    return dbPath;
}

//创建数据库
- (void)createUserTable
{
    
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{@"DBVersion":DBVersion}];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        NSMutableString *createUserTableSql = [NSMutableString stringWithString:@"CREATE TABLE IF NOT EXISTS DeviceUserInfo"];
        [createUserTableSql appendString:@"(id integer PRIMARY KEY AUTOINCREMENT DEFAULT NULL,"];
        [createUserTableSql appendString:@"`userId` TEXT(20) DEFAULT NULL,"];
        [createUserTableSql appendString:@"`userName` TEXT(20) DEFAULT NULL)"];

        if ([db executeUpdate:createUserTableSql]) {
            NSLog(@"创建用户表成功");
        } else {
            NSLog(@"创建用户表失败");
        }
        
        [db close];

    }];
}
//检查制定的用户信息是否存在
- (BOOL)isExistRecord:(DeviceInfo *)userModel
{
    __block BOOL retult = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        //pm修改
        NSString *exsitSql = [NSString stringWithFormat:@"select `userId` from %@ where `userId`= ?",self.fmdbname];
        FMResultSet *rs = [db executeQuery:exsitSql,userModel.userId];
        while ([rs next]) {
            retult = YES;
        }
         [db close];
    }];
    return retult;
}
//插入用户
- (BOOL)insertUserToDatabaseWithUserModel:(DeviceInfo *)userModel
{
    __block BOOL retult = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
       
        if (![db columnExists:self.fmdbname columnName:@"userage"]){
            NSMutableString *insertSql = [NSMutableString stringWithString:[NSString stringWithFormat:@"INSERT INTO %@",self.fmdbname]];
            [insertSql appendString:@"(`userId`, `userName`)"];
            [insertSql appendString:@"VALUES (?,?)"];
            retult =[db executeUpdate:insertSql,
                     userModel.userId, userModel.userName,userModel.userage];
        }else{
           NSMutableString *insertSql = [NSMutableString stringWithString:[NSString stringWithFormat:@"INSERT INTO %@",self.fmdbname]];
            [insertSql appendString:@"(`userId`, `userage`,`userName`)"];
            [insertSql appendString:@"VALUES (?,?,?)"];
            retult =[db executeUpdate:insertSql,
                     userModel.userId,userModel.userage, userModel.userName];
        }
        

        
        [db close];
    }];
    
    return retult;
    
}
//pm更改信息

-(BOOL)updateversionandcpu:(DeviceInfo *)device{
    __block BOOL retult = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        retult = [db executeUpdate:@"UPDATE %@ SET userId = ? ",self.fmdbname,device.userId];
        [db close];
    }];
    return retult;
    
}

//更改用户信息
- (BOOL)updateUserModel:(DeviceInfo *)userModel
{
    __block BOOL retult = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        NSMutableString *updateSql = [NSMutableString stringWithString:@"update DeviceUserInfo set"];
        [updateSql appendFormat:@" `userName` = '%@',", userModel.userName];
        [updateSql appendFormat:@" where `userId` = '%@'", userModel.userId];
        retult =[db executeUpdate:updateSql];
        [db close];
    }];
    return retult;
}

//查询单个用户
- (DeviceInfo *)getDeviceUserInfo:(DeviceInfo *)userModel
{
    __block DeviceInfo *S_model = nil;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
       
        FMResultSet *result =  [db executeQuery:@"SELECT * FROM DeviceUserInfo where userId = ?",userModel.userId];
        DeviceInfo *model = nil;
        while ([result next]) {
            model = [[DeviceInfo alloc] init];
            model.userId = [result stringForColumn:@"userId"];
            model.userName = [result stringForColumn:@"userName"];
            break;
        }
        S_model = model;
        [db close];
    }];
    return S_model;
}

//查询所有设备
- (NSMutableArray *)getAllDeviceUserInfo{
    __block NSMutableArray *userArray = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM DeviceUserInfo"]];
        while ([result next]) {
            DeviceInfo *model = [[DeviceInfo alloc] init];
            model.userId = [result stringForColumn:@"userId"];
            model.userName = [result stringForColumn:@"userName"];
            model.userage = [result stringForColumn:@"userage"];
            [userArray addObject:model];
        }
        [db close];
    }];
    return userArray;
}

//删除用户信息
- (BOOL)cleanDeviceUserInfo
{
    __block BOOL retult = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *deleteSql = [NSString stringWithFormat:@"delete from DeviceUserInfo"];
        retult = [db executeUpdate:deleteSql];
        [db close];
    }];
    return retult;
}

//删除某个用户信息
- (BOOL)DeleteOneDeviceUserInfo:(DeviceInfo *)model
{
    __block BOOL retult = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *deleteSql = [NSString stringWithFormat:@"delete from DeviceUserInfo where userId = ?"];
        FMResultSet *rs = [db executeQuery:deleteSql,model.userId];
        while ([rs next]) {
            retult = YES;
        }
        [db close];
    }];
    return retult;
}

//清除文件信息
- (BOOL)cleanAllFilesInfo{
    __block BOOL retult = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *deleteSql = [NSString stringWithFormat:@"delete from FileInfo"];
        retult = [db executeUpdate:deleteSql];
        [db close];
    }];
    return retult;
}

-(void)upgradeDB{
     __block BOOL retult = NO;
    //pm新增
    int currVersion = (int)[[NSUserDefaults standardUserDefaults]objectForKey:@"DBVersion"];
    
    
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
       
//    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@", self.fmdbname,
//                         [NSString stringWithFormat:@"%@%d",self.fmdbname,currVersion+1]];
//     [db executeUpdate:sql];
//        //创建新的表
//        NSMutableString *createUserTableSql = [NSMutableString stringWithString:@"CREATE TABLE IF NOT EXISTS DeviceUserInfo"];
//        [createUserTableSql appendString:@"(id integer PRIMARY KEY AUTOINCREMENT DEFAULT NULL,"];
//        [createUserTableSql appendString:@"`userId` TEXT(20) DEFAULT NULL,"];
//        [createUserTableSql appendString:@"`userage` TEXT(20) DEFAULT NULL,"];
//        [createUserTableSql appendString:@"`userName` TEXT(20) DEFAULT NULL)"];
//
//
//        if ([db executeUpdate:createUserTableSql]) {
//            NSLog(@"创建新用户表成功");
//            // 从旧数据表把旧数据插入新的数据表中
//
//        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ SELECT * ,'' FROM %@", self.fmdbname, [NSString stringWithFormat:@"%@%d",self.fmdbname,currVersion+1]];
//
//        [db executeUpdate:insertSql];
//            //旧表改名
//
//
//        } else {
//            NSLog(@"创建新用户表失败");
//        }
////         self.fmdbname = [NSString stringWithFormat:@"%@%d",self.fmdbname,currVersion+1];
//        // 删除旧的数据表
//        [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE %@",[NSString stringWithFormat:@"%@%d",self.fmdbname,currVersion+1]]];
//
//        [db close];

        NSString *deleteSql = [NSString stringWithFormat:@"alter table DeviceUserInfo add column userage TEXT"];
        retult = [db executeUpdate:deleteSql];
        [db close];
        
    }];
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{@"DBVersion":DBVersion}];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(BOOL)excuteLocalSql:(NSString *)createTB_info
{
    __block BOOL retult = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *deleteSql = [NSString stringWithFormat:@"alter table DeviceUserInfo add column userage TEXT"];
        retult = [db executeUpdate:deleteSql];
        [db close];
    }];
    return retult;
   

}
@end
