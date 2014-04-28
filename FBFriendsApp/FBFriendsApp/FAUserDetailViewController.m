//
//  FAUserDetailViewController.m
//  FBFriendsApp
//
//  Created by Gurminder Deep Singh on 4/27/14.
//  Copyright (c) 2014 Gurminder. All rights reserved.
//

#import "FAUserDetailViewController.h"

#import <FacebookSDK/FacebookSDK.h>

@interface FAUserDetailViewController ()

@end

@implementation FAUserDetailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = APP_COLOR;
    
    NSString *urlForProfilePicture = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", self.userInfo[@"id"]];
    
    if (urlForProfilePicture.length)
    {
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];;
        
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:urlForProfilePicture]
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (!error)
          {
              UIImage *image = [[UIImage alloc] initWithData:data];
              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                  self.imvProfilePic.image = image;
                  
              }];
          }
      }];
        [task resume];
    }
    
    self.imvProfilePic.contentMode = UIViewContentModeScaleAspectFill;
    self.imvProfilePic.clipsToBounds = YES;
    self.imvProfilePic.layer.cornerRadius = self.imvProfilePic.frame.size.height/2.0;
    
    UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320.0, 44.0)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneButtonClicked)];
    
    accessoryView.items = @[space, doneButton];
    
    self.txvPostText.inputAccessoryView = accessoryView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnActionPostToWall:(id)sender
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.txvPostText.text, @"name",
                                   @"This is a Test post From FriendsApp", @"description",
                                   @"www.gurminderrandhawa.com", @"link",
                                   self.userInfo[@"id"], @"to", nil];
    
    
    [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"]
                                       defaultAudience:FBSessionDefaultAudienceEveryone
                                          allowLoginUI:YES
                                     completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
     {
         if (error)
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:error.localizedDescription
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
             [alertView show];
             return;
         }
         
         [FBWebDialogs presentFeedDialogModallyWithSession:session
                                                parameters:params
                                                   handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error)
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
              else
              {
                  if (result == FBWebDialogResultDialogNotCompleted)
                  {
                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                          message:@"User canceled story publishing"
                                                                         delegate:nil
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                      [alertView show];
                  }
                  else
                  {
                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                          message:@"Story Published"
                                                                         delegate:nil
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                      [alertView show];
                  }
              }
          }];
     }];
}


-(void)doneButtonClicked
{
    [self.txvPostText resignFirstResponder];
    
}
@end
