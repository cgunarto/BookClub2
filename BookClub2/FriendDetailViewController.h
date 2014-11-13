//
//  FriendDetailViewController.h
//  BookClub2
//
//  Created by CHRISTINA GUNARTO on 11/12/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class Reader;

@interface FriendDetailViewController : UIViewController
@property Reader *selectedReaderFriend;
@property NSManagedObjectContext *moc;


@end
