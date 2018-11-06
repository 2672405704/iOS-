//
//  MGDBmanager.h
//  AnimatePro
//
//  Created by 彭铭 on 2018/11/2.
//  Copyright © 2018年 郭杰智. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
@interface MGDBmanager : NSObject
+ (instancetype)shareManager;


- (void)createDBWithName:(NSString *)dbName;

- (void)createTableWithName:(NSString *)tableName;
@end
