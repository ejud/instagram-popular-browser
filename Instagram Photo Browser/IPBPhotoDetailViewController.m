//
//  IPBPhotoDetailViewController.m
//  Instagram Photo Browser
//
//  Created by Ethan Jud on 11/19/13.
//  Copyright (c) 2013 Ethan Jud. All rights reserved.
//

#import "IPBPhotoDetailViewController.h"

@interface IPBPhotoDetailViewController ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation IPBPhotoDetailViewController

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [_imageObject release];
    [_placeholderImage release];
    
    [_imageView release];

    [super dealloc];
}

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];

    self.imageView = [[[UIImageView alloc] initWithFrame:self.view.bounds] autorelease];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [self.view addSubview:self.imageView];

    [self populateDetails];
}

#pragma mark - Image Details

- (void)setImageObject:(IPBImageObject *)imageObject
{
    if (imageObject == _imageObject) {
        return;
    }
    
    [_imageObject autorelease];
    _imageObject = [imageObject retain];

    if (self.isViewLoaded) {
        [self populateDetails];
    }
}

- (void)populateDetails
{
    self.imageView.image = self.placeholderImage;

    if (!self.imageObject) {
        return;
    }

    NSURLRequest *request = [NSURLRequest requestWithURL:self.imageObject.imageURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        if (error) {
            [self showImageLoadError];
            return;
        }

        self.imageView.image = [UIImage imageWithData:data];
    }];
}

- (void)showImageLoadError
{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Unable to load image.", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] autorelease];
    
    [alertView show];
}

@end
