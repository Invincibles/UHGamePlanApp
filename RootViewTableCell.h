//
//  RootViewTableCell.h
//  MultipleDetailViews
//
//  Created by Invincibles on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 The root view has a custom cell that has an image and text associated with it, inorder to accomplish this we created a custom cell which contains an image and a label
 */

#import <UIKit/UIKit.h>


@interface RootViewTableCell : UITableViewCell {

    UILabel *titleLabel;
    UIImageView *iconImage;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *iconImage;

@end
