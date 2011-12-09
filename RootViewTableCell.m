//
//  RootViewTableCell.m
//  MultipleDetailViews
//
//  Created by Invincibles on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewTableCell.h"


@implementation RootViewTableCell

@synthesize iconImage, titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = UITextAlignmentLeft;
        titleLabel.textColor = [UIColor yellowColor];
        titleLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"celltexture.png"]];
        
        //self.titleLabel.textColor = [UIColor greenColor];
        titleLabel.textColor = [[[UIColor alloc] initWithRed:154.0f/255.0f green:176.0f/255.0f blue:44.0f/255.0f alpha:1.0f] autorelease];
        titleLabel.font = [UIFont boldSystemFontOfSize:24];
        
        iconImage = [[UIImageView alloc] init];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.iconImage];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    
    frame= CGRectMake(boundsX+10 ,12, 45, 35);
    self.iconImage.frame = frame;
    
    frame = CGRectMake(boundsX+75, 15, 180, 35);
    self.titleLabel.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [iconImage release];
    [titleLabel release];
    [super dealloc];
}

@end
