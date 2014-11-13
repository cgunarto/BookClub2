//
//  AddFriendsViewController.m
//  BookClub2
//
//  Created by CHRISTINA GUNARTO on 11/12/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "AppDelegate.h"
#import "Reader.h"

@interface AddFriendsViewController ()<UITableViewDataSource, UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *readersListArray;
@property NSMutableArray *friendsArray;
@property NSManagedObjectContext *moc;

@end

@implementation AddFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    self.moc = delegate.managedObjectContext;

    [self loadReaders];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.readersListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"readerCell"];
    Reader *reader = self.readersListArray[indexPath.row];

    cell.textLabel.text = reader.name;

    //check or unchecked depending on the isFriend property
    if ([reader.isFriend isEqualToString:@"yes"])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Reader *selectedReader = self.readersListArray [indexPath.row];
    if ([selectedReader.isFriend isEqualToString:@"yes"])
    {
        selectedReader.isFriend = @"no";
    }
    else
    {
        selectedReader.isFriend = @"yes";
    }

    [self.moc save:nil];
    [self.tableView reloadData];
}

- (void)loadReaders
{
    //if coredata doesn't have readers in it
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Reader"];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortByName];
    
    self.readersListArray = [[self.moc executeFetchRequest:request error:&error]mutableCopy];

    //if readersListArray is empty, populate it with Reader objects and save it to core data
    if (self.readersListArray.count == 0)
    {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"friends"
                                                         ofType:@"json"];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSData *data = [NSData dataWithContentsOfURL:url];

        self.readersListArray = [@[]mutableCopy];
        NSArray *readersFromJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

        for (NSString *name in readersFromJSON)
        {
            Reader *reader = [NSEntityDescription insertNewObjectForEntityForName:@"Reader" inManagedObjectContext:self.moc];
            reader.name = name;
            [self.readersListArray addObject:reader];
        }
        [self.moc save:nil];
    }
}


//- (void)retrieveFriends
//{
//    NSError *error;
//    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Reader"];
//    request.predicate = [NSPredicate predicateWithFormat:@"isFriend == 'yes'"];
//
//    self.friendsArray = [[self.moc executeFetchRequest:request error:&error]mutableCopy];
//}



@end























