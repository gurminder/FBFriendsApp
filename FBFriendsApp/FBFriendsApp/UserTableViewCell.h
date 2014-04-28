//
//  UserTableViewCell.h
//  FBFriendsApp
//
//  Created by Gurminder Deep Singh on 4/27/14.
//  Copyright (c) 2014 Gurminder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imvProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;

@end