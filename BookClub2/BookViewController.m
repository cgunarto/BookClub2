//
//  BookViewController.m
//  BookClub2
//
//  Created by CHRISTINA GUNARTO on 11/12/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "BookViewController.h"
#import "Book.h"
#import "Comment.h"

@interface BookViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addCommentButton;

@property (weak, nonatomic) NSArray *commentsArray;

@end

@implementation BookViewController

#pragma mark View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = self.addCommentButton;
    [self setBookDetail];
    [self loadComments];
}

#pragma mark Helper Method

- (void)setBookDetail
{
    self.titleLabel.text = self.selectedBook.title;
    self.authorLabel.text = self.selectedBook.author;
}

- (void)loadComments
{
    self.commentsArray = [self.selectedBook.comments allObjects];
    [self.tableView reloadData];
}

- (IBAction)onAddCommentButtonPressed:(UIBarButtonItem *)sender
{
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"Add a comment" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alertcontroller addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Add Comment Here";
     }];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Okay"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   Comment *comment = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Comment class]) inManagedObjectContext:self.moc];

                                   UITextField *textField = alertcontroller.textFields.firstObject;

                                   comment.text = textField.text;

                                   [self.selectedBook addCommentsObject:comment];
                                   [self.moc save:nil];
                                   [self dismissViewControllerAnimated:YES completion: nil];
                                   [self loadComments];

                               }];
    
    [alertcontroller addAction:okAction];

    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    [alertcontroller addAction:cancelButton];
    
    [self presentViewController:alertcontroller animated:YES completion:^{
    }];
}


#pragma mark Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookDetailCell" forIndexPath:indexPath];
    Comment *comment = self.commentsArray[indexPath.row];
    cell.textLabel.text = comment.text;

    return cell;
}

@end
