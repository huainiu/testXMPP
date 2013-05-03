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

@interface ChatView ()
@property(retain, nonatomic)UIScrollView *chatScroller;
@end
float contentSizeHeight=0;
@implementation ChatView
@synthesize chatScroller, messageText, sendBtn;

-(void)dealloc
{
    [chatScroller release];
    [messageText release];
    [sendBtn release];
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
}


-(void)viewWillAppear:(BOOL)animated
{
    contentSizeHeight = 0; 
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
    [self addPopuDialogForSelf];
    [self addPopuDialog];
    
    [self.chatScroller setContentSize:CGSizeMake(self.chatScroller.frame.size.width, contentSizeHeight + 50)];
    
    [self.chatScroller setContentSize:CGSizeMake(self.chatScroller.frame.size.width, contentSizeHeight)];
    NSLog(@"contentSize.height:%f", self.chatScroller.contentSize.height);
    NSLog(@"self.chatScroller.frame.size.height:%f", self.chatScroller.frame.size.height);
    
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
-(void)addPopuDialogForSelf
{
    
    UIView *dialogItemView = [[UIView alloc] initWithFrame:CGRectMake(0.0, contentSizeHeight, 320, 80)];
    
    NSDictionary *config = [NSDictionary dictionaryWithObjectsAndKeys:@"3", @"side", @"1", @"position",  nil];
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
-(void)addPopuDialog
{
    
    UIView *dialogItemView = [[UIView alloc] initWithFrame:CGRectMake(0.0, contentSizeHeight, 320, 80)];
    
    NSDictionary *config = [NSDictionary dictionaryWithObjectsAndKeys:@"2", @"side", @"1", @"position",  nil];
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
    bubble.label.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor iLorem ipsum Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor iLorem ipsum";
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
    bubble.drawableColor = [UIColor yellowColor];
    bubble.borderColor = [UIColor redColor];
    // Demonstrate how a completion block works
    void (^completion)(void) = ^{
        [bubble setPosition:0.0f animated:YES];
    };
    [bubble setCompletionBlock:completion forAnimationKey:kKBPopupAnimationPopIn];
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
    
    [UIView commitAnimations];
}



@end
