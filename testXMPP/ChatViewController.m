//
//  ChatViewController.m
//  testXMPP
//
//  Created by yangjiannan on 4/23/13.
//  Copyright (c) 2013 techrare. All rights reserved.
//

#import "ChatViewController.h"
#import "KBPopupBubbleView.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize chatTableView, msgText, sendMsgBtn;

-(void)dealloc
{
    [chatTableView release];
    [msgText release];
    [sendMsgBtn release];
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidAppear:)
                                                 name:UIKeyboardDidShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidisAppear:)
                                                 name:UIKeyboardDidHideNotification
                                               object:self.view.window];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark -- outletaction

// send message
-(IBAction)sendMsgAction:(id)sender
{
    
}
-(void)keyboardDidAppear:(id)sender
{
    NSLog(@"KEYBORD");
    [self animateTextField:self.msgText up:YES];
}
-(void)keyboardDidisAppear:(id)sender
{
    NSLog(@"KEYBORD disappear");
    [self animateTextField:self.msgText up:NO];
}

#pragma mark -- 
#pragma mark -- UITableViewController datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID] autorelease];
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
    return cell;
}

#pragma mark --
#pragma mark -- UITableViewController delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -- 
#pragma mark -- textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}


#pragma mark -- 
#pragma mark -- untils method
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    float movementDistance = 0.0; // tweak as needed
    const float movementDuration = 0.2f; // tweak as needed
    float inputViewHeight =  textField.inputView.frame.size.height;//self.customInputView.frame.size.height;
    float keyBoradHeight = self.view.frame.size.height - 220;
    float textFieldTop = textField.frame.origin.y  + textField.frame.size.height;
    
    if(textFieldTop>keyBoradHeight)
    {
        movementDistance = textFieldTop  - keyBoradHeight +10;
    }
    
    // if(movementDistance)
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


@end
