//
//  enViewController.h
//  Eve Nap
//
//  Created by Daniel Pape on 08/12/2013.
//  Copyright (c) 2013 Daniel Pape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "enAppDelegate.h"
#import <Twitter/Twitter.h>
#import <StoreKit/StoreKit.h>
#import "SKProduct+priceAsString.h"

@interface enViewController : UIViewController<
SKProductsRequestDelegate,SKPaymentTransactionObserver>{
    int napLength;
    int lastSet;
    int degrees;
    BOOL continueSpinning;
    NSTimer *timer;
    NSTimer *spinTimer;
    NSTimer *alarmTimer;
    BOOL alarmSet;
    UIToolbar *bgToolbar;
    NSUserDefaults *defaults;
}
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UIView *scrollingView;
@property (weak, nonatomic) IBOutlet UIButton *setAlarmButton;
@property (weak, nonatomic) IBOutlet UIImageView *scrollImage;
@property (weak, nonatomic) IBOutlet UIButton *resetAlarmButton;
@property (weak, nonatomic) IBOutlet UIImageView *skyBack;
@property (weak, nonatomic) IBOutlet UIImageView *spinner;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UITextView *welcomeTExt;
@property (weak, nonatomic) IBOutlet UILabel *welcomeBackLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIImageView *sliderBG;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIView *introView;
@property (weak, nonatomic) IBOutlet UIView *introTextView;
@property (weak, nonatomic) IBOutlet UILabel *eveWillWakeYouLabel;
@property (weak, nonatomic) IBOutlet UIView *IAPView;
@property (weak, nonatomic) IBOutlet UIView *selectBackgroundView;
@property (strong, nonatomic) IBOutlet UILabel *backgroundLabel;
@property (weak, nonatomic) IBOutlet UIButton *IAPButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;


- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
- (IBAction)setAlarm:(id)sender;
- (IBAction)resetAlarm:(id)sender;
- (void)showResetButton;
- (void)updateCounter:(NSTimer *)theTimer;
- (void)countdownTimer;
- (IBAction)pressInfoButton;
- (IBAction)tapReturnButton;
- (IBAction)pressBeginButton;
- (IBAction)tweet;
- (IBAction)website;
- (IBAction)tapIAPButton;
- (IBAction)tapBackgroundReturnButton;
- (IBAction)nextBackground;
- (IBAction)prevBackground;
- (IBAction)tapIAPReturnButton;
-(IBAction)purchase:(id)sender;


@end
