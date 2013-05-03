//
//  ChatView.h
//  testXMPP
//
//  Created by yangjiannan on 5/3/13.
//  Copyright (c) 2013 techrare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatView : UIViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *messageText;
@property (retain, nonatomic) IBOutlet UIButton *sendBtn;

-(IBAction)sendMessage:(id)sender;
@end
