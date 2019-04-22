//
//  AddViewController.m
//  NameList
//
//  Created by Yi Zhang on 2019/4/21.
//  Copyright © 2019 Yi Zhang. All rights reserved.
//

#import "AddViewController.h"
#import "SQLManager.h"
#import "StudentModel.h"

@interface AddViewController ()

@property (weak, nonatomic) IBOutlet UITextField *idNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"AddUser"]) {
        StudentModel *model = [[StudentModel alloc] init];
        model.idNum = self.idNumTextField.text;
        model.name = self.nameTextField.text;
        [[SQLManager shared] insert:model];
    }
}

@end
