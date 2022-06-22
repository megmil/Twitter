//
//  ComposeViewController.m
//  twitter
//
//  Created by Megan Miller on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.text = @"";
    [self.exitButton setTitle:@"" forState:UIControlStateNormal];
}

- (IBAction)didTapExitButton:(id)sender {
    NSLog(@"Dismiss Compose View Controller");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapTweetButton:(id)sender {
    NSString *textFromTextView = [self.textView text];
    [[APIManager shared]postStatusWithText:textFromTextView completion:^(Tweet *tweet, NSError *error) {
        if (error) {
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else {
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
