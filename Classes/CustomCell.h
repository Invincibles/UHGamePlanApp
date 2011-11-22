//
//  CustomCell.h
//  TableView
//
//  Created by Invincibles on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCell : UITableViewCell {
    
    UILabel *primaryLabel;
    UILabel *secondaryLabel;
   
   
    
    
}

@property(nonatomic, retain) UILabel *primaryLabel;
@property(nonatomic, retain) UILabel *secondaryLabel;


@end
