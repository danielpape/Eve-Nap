//
//  SKProduct+priceAsString.m
//  eve2
//
//  Created by Daniel Pape on 03/01/2014.
//  Copyright (c) 2014 Daniel Pape. All rights reserved.
//

#import "SKProduct+priceAsString.h"

@implementation SKProduct (priceAsString)

- (NSString *) priceAsString
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[self priceLocale]];
    
    NSString *str = [formatter stringFromNumber:[self price]];
    return str;
}

@end
