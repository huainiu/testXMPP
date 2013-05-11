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
-(NSArray *)queryNewMesasgeForUser:(NSString *)user;
-(NSInteger)queryNewMessageCountForUser:(NSString *)user;
-(void)updateMessageReadedForUser:(NSString *)user;
-(void)delRow;
@end
