//
//  FAViewController.m
//  FBFriendsApp
//
//  Created by Gurminder Deep Singh on 4/27/14.
//  Copyright (c) 2014 Gurminder. All rights reserved.
//

#import "FAViewController.h"

#import <FacebookSDK/FacebookSDK.h>

@implementation FAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = APP_COLOR;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnActionLogin:(id)sender
{
    if (!FBSession.activeSession.isOpen)
    {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"user_friends"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error)
         {
             if (error)
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                     message:error.localizedDescription
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                 [alertView show];
             }
             else if (session.isOpen)
             {
                 [self performSegueWithIdentifier:@"SEGUE_SHOW_FRIENDS" sender:nil];
             }
         }];
        return;
    }
}




@end
