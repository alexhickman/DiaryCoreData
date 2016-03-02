//
//  EntryTableViewCell.h
//  DiaryCoreData
//
//  Created by Hickman on 2/29/16.
//  Copyright © 2016 Hickman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiaryEntry;

@interface EntryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *moodImage;

+ (CGFloat)heightForEntry:(DiaryEntry *)entry;
- (void)configureCellForEntry:(DiaryEntry *)entry;


@end
