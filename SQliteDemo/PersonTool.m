//
//  PersonTool.m
//  SQliteDemo
//
//  Created by deveplopper on 15/7/27.
//  Copyright (c) 2015年 deveplopper. All rights reserved.
//

#import "PersonTool.h"
#import "Person.h"
#import <sqlite3.h>

@implementation PersonTool

static sqlite3 *_db;

+(void)initialize{

    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    
    NSString *fileName  = [doc stringByAppendingPathComponent:@"person.sqlite"];
    
    //将OC字符串转换为C语言字符串
    const char *cfileName = fileName.UTF8String;
    //1、打开数据库文件（如果数据库文件不存在，那么该函数会自动创建文件）
    int result = sqlite3_open(cfileName, &_db);
    if (result == SQLITE_OK) {
        NSLog(@"成功打开数据库");
        
        //2、创建表
        const char *sql = "CREATE TABLE IF NOT EXISTS t_person (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL,age integer NOT NULL)";
        char *errmsg = NULL;
        result = sqlite3_exec(_db, sql, NULL, NULL, &errmsg);
        if (result == SQLITE_OK) {
            NSLog(@"创建成功");
        }else{
            NSLog(@"创建失败");
        }
    }else{
        NSLog(@"打开数据库失败");
    }
    
}

+(void)save:(Person *)person{
    //1、拼接SQL语句
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_person (name, age) VALUES ('%@', %d);",person.name, person.age];
    //2、执行SQL语句
    char *errmsg = NULL;
    sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"插入数据失败--%s", errmsg);
    }else{
        NSLog(@"插入数据成功");
    }

}

+(NSArray *)query{

    return [self queryWithCondition:@""];
}

//模糊查询
+(NSArray *)queryWithCondition:(NSString *)condition{
//数组，用来存放查询到的联系人
    NSMutableArray *persons = nil;
    NSString *NSsql = [NSString stringWithFormat:@"SELECT id, name, age FROM t_person WHERE name like '%%%@%%' ORDER BY age ASC;", condition];
    NSLog(@"%@", NSsql);
    const char *sql = NSsql.UTF8String;
    sqlite3_stmt *stmt = NULL;
    //进行查询前的准备工作
    if (sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL) == SQLITE_OK) {
        //SQL语句没有问题
        NSLog(@"查询语句没有问题");
        persons = [NSMutableArray array];
        //每调用一次sqlite3_step函数，stmt 就会指向下一条记录
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //找到一条数据
            //取出数据
            //取出第0列字段的值（int类型的值）
            int ID = sqlite3_column_int(stmt, 0);
            //
            const unsigned char *name = sqlite3_column_text(stmt, 1);
            //
            int age = sqlite3_column_int(stmt, 2);
            
            Person *p = [[Person alloc]init];
            p.id = ID;
            p.name = [NSString stringWithUTF8String: (const char *)name];
            p.age = age;
            [persons addObject:p];
        }
        
    }else{
        NSLog(@"查询语句有问题");
    }
    return persons;
}

@end
