//
//  TabBarController.m
//  twitter
//
//  Created by Megan Miller on 6/24/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TabBarController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "APIManager.h"
#import "ComposeViewController.h"

@interface TabBarController () <ComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *composeButton;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.composeButton setTitle:@"" forState:UIControlStateNormal];
}

// EFFECTS: Returns to login screen.
- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"composeSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeVC = (ComposeViewController*)navigationController.topViewController;
        composeVC.isReply = NO;
        composeVC.delegate = self;
    }
}

@end
