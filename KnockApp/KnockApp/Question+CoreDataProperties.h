//
//  Question+CoreDataProperties.h
//  KnockApp
//
//  Created by Fangzhou Sun on 11/29/15.
//  Copyright © 2015 Fangzhou Sun. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Question.h"

NS_ASSUME_NONNULL_BEGIN

@interface Question (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *deviceid;

@end

NS_ASSUME_NONNULL_END
