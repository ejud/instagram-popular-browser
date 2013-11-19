//
//  IPBPhotoCell.h
//  Instagram Photo Browser
//
//  Created by Ethan Jud on 11/18/13.
//  Copyright (c) 2013 Ethan Jud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPBImageObject.h"

@interface IPBPhotoCell : UITableViewCell

@property (strong, nonatomic) IPBImageObject *imageObject;

// The thumbnail image, once it has been loaded.
@property (strong, nonatomic, readonly) UIImage *thumbnailImage;

@end
