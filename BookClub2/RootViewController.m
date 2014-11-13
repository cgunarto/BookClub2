//
//  ViewController.m
//  BookClub2
//
//  Created by CHRISTINA GUNARTO on 11/12/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "Reader.h"
#import "FriendDetailViewController.h"

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSArray *readerWhoAreMyFriends;
@property NSManagedObjectContext *moc;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    self.moc = delegate.managedObjectContext;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = self.addButton;

    [self loadFriendsandReloadTableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.readerWhoAreMyFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];

    Reader *reader = self.readerWhoAreMyFriends[indexPath.row];
    cell.textLabel.text = reader.name;

    return cell;
}

- (void)loadFriendsandReloadTableView
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Reader class])];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortByName];

    request.predicate = [NSPredicate predicateWithFormat:@"isFriend == 'yes'"];

    self.readerWhoAreMyFriends = [[self.moc executeFetchRequest:request error:nil]mutableCopy];
    [self.tableView reloadData];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToDetail"])
    {
        FriendDetailViewController *friendDetailVC = segue.destinationViewController;
        friendDetailVC.moc = self.moc;

        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Reader *selectedReaderFriend = self.readerWhoAreMyFriends[indexPath.row];

        friendDetailVC.selectedReaderFriend = selectedReaderFriend;
    }
}





@end
