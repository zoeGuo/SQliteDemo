//
//  PersonTool.h
//  SQliteDemo
//
//  Created by deveplopper on 15/7/27.
//  Copyright (c) 2015年 deveplopper. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  Person;

@interface PersonTool : NSObject

/*
 保存一个联系人
 */
+(void) save:(Person *) person ;

/*
 查询
 */

+(NSArray *) query;

+(NSArray *) queryWithCondition:(NSString *) condition;

@end
