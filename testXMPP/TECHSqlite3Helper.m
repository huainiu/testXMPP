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
    @"create table if not exists messageTable (msgId integer primary key, receiver text,sender text,messageContent text,recordTime text,readed integer)";
    int result1 = sqlite3_exec(database, [messsageTable_sql UTF8String], NULL, NULL, &error);
    
    if(result1!=SQLITE_OK)
    {
        NSAssert(0, @"創建表 messageTable 失敗");
        NSLog(@"create mesasgeTable error:%s", error);
    }
    
    
    //create table if not exsit:roasterTable＋
    NSString *roasterTable_sql =
    @"create table if not exists roasterTable (roasteId integer primary key, displayName text, photo text, jid text)";
    int result2 = sqlite3_exec(database, [roasterTable_sql UTF8String], NULL, NULL, &error);
    
    if (result2 != SQLITE_OK)
    {
        NSAssert(0, @"創建表 roasterTable 失敗");
        NSLog(@"create roasterTable error:%s", error);
    }
    return database;
}

-(void)insertMessage:(NSDictionary *)record
{
    NSLog(@"insert message :%@", (NSString *)[record  objectForKey:@"receiver"]);
    char *sql = "insert into messageTable(msgId, receiver, sender, messageContent, recordTime, readed) values(?, ?, ?, ?, datetime(), ?)";
    sqlite3_stmt *stmt;
    sqlite3 *database = [self openDB];
    if(sqlite3_prepare(database, sql, -1, &stmt, nil)==SQLITE_OK)
    {
        sqlite3_bind_int(stmt, 0, -1);
        sqlite3_bind_text(stmt, 2, [(NSString *)[record  objectForKey:@"receiver"] UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 3, [[record objectForKey:@"sender"] UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 4, [[record objectForKey:@"messageContent"] UTF8String], -1, nil);
        sqlite3_bind_int(stmt, 5, [[record objectForKey:@"readed"] integerValue]);
    }
    if(sqlite3_step(stmt)!=SQLITE_DONE)
    {
        NSAssert(0, @"插入一條信息失敗");
    }
    sqlite3_finalize(stmt);
    sqlite3_close(database);
}
-(NSInteger)insetlastRow
{
    NSInteger lastRow;
    char *sql = "SELECT MAX(msgId) from messageTable group by msgId";
    sqlite3_stmt *stmt;
    if(sqlite3_prepare([self openDB], sql, -1, &stmt, nil)==SQLITE_OK)
    {
        while (sqlite3_step(stmt)==SQLITE_ROW)
        {
            lastRow = sqlite3_column_int(stmt, 0);
        }
    }
    NSLog(@"lastRow:%i", lastRow+1);
    return lastRow+1;
}

-(NSArray *)queryNewMesasgeForUser:(NSString *)user
{
    NSMutableArray *rows =  [[NSMutableArray alloc] init];
    
    char *sql = "select msgId, receiver, sender, messageContent,  recordTime, readed from  messageTable where sender=? and readed=1";
    sqlite3_stmt *stmt ;
    sqlite3 *database = [self openDB];
    if(sqlite3_prepare(database, sql, -1, &stmt, nil)==SQLITE_OK)
    {
        sqlite3_bind_text(stmt, 1, [user UTF8String], -1, nil);
        while(sqlite3_step(stmt)==SQLITE_ROW)
        {

            NSDictionary *record = [[NSDictionary alloc] initWithObjectsAndKeys:
                      [NSString stringWithFormat:@"%i",sqlite3_column_int(stmt, 0)], @"msgId",
                      [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)], @"receiver",
                      [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)], @"sender",
                      [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)], @"messageContent",
                      [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)], @"recordTime",
                      [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)], @"readed",
                      nil];
            [rows addObject:record];
            [record release];
        }
    }
    return rows;
}


//未讀取的新消息
-(NSInteger)queryNewMessageCountForUser:(NSString *)user
{
    NSInteger count;
    char *sql = "select count(*) from messageTable where readed=1 and sender=?";
    sqlite3_stmt *stmt = nil;
    sqlite3 *database = [self openDB];
    if(sqlite3_prepare( database, sql, -1, &stmt, nil)==SQLITE_OK)
    {
        sqlite3_bind_text(stmt, 1, [user UTF8String], -1, nil);
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            count = sqlite3_column_int(stmt, 0);
            
        }

    }
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return count;
}

-(void)updateMessageReadedForUser:(NSString *)user
{
    char *sql = "update messageTable set readed=0 where sender=?";
    sqlite3_stmt *stmt;
    sqlite3 *db = [self openDB];
    if(sqlite3_prepare(db, sql, -1, &stmt, nil)==SQLITE_OK)
    {
        sqlite3_bind_text(stmt, 1, [user UTF8String], -1, nil);
        sqlite3_step(stmt);
    }
}

-(void)delRow
{
    char *sql1 = "delete from messageTable";
    char *sql2 = "drop table roasterTable";
    char *error;
    sqlite3 *db = [self openDB];
    sqlite3_exec(db, sql1, NULL, NULL, &error);
    sqlite3_exec(db, sql2, NULL, NULL, &error);
    if(!error)
    {
        NSLog(@"Clear database !!!");
    }
    sqlite3_close(db);
}
@end
