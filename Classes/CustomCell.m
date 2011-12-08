//
//  CustomCell.m
//  TableView
//
//  Created by Invincibles on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomCell.h"


@implementation CustomCell

@synthesize primaryLabel, secondaryLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        primaryLabel = [[UILabel alloc] init];
        primaryLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"celltexture.png"]];
        primaryLabel.textAlignment = UITextAlignmentLeft;
        primaryLabel.font = [UIFont systemFontOfSize:14];
        
        secondaryLabel = [[UILabel alloc] init];
        secondaryLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"celltexture.png"]];
        secondaryLabel.textAlignment = UITextAlignmentLeft;
        secondaryLabel.font = [UIFont systemFontOfSize:20];
        
        primaryLabel.textColor = [UIColor colorWithRed:(154.0/255.0f) green:(176.0/255.0f) blue:(44.0/255.0f) alpha:1.0f];
        secondaryLabel.textColor = [UIColor colorWithRed:(154.0/255.0f) green:(176.0/255.0f) blue:(44.0/255.0f) alpha:1.0f];
       
        [self.contentView addSubview:primaryLabel];
        [self.contentView addSubview:secondaryLabel];
   
        }  
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
 
    frame= CGRectMake(boundsX+370 ,18, 100, 35);
    primaryLabel.frame = frame;
    
    frame= CGRectMake(boundsX+40 ,18, 300, 40);
    secondaryLabel.frame = frame;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    [primaryLabel release];
    [secondaryLabel release];
    [super dealloc];
}

@end
