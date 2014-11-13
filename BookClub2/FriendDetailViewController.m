//
//  FriendDetailViewController.m
//  BookClub2
//
//  Created by CHRISTINA GUNARTO on 11/12/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "Reader.h"
#import "Book.h"

@interface FriendDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property NSArray *booksArray;

@end

@implementation FriendDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = self.addButton;
    self.nameLabel.text = self.selectedReaderFriend.name;
    [self loadBooks];
}

- (IBAction)onAddButtonTapped:(UIBarButtonItem *)sender
{
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"Add a book" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alertcontroller addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Book Title";
     }];

    [alertcontroller addTextFieldWithConfigurationHandler:^(UITextField *authorTextField)
     {
         authorTextField.placeholder = @"Book Author";
     }];

    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Okay"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   Book *book = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Book class]) inManagedObjectContext:self.moc];

                                   UITextField *textField = alertcontroller.textFields.firstObject;
                                   UITextField *authorTextField = alertcontroller.textFields.lastObject;

                                   book.title = textField.text;
                                   book.author = authorTextField.text;

                                   if (![self.selectedReaderFriend.books containsObject:book])
                                   {
                                       [self.selectedReaderFriend addBooksObject:book];
                                   }

                                   [self.moc save:nil];
                                   [self dismissViewControllerAnimated:YES completion: nil];
                                   [self loadBooks];
                               }];

    [alertcontroller addAction:okAction];

    [self presentViewController:alertcontroller animated:YES completion:^{
    }];
}

#pragma mark Table View Delegate Methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.booksArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookCell" forIndexPath:indexPath];
    Book *book = self.booksArray[indexPath.row];
    cell.textLabel.text = book.title;
    cell.detailTextLabel.text = book.author;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Suggested books";
}

- (void)loadBooks
{
    self.booksArray = [self.selectedReaderFriend.books allObjects];
    [self.tableView reloadData];
}

@end
