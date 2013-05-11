//
//  TestSQLite3ViewController.m
//  testXMPP
//
//  Created by yangjiannan on 5/6/13.
//  Copyright (c) 2013 techrare. All rights reserved.
//

#import "TestSQLite3ViewController.h"
#import "TECHSqlite3Helper.h"

@interface TestSQLite3ViewController ()
@property(retain, nonatomic)TECHSqlite3Helper *sqlite3Helper;
@end

@implementation TestSQLite3ViewController
@synthesize insertBtn, query1Btn, query2Btn, sqlite3Helper, delBtn;

-(void)dealloc
{
    [insertBtn release];
    [query1Btn release];
    [query2Btn release];
    [sqlite3Helper release];
    [delBtn release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(TECHSqlite3Helper *)sqlite3Helper
{
    if(!sqlite3Helper)
    {
        sqlite3Helper = [[TECHSqlite3Helper alloc] init];
    }
    return sqlite3Helper;
}

- (IBAction)testInsert:(id)sender
{
    NSDictionary *record1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"yjn55",@"receiver",
                             @"yjn14",@"sender",
                            @"hello4",@"messageContent",
                             @"2013-05-06 10:12",@"recordTime",
                            @"1", @"readed",
                            nil];

    [[self sqlite3Helper] insertMessage:record1];
}

- (IBAction)testQuery1:(id)sender
{
    NSLog(@"new count:%@", [(NSDictionary *)[[self sqlite3Helper] queryNewMesasgeForUser:@"yjn1"] description]);
}

- (IBAction)testQuery2:(id)sender
{
    NSLog(@"%@", [(NSDictionary *)[[self sqlite3Helper] queryNewMesasgeForUser:@"yjn1"] description]);
}

-(IBAction)delRow:(id)sender
{
    [[self sqlite3Helper] delRow];
}

-(IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
