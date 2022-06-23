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

// if reply, send request as a reply

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.delegate = self;
    
    self.textView.text = @"";
    self.characterCount = 0;
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.text = @"Write tweet";
    if (self.isReply) {
        self.characterCount = self.replyTweet.user.screenName.length + 2; // add "@screen_name " to character count
        self.textView.text = [NSString stringWithFormat:@"Reply to tweet"];
    }
    self.characterCountLabel.text = [NSString stringWithFormat:@"Character count: %d", self.characterCount];
    [self.exitButton setTitle:@"" forState:UIControlStateNormal];
}

- (IBAction)didTapExitButton:(id)sender {
    NSLog(@"Dismiss Compose View Controller");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapTweetButton:(id)sender {
    if (self.isReply) {
        [self replyToTweetWithID:self.replyTweet.idStr];
    } else {
        [self postTweet];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    // if reply, account for "@screen_name "
    self.characterCount = [self.textView text].length;
    if (self.isReply) {
        self.characterCount += (self.replyTweet.user.screenName.length + 2);
    }
    self.characterCountLabel.text = [NSString stringWithFormat:@"Character count: %d", self.characterCount];
    
    // if character limit is exceeded, change text color to red
    if (self.characterCount > 280) {
        [self.characterCountLabel setTextColor:[UIColor redColor]];
    }
    else {
        [self.characterCountLabel setTextColor:[UIColor blackColor]];
    }
    
    // configure placeholder text
    if (self.isReply) {
        if ([self.textView text].length == self.replyTweet.user.screenName.length + 2) {
            self.textView.text = [NSString stringWithFormat:@"Reply to tweet"];
            self.textView.textColor = [UIColor lightGrayColor];
            [self.textView resignFirstResponder];
        }
    } else if ([self.textView text].length == 0) {
        self.textView.text = @"Write tweet";
        self.textView.textColor = [UIColor lightGrayColor];
        [self.textView resignFirstResponder];
    } else {
        self.textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.textView.textColor == UIColor.lightGrayColor) {
        textView.text = nil;
        textView.textColor = UIColor.blackColor;
    }
}

- (void)postTweet {
    NSString *textToTweet = [self.textView text];
    [[APIManager shared]postStatusWithText:textToTweet completion:^(Tweet *tweet, NSError *error) {
        if (error) {
            NSLog(@"Error composing tweet: %@", error.localizedDescription);
        }
        else {
            [self.delegate didTweet:tweet];
            NSLog(@"Compose tweet Success!");
        }
    }];
}

- (void)replyToTweetWithID:(NSString *)replyTweetID {
    NSString *textToTweet = [NSString stringWithFormat:@"@%@ %@",
                             self.replyTweet.user.screenName, [self.textView text]];
    [[APIManager shared] postStatusWithText:textToTweet inReplyToStatusID:replyTweetID completion:^(Tweet *tweet, NSError *error) {
        if (error) {
            NSLog(@"Error replying to tweet: %@", error.localizedDescription);
        }
        else {
            NSLog(@"Reply to tweet Success!");
        }
    }];
}

@end
