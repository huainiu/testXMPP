//
//  ChatView.m
//  testXMPP
//
//  Created by yangjiannan on 5/3/13.
//  Copyright (c) 2013 techrare. All rights reserved.
//

#import "ChatView.h"
#import "KBPopupBubbleView.h"
#import <QuartzCore/QuartzCore.h>
#import "XMPPMessage.h"

@interface ChatView ()
@property(retain, nonatomic)UIScrollView *chatScroller;
@end
float contentSizeHeight=0;
float zoomSize = 216;
@implementation ChatView
@synthesize chatScroller, messageText, sendBtn, userInfo, iOSXMPPAppDelegate;


#pragma mark --
#pragma mark -- Viewcontroller Delegate
-(void)dealloc
{
    [chatScroller release];
    [messageText release];
    [sendBtn release];
    [userInfo release];
    [iOSXMPPAppDelegate release];
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
    if(userInfo)
    {
        self.title = userInfo.displayName;
    }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSString *reciveTextMessage = [change objectForKey:@"new"];
    if(reciveTextMessage)
    {
        [self addPopuDialog:reciveTextMessage];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
        contentSizeHeight = 0;
    if(iOSXMPPAppDelegate)
    {
        [self addObserver:self forKeyPath:@"iOSXMPPAppDelegate.textMessage" options:NSKeyValueObservingOptionNew context:nil];
    }

}

-(void)viewWillDisappear:(BOOL)animated
{

    [self removeObserver:self forKeyPath:@"iOSXMPPAppDelegate.textMessage"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --
#pragma mark -- textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextFieldUp:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.messageText resignFirstResponder];
    [self animateTextFieldUp:NO];
    return YES;
}


#pragma mark --
#pragma mark -- action mehtod

-(IBAction)sendMessage:(id)sender
{
    
    if(iOSXMPPAppDelegate)
    {
        NSString *messageContent = self.messageText.text;
        if(messageContent!=nil &&![messageContent isEqualToString:@""])
        {
            //發送消息
            NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
            [body setStringValue:messageContent];
            
            NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
            [message addAttributeWithName:@"type" stringValue:@"chat"];
            [message addAttributeWithName:@"to" stringValue:[userInfo.jid full]];
            [message addChild:body];
            
            [self.iOSXMPPAppDelegate.xmppStream sendElement:message];
    //        iOSXMPPAppDelegate.xmppStream
            
            
            // 在對話介面添加對話氣泡
            [self addPopuDialogForSelf:messageContent];
            //[self addPopuDialog];
            
            
            //清空編輯消息文本框
            self.messageText.text = @"";
        }
    }
    
    
    
}


#pragma mark -- 
#pragma mark -- properties method
-(UIScrollView *)chatScroller
{
    if (!chatScroller) {
        chatScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 370)];
        
        chatScroller.pagingEnabled = YES;
        [self.view sendSubviewToBack:chatScroller];
        [self.view addSubview:chatScroller];
    }
    return chatScroller;
}

#pragma mark ---
#pragma mark --- 對話氣泡
-(void)addPopuDialogForSelf:(NSString *)textMessage
{
    
    UIView *dialogItemView = [[UIView alloc] initWithFrame:CGRectMake(0.0, contentSizeHeight, 320, 80)];
    
    NSDictionary *config = [NSDictionary dictionaryWithObjectsAndKeys:@"3", @"side", @"1", @"position",@"self", @"object", textMessage, @"message",  nil];
    //對話內容
    KBPopupBubbleView *bubble = [[KBPopupBubbleView alloc] initWithFrame:CGRectMake(20.0, 0.0, 250.00, 80)];
    [self configure:bubble config:config];
    
    
    //頭像
    UIImageView *photoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defaultPerson"]];
    [photoImage setFrame:CGRectMake(275, 10, 35.0, 35.0)];
    photoImage.layer.cornerRadius = 3;
    photoImage.clipsToBounds = YES;
    
    [dialogItemView addSubview:photoImage];
    [dialogItemView addSubview:bubble];
    //加入到scrollView
    [self.chatScroller addSubview:dialogItemView];
    
    contentSizeHeight = contentSizeHeight + 80;
    NSLog(@"contentSizeHeight:%f", contentSizeHeight);
}
-(void)addPopuDialog:(NSString *)textMessage
{
    
    UIView *dialogItemView = [[UIView alloc] initWithFrame:CGRectMake(0.0, contentSizeHeight, 320, 80)];
    
    NSDictionary *config = [NSDictionary dictionaryWithObjectsAndKeys:@"2", @"side", @"1", @"position",@"other",@"object",textMessage, @"message", nil];
    //對話內容
    KBPopupBubbleView *bubble = [[KBPopupBubbleView alloc] initWithFrame:CGRectMake(50.0, 0.0, 250.00, 80)];
    [self configure:bubble config:config];
    
    
    //頭像
    UIImageView *photoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defaultPerson"]];
    [photoImage setFrame:CGRectMake(10, 10, 35.0, 35.0)];
    photoImage.layer.cornerRadius = 3;
    photoImage.clipsToBounds = YES;
    
    [dialogItemView addSubview:photoImage];
    [dialogItemView addSubview:bubble];
    //加入到scrollView
    [self.chatScroller addSubview:dialogItemView];
    
    contentSizeHeight = contentSizeHeight + 80;
    NSLog(@"contentSizeHeight:%f", contentSizeHeight);
}

#pragma mark -- 
#pragma mark -- 配置對話氣泡
- (void)configure:(KBPopupBubbleView *)bubble config:(NSDictionary *)config {

    // Text
    bubble.label.text = [config objectForKey:@"message"];
    bubble.label.textColor = [UIColor blackColor];
    bubble.label.font = [UIFont boldSystemFontOfSize:13.0f];
    //bubble.delegate = self;
    
    // Shadows
    bubble.useDropShadow = YES;
    
    // Corners
    bubble.useRoundedCorners = YES;
    
    // Borders
    bubble.useBorders = YES;
    
    // Draggable
    bubble.draggable = NO;
    
    NSInteger side = [[NSString stringWithFormat:@"%@",[config objectForKey:@"side"]] integerValue];
    // Side
    switch (side) {
        case 0:
            [bubble setSide:kKBPopupPointerSideTop];
            break;
        case 1:
            [bubble setSide:kKBPopupPointerSideBottom];
            break;
        case 2:
            [bubble setSide:kKBPopupPointerSideLeft];
            break;
        case 3:
            [bubble setSide:kKBPopupPointerSideRight];
            break;
    }
    
    
    // Position
    NSInteger position = [[NSString stringWithFormat:@"%@",[config objectForKey:@"position"]] integerValue];
    switch (position) {
        case 0:
            [bubble setPosition:kKBPopupPointerPositionLeft];
            break;
        case 1:
            [bubble setPosition:kKBPopupPointerPositionMiddle];
            break;
        case 2:
            [bubble setPosition:kKBPopupPointerPositionRight];
            break;
    }
    
    //    // Color
    //    if ( _useColorsRotate ) {
    //        _colorIndex++;
    //        if ( _colorIndex >= _colors.count ) {
    //            _colorIndex = 0;
    //        }
    //
    //    }
    // bubble.drawableColor = [_colors objectAtIndex:_colorIndex];
    //bubble.borderColor = [_colorsBorder objectAtIndex:_colorIndex];
    UIColor *color ;
    NSString *object = [config objectForKey:@"object"];
    if([object isEqualToString:@"self"])
    {
        color = [UIColor colorWithRed:216 green:216 blue:216 alpha:1];
    }else
    {
        color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chatPupo.png"]];
    }
    bubble.drawableColor = color;
    bubble.borderColor = color;
    // Demonstrate how a completion block works
    void (^completion)(void) = ^{
        [bubble setPosition:0.0f animated:YES];
    };
    [bubble setCompletionBlock:completion forAnimationKey:kKBPopupAnimationPopIn];
    [self scrollToButtom];
}


#pragma mark --
#pragma mark -- untils method
- (void) animateTextFieldUp:(BOOL)up
{
    //[self.chatScroller setBackgroundColor:[UIColor blackColor]];
    const float movementDuration = 0.2f; // tweak as neede
    int movement = up?-216:216;
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    CGRect scrollerFrame;
    if(up)
    {
        
        scrollerFrame = CGRectMake(0.0, zoomSize, self.chatScroller.frame.size.width, self.chatScroller.frame.size.height-zoomSize);
    }else
    {
        scrollerFrame = CGRectMake(0.0, self.chatScroller.frame.origin.y-zoomSize, self.chatScroller.frame.size.width, self.chatScroller.frame.size.height+zoomSize);
    }
    [self.chatScroller setFrame:scrollerFrame];
    [self scrollToButtom];
    
    [UIView commitAnimations];
}

-(void)scrollToButtom
{
    [self.chatScroller setContentSize:CGSizeMake(self.chatScroller.frame.size.width, contentSizeHeight+80)];
    
    if([chatScroller contentSize].height > chatScroller.frame.size.height)
    {
        CGPoint bottomOffset = CGPointMake(0, [chatScroller contentSize].height - chatScroller.frame.size.height);
        [chatScroller setContentOffset:bottomOffset animated:YES];
    }
}


@end
