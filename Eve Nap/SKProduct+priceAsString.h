//
//  SKProduct+priceAsString.h
//  eve2
//
//  Created by Daniel Pape on 03/01/2014.
//  Copyright (c) 2014 Daniel Pape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SKProduct (priceAsString)
@property (nonatomic, readonly) NSString *priceAsString;
@end
