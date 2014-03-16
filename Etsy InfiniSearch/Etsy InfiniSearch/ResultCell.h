//
//  ResultCell.h
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/16/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *listingLabel;
@property (nonatomic, strong) IBOutlet UIImageView *listingImage;

@end