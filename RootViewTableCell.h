//
//  RootViewTableCell.h
//  MultipleDetailViews
//
//  Created by Invincibles on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewTableCell : UITableViewCell {

    UILabel *titleLabel;
    UIImageView *iconImage;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *iconImage;

@end
