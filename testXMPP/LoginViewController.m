//
//  LoginViewController.m
//  testXMPP
//
//  Created by yangjiannan on 4/27/13.
//  Copyright (c) 2013 techrare. All rights reserved.
//

#import "LoginViewController.h"
#import "Toast+UIView.h"

NSString *const kXMPPmyJID = @"kXMPPmyJID";
NSString *const kXMPPmyPassword = @"kXMPPmyPassword";

@interface LoginViewController ()
@property(retain, nonatomic) XMPPStream *xmppStream;
//@property(retain, nonatomic)XMPPRe
@end

@implementation LoginViewController
@synthesize userNameTxt, passwdTxt, xmppStream;


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

#pragma mark 
#pragma mark -- uitextfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag==1)
    {
        [self login:nil];
    }
    return YES;
}
#pragma mark --
#pragma mark -- jabber server login
-(IBAction)login:(id)sender
{
    
    [self setField:userNameTxt forKey:kXMPPmyJID];
    [self setField:passwdTxt forKey:kXMPPmyPassword];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setField:(UITextField *)field forKey:(NSString *)key
{
    if (field.text != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:field.text forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userNameTxt resignFirstResponder];
    [self.passwdTxt resignFirstResponder];
}



@end
