//
//  IOSXMPPAppDelegate.h
//  testXMPP
//
//  Created by yangjiannan on 5/2/13.
//  Copyright (c) 2013 techrare. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "XMPPFramework.h"


//NSString *const ;
//NSString *const 


@interface IOSXMPPAppDelegate : NSObject<XMPPRosterDelegate>
{
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;
	XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    
    
    NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
    BOOL isLogined;
}
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property(nonatomic, strong)NSString *messageFrom;
@property(nonatomic, strong)NSString *textMessage;
@property(nonatomic) BOOL isXmppConnected;
@property(nonatomic) BOOL isLogined;
@property(nonatomic, strong, readonly)NSString *kMessageFrom;
@property(nonatomic, strong, readonly)NSString *kTextMessage;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;

- (BOOL)connect;
- (void)disconnect;
@end
