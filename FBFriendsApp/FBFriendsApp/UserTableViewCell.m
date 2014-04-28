//
//  UserTableViewCell.m
//  FBFriendsApp
//
//  Created by Gurminder Deep Singh on 4/27/14.
//  Copyright (c) 2014 Gurminder. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    
    self.imvProfilePic.contentMode = UIViewContentModeScaleAspectFill;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imvProfilePic.clipsToBounds = YES;
    self.imvProfilePic.layer.cornerRadius = self.imvProfilePic.frame.size.height/2.0;
    
}


@end