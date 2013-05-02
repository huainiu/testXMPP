//
//  LoginViewController.h
//  testXMPP
//
//  Created by yangjiannan on 4/27/13.
//  Copyright (c) 2013 techrare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPReconnect.h"

extern NSString *const kXMPPmyJID;
extern NSString *const kXMPPmyPassword;

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *userNameTxt;
@property (retain, nonatomic) IBOutlet UITextField *passwdTxt;

-(IBAction)login:(id)sender;
@end
