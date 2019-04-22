//
//  HomeViewController.m
//  NameList
//
//  Created by Yi Zhang on 2019/4/21.
//  Copyright © 2019 Yi Zhang. All rights reserved.
//

#import "HomeViewController.h"
#import "StudentModel.h"
#import "SQLManager.h"

@interface HomeViewController ()
@property (strong, nonatomic) NSMutableArray *studentArray;
@end

@implementation HomeViewController

#define HomeCellIdentifier (@"StudentCell")

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.studentArray = [[NSMutableArray alloc] init];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _studentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeCellIdentifier forIndexPath:indexPath];
    
    if (self.studentArray.count > 0) {
        StudentModel *model = [self.studentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = model.idNum;
        cell.detailTextLabel.text = model.name;
    }
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (IBAction)addUserDone:(UIStoryboardSegue *)sender
{
    StudentModel *model = [[StudentModel alloc] init];
    model.idNum = @"100";
    StudentModel *result = [[SQLManager shared] searchwithIdNum:model];
    [_studentArray addObject:result];
    [self.tableView reloadData];
}

@end
