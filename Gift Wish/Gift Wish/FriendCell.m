//
//  FriendCell.m
//  Gift Wish
//
//  Created by neyma on 12/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import "FriendCell.h"
#import "BackGroundLayer.h"

@interface FriendCell()

@end

@implementation FriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect cellFrame = self.frame;
        
//        CAGradientLayer *bgLayer = [BackgroundLayer blueGradient];
//        bgLayer.frame = CGRectMake(0, 0, self.bounds.size.width, 60);
        
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = CGRectMake(0, 0, self.bounds.size.width, 60);
//        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor colorWithRed:(207/255.0) green:(207/255.0) blue:(207/255.0) alpha:0.5] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
        
        self.backgroundColor = [UIColor clearColor];
        
//        [self setBackgroundView:[[UIView alloc] init]];
//        [self.backgroundView.layer insertSublayer:gradient atIndex:0];
        
        _profilePictureView = [[UIImageView alloc] initWithFrame:CGRectMake(15, cellFrame.size.height / 2 - 17, 50, 50)];
        
        _profilePictureView.layer.backgroundColor=[[UIColor clearColor] CGColor];
        _profilePictureView.layer.cornerRadius=25;
        _profilePictureView.layer.borderWidth=1.0;
        _profilePictureView.layer.masksToBounds = YES;
        _profilePictureView.layer.borderColor=[[UIColor whiteColor] CGColor];
        
        [self addSubview:_profilePictureView];

        _friendName = [[UILabel alloc] initWithFrame:CGRectMake(20 + _profilePictureView.frame.size.width, self.center.y - 8, cellFrame.size.width - (15 + _profilePictureView.frame.size.width), 30)];
        
        //_friendName.font = [UIFont fontWithName:@"Handlee" size:22];
        _friendName.textColor = [UIColor whiteColor];
        [_friendName setFont:[UIFont systemFontOfSize:18]];
        
        [self addSubview:_friendName];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
