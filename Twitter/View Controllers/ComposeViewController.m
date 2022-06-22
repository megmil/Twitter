//
//  ComposeViewController.m
//  twitter
//
//  Created by Megan Miller on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (nonatomic) int characterCount;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.delegate = self;
    self.textView.text = @"";
    self.characterCount = 0;
    self.characterCountLabel.text = [NSString stringWithFormat:@"Character count: %d", self.characterCount];
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

- (void)textViewDidChange:(UITextView *)textView {
    self.characterCount = [[self.textView text] length];
    self.characterCountLabel.text = [NSString stringWithFormat:@"Character count: %d", self.characterCount];
    
    if (self.characterCount > 280) {
        [self.characterCountLabel setTextColor:[UIColor redColor]];
    }
    else {
        [self.characterCountLabel setTextColor:[UIColor blackColor]];
    }
}

@end
