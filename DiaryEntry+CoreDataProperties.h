//
//  DiaryEntry+CoreDataProperties.h
//  DiaryCoreData
//
//  Created by Hickman on 2/27/16.
//  Copyright © 2016 Hickman. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DiaryEntry.h"

NS_ASSUME_NONNULL_BEGIN

enum DiaryEntryMood{DiaryEntryMoodGood = 0, DiaryEntryMoodAverage = 1, DiaryEntryMoodBad = 2};

@interface DiaryEntry (CoreDataProperties)

@property (nonatomic) NSTimeInterval date;
@property (nullable, nonatomic, retain) NSString *body;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *location;
@property (nonatomic) int16_t mood;

@end

NS_ASSUME_NONNULL_END
