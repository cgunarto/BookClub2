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

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property NSArray *readerWhoAreMyFriends;
@property NSManagedObjectContext *moc;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"WELCOME TO BOOK CLUB"
                                                                   message:@"First rule: You do not talk about book club!"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];


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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)reader.books.count];

    //set the number of recommended books
    reader.numberOfRecommendedBooks = [NSNumber numberWithInteger:reader.books.count];
    [self.moc save:nil];

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

- (IBAction)onSortButtonPressed:(UIBarButtonItem *)sender
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Reader class])];
    NSSortDescriptor *sortByBooks = [[NSSortDescriptor alloc] initWithKey:@"numberOfRecommendedBooks" ascending:NO selector:@selector(localizedStandardCompare:)];
    request.sortDescriptors = @[sortByBooks];

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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Reader class])];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortByName];

    request.predicate = [NSPredicate predicateWithFormat:@"(isFriend == 'yes') AND (name CONTAINS[cd] %@)", searchText];
    self.readerWhoAreMyFriends = [[self.moc executeFetchRequest:request error:nil]mutableCopy];
    [self.tableView reloadData];

}




@end
