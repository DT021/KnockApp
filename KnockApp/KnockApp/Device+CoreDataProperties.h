//
//  Device+CoreDataProperties.h
//  KnockApp
//
//  Created by Fangzhou Sun on 11/29/15.
//  Copyright © 2015 Fangzhou Sun. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Device.h"

NS_ASSUME_NONNULL_BEGIN

@interface Device (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *token;

@end

NS_ASSUME_NONNULL_END
