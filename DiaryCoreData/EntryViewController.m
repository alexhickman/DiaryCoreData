//
//  NewEntryViewController.m
//  DiaryCoreData
//
//  Created by Hickman on 2/26/16.
//  Copyright © 2016 Hickman. All rights reserved.
//

#import "EntryViewController.h"
#import "CoreDataStack.h"
#import "DiaryEntry+CoreDataProperties.h"
#import <CoreLocation/CoreLocation.h>

@interface EntryViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>

@property (nonatomic, assign) enum DiaryEntryMood pickedMood;
@property (nonatomic, strong) UIImage *pickedImage;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *location;

@end

@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSDate *date;
    
    if (self.entry != nil) {
        self.textView.text = self.entry.body;
        self.pickedMood = self.entry.mood;
        date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
    }
    else
    {
        self.pickedMood = DiaryEntryMoodGood;
        date = [NSDate date];
        [self.locationManager requestWhenInUseAuthorization];
        [self loadLocation];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    
    self.pickedImage = [UIImage imageWithData:self.entry.image];
    self.labelDate.text = [dateFormatter stringFromDate:date];
    self.textView.inputAccessoryView = self.accessoryView;
    self.buttonImage.layer.cornerRadius = CGRectGetWidth(self.buttonImage.frame) / 2.0f;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertDiaryEntry
{
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    DiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    entry.body = self.textView.text;
    entry.date = [[NSDate date] timeIntervalSince1970];
    entry.mood = self.pickedMood;
    entry.image = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    entry.location = self.location;
    [coreDataStack saveContext];
}

- (void)updateDiaryEntry
{
    self.entry.body = self.textView.text;
    self.entry.mood = self.pickedMood;
    self.entry.image = UIImageJPEGRepresentation(self.pickedImage, 0.75);

    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
}

- (void)promptForSource
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Image Source" message:@"Where do you want your photo from?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self promptForCamera];
    }];
    UIAlertAction *photoRollAction = [UIAlertAction actionWithTitle:@"PhotoRoll" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self promptForPhotoRoll];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cameraAction];
    [alert addAction:photoRollAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)promptForCamera
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)promptForPhotoRoll
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setPickedImage:(UIImage *)pickedImage
{
    _pickedImage = pickedImage;
    
    if (pickedImage == nil) {
        [self.buttonImage setImage:[UIImage imageNamed:@"icn_noimage"] forState:UIControlStateNormal];
    }
    else
    {
        [self.buttonImage setImage:pickedImage forState:UIControlStateNormal];
    }
}

- (void)setPickedMood:(enum DiaryEntryMood)pickedMood
{
    _pickedMood = pickedMood;
    
    self.buttonBad.alpha = 0.5f;
    self.buttonAverage.alpha = 0.5f;
    self.buttonGood.alpha = 0.5f;
    
    switch (pickedMood) {
        case DiaryEntryMoodGood:
            self.buttonGood.alpha = 1.0f;
            break;
        case DiaryEntryMoodAverage:
            self.buttonAverage.alpha = 1.0f;
            break;
        case DiaryEntryMoodBad:
            self.buttonBad.alpha = 1.0f;
            break;
        default:
            break;
    }
}

- (void)loadLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = 2000;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations firstObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks firstObject];
        self.location = placemark.locality;
    }];
}

- (IBAction)cancelWasPressed:(id)sender
{
    [self dismissSelf];
}

- (IBAction)doneWasPressed:(id)sender
{
    if (self.entry != nil)
    {
        [self updateDiaryEntry];
    }
    else
    {
        [self insertDiaryEntry];
    }
    [self dismissSelf];
}

- (IBAction)badWasPressed:(id)sender
{
    self.pickedMood = DiaryEntryMoodBad;
}

- (IBAction)averageWasPressed:(id)sender
{
    self.pickedMood = DiaryEntryMoodAverage;
}

- (IBAction)goodWasPressed:(id)sender
{
    self.pickedMood = DiaryEntryMoodGood;
}

- (IBAction)imageButtonPressed:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    }
    else
    {
        [self promptForPhotoRoll];
    }
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
