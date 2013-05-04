//
//  TECHSqlite3Helper.h
//  testXMPP
//
//  Created by yangjiannan on 5/4/13.
//  Copyright (c) 2013 techrare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TECHSqlite3Helper : NSObject

-(void)insertRecord:(NSDictionary *)record table:(NSString *)tableName error:(char **) error;
-(NSArray *)queryTable:(NSString *)tableName params:(NSDictionary *)params error:(NSError **)error;

@end
