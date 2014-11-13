//
//  FriendDetailViewController.m
//  BookClub2
//
//  Created by CHRISTINA GUNARTO on 11/12/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "Reader.h"

@interface FriendDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FriendDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameLabel.text = self.selectedReaderFriend.name;
}



@end
