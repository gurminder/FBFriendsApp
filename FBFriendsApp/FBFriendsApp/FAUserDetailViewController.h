//
//  FAUserDetailViewController.h
//  FBFriendsApp
//
//  Created by Gurminder Deep Singh on 4/27/14.
//  Copyright (c) 2014 Gurminder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAUserDetailViewController : UIViewController

@property (nonatomic, strong) NSDictionary *userInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imvProfilePic;
@property (weak, nonatomic) IBOutlet UITextView *txvPostText;
- (IBAction)btnActionPostToWall:(id)sender;

@end
