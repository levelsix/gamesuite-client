//
//  IAPHelper.m
//  Icon-Blitz
//
//  Created by Danny on 5/14/13.
//
//

#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";
NSString *const IAPHelperProductCanceledNotification = @"IAPHelperProductCanceledNotification";

@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@end

@implementation IAPHelper {
  SKProductsRequest * _productsRequest;
  RequestProductsCompletionHandler _completionHandler;
  NSSet * _productIdentifiers;
  NSMutableSet * _purchasedProductIdentifiers;
}

- (void)restoreCompletedTransactions {
  [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
  if ((self = [super init])) {
    //store product Identifiers
    _productIdentifiers = productIdentifiers;
    
    //check for previously purchased products
    _purchasedProductIdentifiers = [NSMutableSet set];
    for (NSString *productIdentifier in _productIdentifiers) {
      BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
      if (productPurchased) {
        [_purchasedProductIdentifiers addObject:productIdentifiers];
      }
    }
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
  }
  return self;
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
  return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
  NSLog(@"Buying %@ ...", product.productIdentifier);
  
  SKPayment *payment = [SKPayment paymentWithProduct:product];
  [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
  _completionHandler = [completionHandler copy];
  _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
  _productsRequest.delegate = self;
  [_productsRequest start];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
  for (SKPaymentTransaction * transaction in transactions) {
    switch (transaction.transactionState)
    {
      case SKPaymentTransactionStatePurchased:
        [self completeTransaction:transaction];
        break;
      case SKPaymentTransactionStateFailed:
        [self failedTransaction:transaction];
        break;
      case SKPaymentTransactionStateRestored:
        [self restoreTransaction:transaction];
      default:
        break;
    }
  };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
  NSLog(@"completeTransaction...");
  
  [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
  NSLog(@"restoreTransaction...");
  
  [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
  
  NSLog(@"failedTransaction...");
  [self provideContentForFailed:transaction.payment.productIdentifier];
  
  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)provideContentForFailed:(NSString *)productIdentifier {
  [_purchasedProductIdentifiers addObject:productIdentifier];
  [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductCanceledNotification object:productIdentifier userInfo:nil];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
  
  [_purchasedProductIdentifiers addObject:productIdentifier];
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
  
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
  _productsRequest = nil;
  
  NSArray *skProducts = response.products;
  _completionHandler(YES, skProducts);
  _completionHandler = nil;
  
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
  
  _productsRequest = nil;
  
  _completionHandler(NO, nil);
  _completionHandler = nil;
  
}

@end
