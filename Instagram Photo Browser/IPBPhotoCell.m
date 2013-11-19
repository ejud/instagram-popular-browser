//
//  IPBPhotoCell.m
//  Instagram Photo Browser
//
//  Created by Ethan Jud on 11/18/13.
//  Copyright (c) 2013 Ethan Jud. All rights reserved.
//

#import "IPBPhotoCell.h"

@interface IPBPhotoCell ()

@property (strong, nonatomic) UIImage *thumbnailImage;

@property (strong, nonatomic) UIImageView *mainImageView;
@property (strong, nonatomic) UIImageView *userImageView;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *userFullNameLabel;

@property (strong, nonatomic) NSURL *URLForLoadingThumbnailImage;
@property (strong, nonatomic) NSURL *URLForLoadingUserImage;

@end

@implementation IPBPhotoCell

#pragma mark - Cell Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _mainImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _mainImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _mainImageView.contentMode = UIViewContentModeScaleAspectFit;

        _userImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _userImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _userImageView.contentMode = UIViewContentModeScaleAspectFit;

        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _userNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
        _userNameLabel.adjustsFontSizeToFitWidth = YES;
        _userNameLabel.minimumScaleFactor = 0.5;
        _userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;

        _userFullNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _userFullNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
        _userFullNameLabel.adjustsFontSizeToFitWidth = YES;
        _userFullNameLabel.minimumScaleFactor = 0.5;
        _userFullNameLabel.translatesAutoresizingMaskIntoConstraints = NO;

        [self.contentView addSubview:_mainImageView];
        [self.contentView addSubview:_userImageView];
        [self.contentView addSubview:_userNameLabel];
        [self.contentView addSubview:_userFullNameLabel];
    }
    return self;
}

- (void)dealloc
{
    [_imageObject release];
    [_thumbnailImage release];
    
    [_mainImageView release];
    [_userImageView release];
    [_userNameLabel release];
    [_userFullNameLabel release];

    [_URLForLoadingThumbnailImage release];
    [_URLForLoadingUserImage release];

    [super dealloc];
}

#pragma mark - Constraints

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)updateConstraints
{
    [super updateConstraints];

    NSDictionary *views = @{ @"userName": self.userNameLabel,
                             @"userFullName": self.userFullNameLabel,
                             @"mainImage": self.mainImageView,
                             @"userImage": self.userImageView };

    NSArray *formats = @[@"H:|-(5)-[mainImage]-(>=5)-[userName]-(5)-|",
                         @"H:[mainImage]-(>=5)-[userFullName]-(5)-|",
                         @"V:|-(5)-[mainImage]-(5)-|",
                         @"H:[userImage]-(5)-|",
                         @"V:|-(5)-[userName]-(5)-[userFullName]-(5)-[userImage]-(5)-|"];
                         
    for (NSString *format in formats) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
    }

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mainImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.mainImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.userImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.userImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    
    [self.userNameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.userFullNameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

#pragma mark - Populate Values

- (void)setImageObject:(IPBImageObject *)imageObject
{
    if (imageObject == _imageObject) {
        return;
    }

    [_imageObject autorelease];
    _imageObject = [imageObject retain];

    self.userNameLabel.text = imageObject.userName;
    if (![imageObject.userName isEqualToString:imageObject.userFullName]) {
        self.userFullNameLabel.text = imageObject.userFullName;
    }
    else {
        self.userFullNameLabel.text = nil;
    }

    self.mainImageView.image = nil;
    self.userImageView.image = nil;
    self.thumbnailImage = nil;

    [self loadImages];
}

- (void)loadImages
{
    self.URLForLoadingThumbnailImage = self.imageObject.thumbnailURL;
    self.URLForLoadingUserImage = self.imageObject.userProfilePictureURL;

    // When loading the images, we check to see if the URL is the one we expect to be loading.
    // If it isn't, it probably means the imageObject property was reset before
    //  the previous picture loaded, and we need to throw it out.

    [self loadImageFromURL:self.imageObject.thumbnailURL completion:^(NSURL *url, UIImage *image) {
        if (![url isEqual:self.URLForLoadingThumbnailImage]) {
            return;
        }
        
        if (image) {
            NSAssert(!self.mainImageView.image || self.mainImageView.image == image, @"Oops");
        }

        self.mainImageView.image = image;
        self.thumbnailImage = image;
    }];

    [self loadImageFromURL:self.imageObject.userProfilePictureURL completion:^(NSURL *url, UIImage *image) {
        if (![url isEqual:self.URLForLoadingUserImage]) {
            return;
        }
        
        self.userImageView.image = image;
    }];
}

- (void)loadImageFromURL:(NSURL *)url completion:(void (^)(NSURL *url, UIImage *image))completion
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        if (data && !error) {
            UIImage *image = [UIImage imageWithData:data];
            completion(url, image);
        }
        else {
            completion(url, nil);
        }
    }];
}

@end
