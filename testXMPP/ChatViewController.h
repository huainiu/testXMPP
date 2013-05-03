//
//  ChatViewController.h
//  testXMPP
//
//  Created by yangjiannan on 4/23/13.
//  Copyright (c) 2013 techrare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property(retain, nonatomic)IBOutlet UITableView *chatTableView;
@property (retain, nonatomic) IBOutlet UITextField *msgText;
@property (retain, nonatomic) IBOutlet UIButton *sendMsgBtn;

-(IBAction)sendMsgAction:(id)sender;
@end
