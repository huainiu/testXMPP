//
//  TECHSqlite3Helper.h
//  testXMPP
//
//  Created by yangjiannan on 5/4/13.
//  Copyright (c) 2013 techrare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TECHSqlite3Helper : NSObject

-(void)insertMessage:(NSDictionary *)record;
-(NSDictionary *)queryMesasge:(NSString *)tableName params:(NSDictionary *)params error:(NSError **)error;
-(NSInteger)queryNewMessage;
@end
