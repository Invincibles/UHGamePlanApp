//
//  CustomCell.h
//  TableView
//
//  Created by Invincibles on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 Most of the cells in our application are custom cells, each cell has two parts one is primary label and the second is the secondary label, it stores content according to the situation where it is used and the position of these labels are decided accordingly.
 */

#import <UIKit/UIKit.h>


@interface CustomCell : UITableViewCell {
    UILabel *primaryLabel;
    UILabel *secondaryLabel;
}

@property(nonatomic, retain) UILabel *primaryLabel;
@property(nonatomic, retain) UILabel *secondaryLabel;


@end
