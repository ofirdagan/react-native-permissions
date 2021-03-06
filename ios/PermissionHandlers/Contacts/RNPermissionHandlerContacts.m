#import "RNPermissionHandlerContacts.h"

@import Contacts;

@implementation RNPermissionHandlerContacts

+ (NSString * _Nonnull)uniqueRequestingId {
  return @"contacts";
}

+ (NSArray<NSString *> *)usageDescriptionKeys {
  return @[@"NSContactsUsageDescription"];
}

- (void)checkWithResolver:(void (^ _Nonnull)(RNPermissionStatus))resolve
                 rejecter:(void (__unused ^ _Nonnull)(NSError * _Nonnull))reject {
  switch ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]) {
    case CNAuthorizationStatusNotDetermined:
      return resolve(RNPermissionStatusNotDetermined);
    case CNAuthorizationStatusRestricted:
      return resolve(RNPermissionStatusRestricted);
    case CNAuthorizationStatusDenied:
      return resolve(RNPermissionStatusDenied);
    case CNAuthorizationStatusAuthorized:
      return resolve(RNPermissionStatusAuthorized);
  }
}

- (void)requestWithResolver:(void (^ _Nonnull)(RNPermissionStatus))resolve
                   rejecter:(void (^ _Nonnull)(NSError * _Nonnull))reject
                    options:(__unused NSDictionary * _Nullable)options {
  [[CNContactStore new] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(__unused BOOL granted, NSError * _Nullable error) {
    if (error != nil && error.code != 100) {
      reject(error);
    } else {
      [self checkWithResolver:resolve rejecter:reject];
    }
  }];
}

@end
