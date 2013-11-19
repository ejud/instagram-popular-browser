//
//  IPBPhotoDetailViewController.h
//  Instagram Photo Browser
//
//  Created by Ethan Jud on 11/19/13.
//  Copyright (c) 2013 Ethan Jud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPBImageObject.h"

@interface IPBPhotoDetailViewController : UIViewController

@property (strong, nonatomic) IPBImageObject *imageObject;

// An image which will act as a placeholder until the
//  full-resolution image loads.
@property (strong, nonatomic) UIImage *placeholderImage;

@end
