//
//  FAFriendsTableViewController.m
//  FBFriendsApp
//
//  Created by Gurminder Deep Singh on 4/27/14.
//  Copyright (c) 2014 Gurminder. All rights reserved.
//

#import "FAFriendsTableViewController.h"

#import "UserTableViewCell.h"
#import "FAUserDetailViewController.h"

#import <FacebookSDK/FacebookSDK.h>

#define SEGUE_USER_DETAILS  @"SEGUE_USER_DETAILS"
@interface FAFriendsTableViewController ()
{
    NSMutableArray *friends;
    NSString *nextURL;
    NSMutableDictionary *savedImages;
    
    BOOL isLoadingMore;
}

@end

@implementation FAFriendsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Friends";
    
    savedImages = [[NSMutableDictionary alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(refreshList) forControlEvents:UIControlEventValueChanged];
    
    [self refreshList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)refreshList
{
    [savedImages removeAllObjects];
    
    [FBRequestConnection startWithGraphPath:@"/me/friends?limit=25&fields=name,gender"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, id result,NSError *error)
     {
         
         [self.refreshControl endRefreshing];
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
             friends = result[@"data"];
             nextURL = result[@"paging"][@"next"];
             [self.tableView reloadData];
         }
     }];
}

-(void)loadMoreFriends
{
    isLoadingMore = YES;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:nextURL]
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
          if (!error)
          {
              NSError *jsonError;
              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
              
              if (!jsonError)
              {
                  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                      
                      [friends addObjectsFromArray:responseDictionary[@"data"]];
                      nextURL = responseDictionary[@"paging"][@"next"];
                      
                      [self.tableView reloadData];
                      isLoadingMore = NO;
                  }];
              }
          }
      }];
    [task resume];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_USER_DETAILS])
    {
        FAUserDetailViewController *detailViewController = segue.destinationViewController;
        
        detailViewController.userInfo = sender;
        
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return friends.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((friends.count - indexPath.row) < 10 && !isLoadingMore)
    {
        [self loadMoreFriends];
    }
    
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    
    NSDictionary *userInfo = friends[indexPath.row];
    
    cell.lblName.text = userInfo[@"name"];
    cell.lblGender.text = userInfo[@"gender"];
    
    cell.imvProfilePic.image = nil;
    
    UIImage *savedImage = savedImages[userInfo[@"id"]];
    
    if (savedImage)
    {
        cell.imvProfilePic.image = savedImage;
    }
    else
    {
        NSString *urlForProfilePicture = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", userInfo[@"id"]];
        
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
                                                      
                                                      [savedImages setObject:image forKey:[userInfo objectForKey:@"id"]];
                                                      cell.imvProfilePic.image = image;
                                                      [cell.imvProfilePic setNeedsDisplay];
                                                  }];
                                              }
                                          }];
            [task resume];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:SEGUE_USER_DETAILS sender:friends[indexPath.row]];
    
}

@end
