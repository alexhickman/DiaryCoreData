//
//  EntryTableViewCell.m
//  DiaryCoreData
//
//  Created by Hickman on 2/29/16.
//  Copyright © 2016 Hickman. All rights reserved.
//

#import "EntryTableViewCell.h"
#import "DiaryEntry.h"
#import <QuartzCore/QuartzCore.h>

@implementation EntryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForEntry:(DiaryEntry *)entry
{
    const CGFloat topMargin = 35.0f;
    const CGFloat bottomMargin = 80.0f;
    const CGFloat minHeight = 85.0f;
    
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGRect boundingBox = [entry.body boundingRectWithSize:CGSizeMake(212, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: font} context:nil];
    return MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin + bottomMargin);
}

- (void)configureCellForEntry:(DiaryEntry *)entry
{
    self.bodyLabel.text = entry.body;
    self.locationLabel.text = entry.location;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMMM d yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    if (entry.image) {
        self.mainImage.image = [UIImage imageWithData:entry.image];
    }
    else
    {
        self.mainImage.image = [UIImage imageNamed:@"icn_noimage"];
    }
    
    if (entry.mood == DiaryEntryMoodGood) {
        self.moodImage.image = [UIImage imageNamed:@"icn_happy"];
    }
    else if (entry.mood == DiaryEntryMoodAverage)
    {
        self.moodImage.image = [UIImage imageNamed:@"icn_average"];
    }
    else if (entry.mood == DiaryEntryMoodBad)
    {
        self.moodImage.image = [UIImage imageNamed:@"icn_bad"];
    }
    
    self.mainImage.layer.cornerRadius = CGRectGetWidth(self.mainImage.frame) / 2.0f;
    
    if (entry.location.length > 0) {
        self.locationLabel.text = entry.location;
    }
    else
    {
        self.locationLabel.text = @"No location";
    }
}


@end
