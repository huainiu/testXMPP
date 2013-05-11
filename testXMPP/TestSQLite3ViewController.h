//
//  TestSQLite3ViewController.h
//  testXMPP
//
//  Created by yangjiannan on 5/6/13.
//  Copyright (c) 2013 techrare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestSQLite3ViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *insertBtn;
@property (retain, nonatomic) IBOutlet UIButton *query1Btn;
@property (retain, nonatomic) IBOutlet UIButton *query2Btn;
@property (retain, nonatomic) IBOutlet UIButton *delBtn;

- (IBAction)testInsert:(id)sender;
- (IBAction)testQuery1:(id)sender;
- (IBAction)testQuery2:(id)sender;
- (IBAction)delRow:(id)sender;
- (IBAction)close:(id)sender;


@end
