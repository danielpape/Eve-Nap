//
//  enViewController.m
//  Eve Nap
//
//  Created by Daniel Pape on 08/12/2013.
//  Copyright (c) 2013 Daniel Pape. All rights reserved.
//

#import "enViewController.h"

@interface enViewController ()

@end

@implementation enViewController

#define IS_IPHONE_5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define kTutorialPointProductID @"com.danielpape.evenap.seasons"



int hours, minutes, seconds;
int secondsLeft;
BOOL purchased;
SKProductsRequest *productsRequest;
NSArray *validProducts;
NSString *backgroundName;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!IS_IPHONE_5) {
        NSLog(@"iPhone 5 detected");
    }
    
    napLength = (int)(27 +(self.scrollingView.center.y/7.9));
    [self formatIntroView];
    self.lengthLabel.text = [NSString stringWithFormat:@"%i mins",napLength];
    
    defaults = [[NSUserDefaults alloc]init];
    
    if ([defaults boolForKey:@"purchasedDefaults"] == YES) {
        purchased = YES;
    }
    
    if ([defaults objectForKey:@"background"] != nil) {
        NSString *backgroundString = [defaults objectForKey:@"background"];
        NSLog(@"%@",backgroundString);
        self.skyBack.image = [UIImage imageNamed:backgroundString];
        backgroundName = backgroundString;
        [defaults synchronize];
    }else{
        self.skyBack.image = [UIImage imageNamed:@"background1.png"];
        backgroundName = [NSString stringWithFormat:@"background1.png"];
        [defaults synchronize];
    }
    
    if ([[defaults objectForKey:@"background"]  isEqual: @"background1.png"]){
        self.backgroundLabel.text = @"Summer";
    }else if ([[defaults objectForKey:@"background"]  isEqual: @"background5.png"]){
        self.backgroundLabel.text = @"Autumn";
    }else if ([[defaults objectForKey:@"background"]  isEqual: @"background3.png"]){
        self.backgroundLabel.text = @"Winter";
    }else if ([[defaults objectForKey:@"background"]  isEqual: @"background6.png"]){
        self.backgroundLabel.text = @"Spring";
    }
    
    backgroundName = [NSString stringWithFormat:@"background1.png"];

    self.skyBack.image = [UIImage imageNamed:@"sky8.png"];
    
//    [self fetchAvailableProducts];

}


-(void)formatIntroView{
    _introView.backgroundColor = [UIColor clearColor];
    bgToolbar = [[UIToolbar alloc] initWithFrame:_introView.frame];
    bgToolbar.barStyle = UIBarStyleBlackTranslucent;
    [_introView.superview insertSubview:bgToolbar belowSubview:_introView];
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer
{
    if(alarmSet == YES){
        
    }else{
    
    CGPoint translation = [recognizer translationInView:self.view]; recognizer.view.center = CGPointMake(160, recognizer.view.center.y + translation.y); [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
        if (IS_IPHONE_5) {
            CGPoint maxHeight = CGPointMake(160, -168);
            CGPoint minHeight = CGPointMake(160, 262);
            
            if(self.scrollingView.center.y <= -168){
                [self.scrollingView setCenter:maxHeight];
            }
            if(self.scrollingView.center.y >= 262){
                [self.scrollingView setCenter:minHeight];
            }
        }else{
            CGPoint maxHeight = CGPointMake(160, -168);
            CGPoint minHeight = CGPointMake(160, 183);
            
            if(self.scrollingView.center.y <= -168){
                [self.scrollingView setCenter:maxHeight];
            }
            if(self.scrollingView.center.y >= 183){
                [self.scrollingView setCenter:minHeight];
            }

        }
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.welcomeLabel.alpha = 0;
    self.welcomeTExt.alpha = 0;
    [UIView commitAnimations];
    
    self.lengthLabel.text = [NSString stringWithFormat:@"%i mins",(int)(27 +(self.scrollingView.center.y/7.9))];
    [self.skyBack setCenter:CGPointMake(160,(-self.scrollingView.center.y+500))];
    
    lastSet = (int)self.scrollingView.center.y;
    napLength = (int)(27 +(self.scrollingView.center.y/7.9));
    
    NSLog(@"%i",(int)self.scrollingView.center.y);
    }
}

- (IBAction)setAlarm:(id)sender {
    alarmSet = YES;
    
    defaults = [[NSUserDefaults alloc]init];
    [defaults setBool:YES forKey:@"set"];
    [defaults synchronize];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [self.scrollingView setCenter:self.view.center];
    self.scrollImage.alpha = 0;
    self.setAlarmButton.alpha = 0;
    self.infoButton.alpha = 0;
    [self makeTimeTransparent];
    [self.lengthLabel setCenter:self.scrollingView.center];
    [self.welcomeBackLabel setCenter:self.scrollingView.center];
    [self.spinner setCenter:self.scrollingView.center];
    [UIView commitAnimations];
    
    [self setAlarm];
    //[self runSpinAnimationOnView:self.spinner duration:1 rotations:1 repeat:500];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5
                                     target:self
                                   selector:@selector(showResetButton)
                                   userInfo:nil
                                    repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(makeTimeOpaque)
                                   userInfo:nil
                                    repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(makeEveWillWakeOpaque)
                                   userInfo:nil
                                    repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(makeSpinnerOpaque)
                                   userInfo:nil
                                    repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:0.7
                                     target:self
                                   selector:@selector(countdownTimer)
                                   userInfo:nil
                                    repeats:NO];
    

    spinTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(startSpin) userInfo:nil repeats:YES];
}

-(void)showResetButton{
    [self.resetAlarmButton setCenter:CGPointMake(self.lengthLabel.center.x, self.lengthLabel.center.y + 50)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.resetAlarmButton.alpha = 1;
    [UIView commitAnimations];
}

-(void)makeTimeTransparent{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.lengthLabel.alpha = 0;
    [UIView commitAnimations];
}
-(void)makeEveWillWakeOpaque{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.eveWillWakeYouLabel.alpha = 1;
    [UIView commitAnimations];
}

-(void)makeSpinnerOpaque{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.spinner.alpha = 1;
    [UIView commitAnimations];
    self.sliderBG.image = [UIImage imageNamed:@"sliderBG001set.png"];

}

-(void)makeSpinnerTransparent{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.spinner.alpha = 0;
    [UIView commitAnimations];
}

-(void)makeTimeOpaque{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.lengthLabel.alpha = 1;
    [UIView commitAnimations];
}


- (IBAction)resetAlarm:(id)sender {
    alarmSet = NO;
    defaults = [[NSUserDefaults alloc]init];
    [defaults setBool:NO forKey:@"set"];
    [defaults synchronize];
    
    [_audioPlayer stop];
    self.eveWillWakeYouLabel.alpha = 0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [self.scrollingView setCenter:self.view.center];
    self.scrollImage.alpha = 1;
    [self makeTimeTransparent];
    [self.lengthLabel setCenter:CGPointMake(76, 490)];
    self.lengthLabel.alpha = 1;
    self.infoButton.alpha = 1;
    [self.scrollingView setCenter:CGPointMake(160, lastSet)];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.resetAlarmButton.alpha = 0;
    self.setAlarmButton.alpha = 1;
    [self makeSpinnerTransparent];
    [UIView commitAnimations];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [timer invalidate];
    [spinTimer invalidate];
    NSLog(@"%i",lastSet);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.welcomeBackLabel.alpha = 0;
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(changeTimeFormat)
                                   userInfo:nil
                                    repeats:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(makeTimeOpaque)
                                   userInfo:nil
                                    repeats:NO];
        
}

- (void) changeTimeFormat{
    self.lengthLabel.text = [NSString stringWithFormat:@"%i mins",napLength];
    self.sliderBG.image = [UIImage imageNamed:@"sliderBG001.png"];
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)updateCounter:(NSTimer *)theTimer {

    
    if(secondsLeft > 0 ){
        secondsLeft=secondsLeft-60;
        hours = secondsLeft / 3600;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft %3600) % 60;
        self.lengthLabel.text = [NSString stringWithFormat:@"%d mins", minutes];
        
    }
    else{
        [self alarm];
    }
}

-(void)countdownTimer{
    
    secondsLeft = napLength * 60;
    hours = secondsLeft / 3600;
    minutes = (secondsLeft % 3600) / 60;
    seconds = (secondsLeft %3600) % 60;
    self.lengthLabel.text = [NSString stringWithFormat:@"%d mins", minutes];
    
    UIBackgroundTaskIdentifier bgTask =0;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    
}

- (void)setAlarm{
    UILocalNotification *wakeAlarm = [[UILocalNotification alloc]init];
    wakeAlarm.fireDate = [[NSDate date]dateByAddingTimeInterval:napLength*60];
    wakeAlarm.alertBody = @"Timer's up";
    wakeAlarm.soundName = @"eveAlarm4.wav";
    [wakeAlarm setHasAction:YES];
    [[UIApplication sharedApplication] scheduleLocalNotification:wakeAlarm];
    
    alarmTimer = [NSTimer scheduledTimerWithTimeInterval:napLength*60 target:self selector:@selector(alarm) userInfo:nil repeats:YES];
}

- (void) alarm{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.welcomeBackLabel.alpha = 1;
    self.lengthLabel.alpha = 0;
    self.eveWillWakeYouLabel.alpha = 0;
    
    [UIView commitAnimations];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],@"eveAlarm4.wav"]];
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    
    [_audioPlayer play];
   
    
    [self makeSpinnerTransparent];

}

-(void)makeWelcomeBackLabelOpaque{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.welcomeBackLabel.alpha = 1;
    [UIView commitAnimations];}

-(void)startSpin{
    [self runSpinAnimationOnView:self.spinner duration:1 rotations:1 repeat:5000];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)slideDownInfoView{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //CGPoint infoNewCenter = [self.infoView center];
    //infoNewCenter.x = 160;
    //infoNewCenter.y = 268;
    [self.infoView setCenter:self.view.center];
    self.infoView.alpha = 1;
    [UIView commitAnimations];

}

-(IBAction)pressInfoButton{
    CGPoint infoCenter = [self.infoView center];
    infoCenter.x = 160;
    infoCenter.y = 50;
    [self.infoView setCenter:infoCenter];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.scrollingView.alpha = 0;
    self.infoButton.alpha = 0;
    self.IAPButton.alpha = 0;
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(slideDownInfoView) userInfo:nil repeats:NO];
}

-(void)makeScrollingViewOpaque{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.scrollingView.alpha = 0.6;
    [UIView commitAnimations];
}

-(IBAction)tapReturnButton{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.infoView.alpha = 0;
    self.infoButton.alpha = 1;
    self.IAPButton.alpha = 1;
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(makeScrollingViewOpaque) userInfo:nil repeats:NO];
}

-(IBAction)pressBeginButton{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.introView.alpha = 0;
    self.introTextView.alpha = 0;
    bgToolbar.alpha=0;
    [UIView commitAnimations];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{

}

-(IBAction)tweet{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Hello @YonderApps !"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    
}

-(IBAction)website{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.evealarm.com"]];
}

- (IBAction)rate {
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/gb/app/eve-power-nap-timer/id789920975"]];
}

- (IBAction)tapIAPButton{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGPoint selectBackgroundViewCenter = [self.selectBackgroundView center];
    selectBackgroundViewCenter.y = selectBackgroundViewCenter.y-120;
    [self.selectBackgroundView setCenter:selectBackgroundViewCenter];
    [UIView commitAnimations];
}

- (IBAction)tapBackgroundReturnButton{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGPoint selectBackgroundViewCenter = [self.selectBackgroundView center];
    selectBackgroundViewCenter.y = selectBackgroundViewCenter.y+120;
    [self.selectBackgroundView setCenter:selectBackgroundViewCenter];
    [UIView commitAnimations];
}

- (IBAction) nextBackground{
    if(purchased == YES)
    {
        if([backgroundName isEqual:@"background1.png"]){
            backgroundName = @"background2.png";
            self.skyBack.image = [UIImage imageNamed:@"background2"];
            _backgroundLabel.text = @"Autumn";
            [defaults setObject:backgroundName forKey:@"background"];
            [defaults synchronize];
            NSLog(@"Background 2 set");
        }else if ([backgroundName isEqual:@"background2.png"]){
            backgroundName = @"background3.png";
            self.skyBack.image = [UIImage imageNamed:@"background3"];
            _backgroundLabel.text = @"Winter";
            [defaults setObject:backgroundName forKey:@"background"];
            [defaults synchronize];
            NSLog(@"Background 2 set");
        }else if ([backgroundName isEqual:@"background3.png"]){
            backgroundName = @"background4.png";
            self.skyBack.image = [UIImage imageNamed:@"background6"];
            _backgroundLabel.text = @"Spring";
            [defaults setObject:backgroundName forKey:@"background"];
            [defaults synchronize];
            NSLog(@"Background 3 set");
        }else if ([backgroundName isEqual:@"background4.png"]){
            backgroundName = @"background1.png";
            self.skyBack.image = [UIImage imageNamed:@"background1"];
            _backgroundLabel.text = @"Summer";
            [defaults setObject:backgroundName forKey:@"background"];
            [defaults synchronize];
            NSLog(@"Background 4 set");

        }
    }else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.IAPView.alpha = 1;
        [UIView commitAnimations];
    
    }
}

- (IBAction) prevBackground{
    if(purchased == YES){
        if([backgroundName isEqual:@"background1.png"]){
            backgroundName = @"background2.png";
            self.skyBack.image = [UIImage imageNamed:@"background6.png"];
            self.backgroundLabel.text = @"Spring";
            [defaults setObject:backgroundName forKey:@"background"];
            [defaults synchronize];
        }else if ([backgroundName isEqual:@"background2.png"]){
            backgroundName = @"background3.png";
            self.skyBack.image = [UIImage imageNamed:@"background3"];
            self.backgroundLabel.text = @"Winter";
            [defaults setObject:backgroundName forKey:@"background"];
            [defaults synchronize];
        }else if ([backgroundName isEqual:@"background3.png"]){
            backgroundName = @"background4.png";
            self.skyBack.image = [UIImage imageNamed:@"background2"];
            self.backgroundLabel.text = @"Autumn";
            [defaults setObject:backgroundName forKey:@"background"];
            [defaults synchronize];
        }else if ([backgroundName isEqual:@"background4.png"]){
            backgroundName = @"background1.png";
            self.skyBack.image = [UIImage imageNamed:@"background1"];
            self.backgroundLabel.text = @"Summer";
            [defaults setObject:backgroundName forKey:@"background"];
            [defaults synchronize];
        }
    }else{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.IAPView.alpha = 1;
        [UIView commitAnimations];
        [self fetchAvailableProducts];
        
    }
}

- (IBAction)tapIAPReturnButton{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.IAPView.alpha = 0;
    [UIView commitAnimations];
}

-(void) purchased{
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"unlocked"];
    [defaults synchronize];
}

-(void)fetchAvailableProducts{
    NSSet *productIdentifiers = [NSSet
                                 setWithObjects:kTutorialPointProductID,nil];
    productsRequest = [[SKProductsRequest alloc]
                       initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}
- (void)purchaseMyProduct:(SKProduct*)product{
    if ([self canMakePurchases]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"Purchases are disabled in your device" message:nil delegate:
                                  self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
}
-(IBAction)purchase:(id)sender{
    [self purchaseMyProduct:[validProducts objectAtIndex:0]];
    //self.purchaseButton.enabled = NO;
}

#pragma mark StoreKit Delegate

-(void)paymentQueue:(SKPaymentQueue *)queue
updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                self.activityIndicator.alpha = 1;
                [self.activityIndicator startAnimating];
                NSLog(@"Purchasing");
                break;
            case SKPaymentTransactionStatePurchased:
                if ([transaction.payment.productIdentifier
                     isEqualToString:kTutorialPointProductID]) {
                    NSLog(@"Purchased ");
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Purchase has completed succesfully" message:nil delegate:
                                              self cancelButtonTitle:@"Great!" otherButtonTitles: nil];
                    [alertView show];
                    self.activityIndicator.alpha = 0;
                    [self.activityIndicator startAnimating];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.5];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    //[self.purchaseView setCenter:CGPointMake(160, 1000)];
                    [UIView commitAnimations];
                    //[self removeButtonImages];
                    purchased = YES;
                    defaults = [[NSUserDefaults alloc]init];
                    [defaults setBool:YES forKey:@"purchasedDefaults"];
                    [defaults synchronize];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                self.activityIndicator.alpha = 0;
                [self.activityIndicator startAnimating];
                NSLog(@"Restored ");
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                //[self.purchaseView setCenter:CGPointMake(160, 1000)];
                [UIView commitAnimations];
                //[self removeButtonImages];
                purchased = YES;
                defaults = [[NSUserDefaults alloc]init];
                [defaults setBool:YES forKey:@"purchasedDefaults"];
                [defaults synchronize];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                self.activityIndicator.alpha = 0;
                [self.activityIndicator startAnimating];
                NSLog(@"Purchase failed ");
                break;
            default:
                break;
        }
    }
}

-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if (count>0) {
        validProducts = response.products;
        validProduct = [response.products objectAtIndex:0];
        if ([validProduct.productIdentifier
             isEqualToString:kTutorialPointProductID]) {
            [self.productTitleLabel setText:[NSString stringWithFormat:
                                             @"Product Title: %@",validProduct.localizedTitle]];
            self.productPriceLabel.text = [NSString stringWithFormat:@"Buy now for just %@",validProduct.priceAsString];
            [UIView commitAnimations];
        }
    } else {
        UIAlertView *tmp = [[UIAlertView alloc]
                            initWithTitle:@"Hmmm"
                            message:@"I cannot find the product in the App Store"
                            delegate:self
                            cancelButtonTitle:nil
                            otherButtonTitles:@"Ok", nil];
        [tmp show];
    }
    [self.activityIndicator stopAnimating];
}

@end
