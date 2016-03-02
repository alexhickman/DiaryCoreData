//
//  NewEntryViewController.h
//  DiaryCoreData
//
//  Created by Hickman on 2/26/16.
//  Copyright © 2016 Hickman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiaryEntry;

@interface EntryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@property (weak, nonatomic) IBOutlet UIButton *buttonBad;
@property (weak, nonatomic) IBOutlet UIButton *buttonAverage;
@property (weak, nonatomic) IBOutlet UIButton *buttonGood;
@property (weak, nonatomic) IBOutlet UIButton *buttonImage;

@property (strong, nonatomic) IBOutlet UIView *accessoryView;

@property (nonatomic, strong) DiaryEntry *entry;

@end
