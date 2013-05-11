//
//  ContactViewController.m
//  testXMPP
//
//  Created by yangjiannan on 4/23/13.
//  Copyright (c) 2013 techrare. All rights reserved.
//

#import "ContactViewController.h"
#import "LoginViewController.h"
#import "IOSXMPPAppDelegate.h"
#import "LoginViewController.h"
#import "ChatViewController.h"
#import "ChatView.h"
#import "TestSQLite3ViewController.h"
#import "TECHSqlite3Helper.h"
#import "TDBadgedCell.h"

#import "DDLog.h"
#import <QuartzCore/QuartzCore.h>

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@interface ContactViewController ()
@property(retain, nonatomic) UIBarButtonItem *plusContactBarBtn;
@property(retain, nonatomic) IOSXMPPAppDelegate *iOSXMPPAppDelegate;
@property(retain, nonatomic) TECHSqlite3Helper *sqlite3Helper;
@property(retain, nonatomic)NSString *messageFrom ;
@property(retain, nonatomic)NSString *textMessage;

@end

@implementation ContactViewController
@synthesize segCtl, plusContactBarBtn,tableView, iOSXMPPAppDelegate, sqlite3Helper, messageFrom, textMessage;


-(void)dealloc
{
    [segCtl release];
    [plusContactBarBtn release];
    [iOSXMPPAppDelegate release];
    [sqlite3Helper release];
    [messageFrom release];
    [textMessage release];
    [super dealloc];
}

-(TECHSqlite3Helper *)sqlite3Helper
{
    if(!sqlite3Helper)
    {
        sqlite3Helper = [[TECHSqlite3Helper alloc] init];
    }
    return sqlite3Helper;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"聯繫人";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *testSQLBtn= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(testSQLite3ViewController:)];
    self.navigationItem.leftBarButtonItem = testSQLBtn;
    
    
    UIBarButtonItem *addContact = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact:)];
    //[anotherButton setStyle:UIBarButtonItemStyleDone];
    self.navigationItem.rightBarButtonItem = addContact;
    
    
    [addContact release];
    
    // 登錄xmpp server成功后...
//    [self addObserver:self
//           forKeyPath:@"iOSXMPPAppDelegate.isLogined"
//              options:(NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld)
//              context:nil];
    
    //有消息發送來時，在tableView 相應的行顯示消息數
   
}

-(void)testSQLite3ViewController:(id)sender
{
    TestSQLite3ViewController *testSqlite3 = [[TestSQLite3ViewController alloc] initWithNibName:@"TestSQLite3ViewController" bundle:nil];
    [self presentViewController:testSqlite3 animated:YES completion:^{}];
}

//#pragma mark ---
//#pragma mark --- addObserver proccess
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    NSLog(@"******%@", [change description]);
//}



#pragma mark --
#pragma mark -- viewController delegate
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    NSLog(@"self.textMessage:%@", self.textMessage);
    // 登錄xmpp server
    if (!self.iOSXMPPAppDelegate.isXmppConnected) {
        if(![self.iOSXMPPAppDelegate connect])
        {
            LoginViewController *loginCtl = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [self presentViewController:loginCtl animated:YES completion:^{}];
            [loginCtl release];
        }
    }
    
    
    [self addObserver:self forKeyPath:@"iOSXMPPAppDelegate.messageFrom" options:NSKeyValueObservingOptionNew  context:nil];
    [self addObserver:self forKeyPath:@"iOSXMPPAppDelegate.textMessage" options:NSKeyValueObservingOptionNew  context:nil];
    
    // 重新加載一次
    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");

    [self removeObserver:self forKeyPath:@"iOSXMPPAppDelegate.messageFrom"];
    [self removeObserver:self forKeyPath:@"iOSXMPPAppDelegate.textMessage"];

    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSString *new = [change objectForKey:@"new"];
    
    NSLog(@"new1:%@", new);
    if([new hasPrefix:self.iOSXMPPAppDelegate.kTextMessage])
    {
        self.textMessage = [new stringByReplacingOccurrencesOfString:self.iOSXMPPAppDelegate.kTextMessage withString:@""];
    }
    
    if([new hasPrefix:self.iOSXMPPAppDelegate.kMessageFrom])
    {
        self.messageFrom = [new stringByReplacingOccurrencesOfString:self.iOSXMPPAppDelegate.kMessageFrom withString:@""];
    }
    [self insertUnReadedMessage];
}

-(void)insertUnReadedMessage
{
    NSLog(@"---------------self.messgeFrom:%@", self.messageFrom);
    NSLog(@"---------------self.textMessage:%@", self.textMessage);
    if(self.messageFrom && self.textMessage)
    {
        //插入一條未讀消息記錄到 dby
        NSDictionary *record = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID],@"receiver",
                                self.messageFrom,@"sender",
                                textMessage,@"messageContent",
                                @"1", @"readed",
                                nil];
        
        [self.sqlite3Helper insertMessage:record];
        self.messageFrom = nil;
        self.textMessage = nil;
        
        [self.tableView reloadData];
        
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIBarButtonItem *)plusContactBarBtn
{
    if(plusContactBarBtn)
    {
        plusContactBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddContact:)];
        
    }
    return  plusContactBarBtn;
}

-(void)loadLoginViewContoller:(id)sender
{
    LoginViewController *loginCtl = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self presentViewController:loginCtl animated:YES completion:^{}];
    [loginCtl release];
}
-(void)addContact:(id)sender
{
    
}

#pragma mark --
#pragma mark -- XMPP
- (IOSXMPPAppDelegate *)iOSXMPPAppDelegate
{
	if(!iOSXMPPAppDelegate)
    {
        iOSXMPPAppDelegate = [[IOSXMPPAppDelegate alloc] init];
    }
    return iOSXMPPAppDelegate;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController == nil)
	{
		NSManagedObjectContext *moc = [[self iOSXMPPAppDelegate] managedObjectContext_roster];
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
		                                          inManagedObjectContext:moc];
		
		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
		NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
		
		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[fetchRequest setFetchBatchSize:10];
		
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
		                                                               managedObjectContext:moc
		                                                                 sectionNameKeyPath:@"sectionNum"
		                                                                          cacheName:nil];
		[fetchedResultsController setDelegate:self];
		
		
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error])
		{
			DDLogError(@"Error performing fetch: %@", error);
		}
        
	}
	
	return fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[[self tableView] reloadData];
}

#pragma mark -- 
#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChatView *chatViewCtl = [[ChatView alloc] initWithNibName:@"ChatView" bundle:nil];
    chatViewCtl.userInfo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    chatViewCtl.iOSXMPPAppDelegate = self.iOSXMPPAppDelegate;
    [self.navigationController pushViewController:chatViewCtl animated:YES];
    [chatViewCtl release];

}


#pragma mark --
#pragma mark -- UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [[[self fetchedResultsController] sections] count];
}

- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)sectionIndex
{
	NSArray *sections = [[self fetchedResultsController] sections];
	
	if (sectionIndex < [sections count])
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
        
		int section = [sectionInfo.name intValue];
		switch (section)
		{
			case 0  : return NSLocalizedString(@"available", @"");
			case 1  : return NSLocalizedString(@"away", @"");
			default : return NSLocalizedString(@"Offline", @"");
		}
	}
	
	return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	NSArray *sections = [[self fetchedResultsController] sections];
	
	if (sectionIndex < [sections count])
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
        
		return sectionInfo.numberOfObjects;
	}
	
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	static NSString *CellIdentifier = @"Cell";
	TDBadgedCell *cell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];


	// set badge
	int count = [self.sqlite3Helper queryNewMessageCountForUser:user.displayName];
    if (count>0) {
        cell.badgeColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"messageBagesRead"]];
        cell.badge.radius = 6;
        cell.badge.fontSize = 11;
        cell.badgeString =  [NSString stringWithFormat:@"%i", count];
    }else{
        
    }
	cell.textLabel.text = user.displayName;
	[self configurePhotoForCell:cell user:user];
	
	return cell;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableViewCell helpers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)configurePhotoForCell:(UITableViewCell *)cell user:(XMPPUserCoreDataStorageObject *)user
{
	// Our xmppRosterStorage will cache photos as they arrive from the xmppvCardAvatarModule.
	// We only need to ask the avatar module for a photo, if the roster doesn't have it.
    UIImage *photoImage = nil;
	if (user.photo != nil)
	{
		photoImage = user.photo;
	}
	else
	{
		NSData *photoData = [[[self iOSXMPPAppDelegate] xmppvCardAvatarModule] photoDataForJID:user.jid];
        
		if (photoData != nil)
		{
            photoImage = [UIImage imageWithData:photoData];
        }else
        {
			photoImage = [UIImage imageNamed:@"defaultPerson"];
        }
        
        
	}
    photoImage = [self scaleToSize:photoImage size:CGSizeMake(35, 35)];
    if(photoImage)
    {
        cell.imageView.image = photoImage;
    }
    cell.imageView.layer.cornerRadius = 3.0; //.cornerRadius = yourRadius;
    cell.imageView.clipsToBounds = YES;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
