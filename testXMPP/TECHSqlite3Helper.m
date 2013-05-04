//
//  TECHSqlite3Helper.m
//  testXMPP
//
//  Created by yangjiannan on 5/4/13.
//  Copyright (c) 2013 techrare. All rights reserved.
//

#import "TECHSqlite3Helper.h"
#import <sqlite3.h>



@interface TECHSqlite3Helper()
-(sqlite3 *)openDB;
@end

static NSString *dbFilePath = @"invision_im.db";

@implementation TECHSqlite3Helper

-(NSString *)dbFilePath
{
    NSString *path = nil;
    NSArray *dicr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [dicr objectAtIndex:0];
    path = [path stringByAppendingPathComponent:dbFilePath];
    return path;
    
}

-(sqlite3 *)openDB
{
    sqlite3 *database;
    
    char *error = nil;
    
    
    //create or open db
    if(sqlite3_open([[self dbFilePath] UTF8String], &database)!=SQLITE_OK)
    {
        NSAssert(0, @"打開數據庫失敗");
        NSLog(@"open or create database error:%s", error);
    }
    
   
    // create table if not exsit: messageTable
    
    NSString *messsageTable_sql =
    @"create table if not exsits messageTable"
    "("
        "msgId integer auto increment primary key, "
        "receiver varchar,"
        "sender varchar,"
        "messageContent varchar,"
        "recordTime datetime,"
        "readed integer"
    ")";
    if(sqlite3_exec(database, [messsageTable_sql UTF8String], NULL, NULL, &error)!=SQLITE_OK)
    {
        NSAssert(0, @"創建表 messageTable 失敗");
        NSLog(@"create mesasgeTable error:%s", error);
    }
    
    
    //create table if not exsit:roasterTable
    
    NSString *roasterTable_sql =
    @"create table if not exsits roasterTable"
    "("
        "roasteId integer auto increment primary key,"
        "displayName varchar,"
        "photo varchar,"
        "jid varchar"
    ")";
    if (sqlite3_exec(database, [roasterTable_sql UTF8String], NULL, NULL, &error) != SQLITE_OK)
    {
        NSAssert(0, @"創建表 roasterTable 失敗");
        NSLog(@"create roasterTable error:%s", error);
    }
    return database;
}

-(void)insertMessage:(NSDictionary *)record table:(NSString *)tableName error:(char **)error
{
    char *sql = "insert into messageTable(receiver, sender, messageContent, recordTime, readed) values(?,"
    "?, ?, datetime(), ?)";
    sqlite3_stmt *stmt;
    sqlite3 *database = [self openDB];
    if(sqlite3_prepare(database, sql, -1, &stmt, nil)==SQLITE_OK)
    {
        sqlite3_bind_text(stmt, 1, [(NSString *)[record  objectForKey:@"receiver"] UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [[record objectForKey:@"sender"] UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 3, [[record objectForKey:@"messageContent"] UTF8String], -1, nil);
        sqlite3_bind_int(stmt, 5, (NSInteger)[record objectForKey:@"readed"]);
    }
    if (sqlite3_step(stmt)!=SQLITE_DONE)
    {
        NSAssert(0, @"插入一條信息失敗");
    }
    sqlite3_finalize(stmt);
    sqlite3_close(database);
}

-(NSArray *)queryMesasge:(NSString *)tableName params:(NSDictionary *)params error:(NSError **)error
{
    NSArray *record = nil;
    
    return record;
}

//未讀取的新消息
-(NSInteger)queryNewMessage
{
    NSInteger count;
    char *sql = "select count(*) from messageTable where readed=0";
    sqlite3_stmt *stmt = nil;
    sqlite3 *database = [self openDB];
    if(sqlite3_prepare( database, sql, -1, &stmt, nil)==SQLITE_OK)
    {
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            count = sqlite3_column_int(stmt, 0);
        }

    }
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return count;
}

@end
