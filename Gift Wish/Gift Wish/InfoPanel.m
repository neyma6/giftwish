//
//  InfoPanel.m
//  Gift Wish
//
//  Created by neyma on 19/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import "InfoPanel.h"
#import "BackGroundLayer.h"
#import "FTWCache.h"
#import "UIImageView+Network.h"

@interface InfoPanel()

@property (strong, nonatomic) UIImageView* profilePictureView;
@property (strong, nonatomic) UILabel* userName;
@property (strong, nonatomic) UILabel* wishListName;
@property (strong, nonatomic) UILabel* wishListEventDate;
@property (strong, nonatomic) UILabel* wishListLastUpdate;

@end

@implementation InfoPanel

- (id)initWithFrame:(CGRect)frame WithFBProfilId:(NSDictionary<FBGraphUser>*)user WithWishList:(WishList*)wishList WithIsOwn:(BOOL)own
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self createProfilPicture:user[@"id"]];

        if (wishList != nil)
        {
            [self createProfileNameLabel:user.name IsMainPanel:NO];
            [self createWishListDetails:wishList WithIsOwn:own];
        }
        else
        {
            [self createProfileNameLabel:user.name IsMainPanel:YES];
        }
    }
    return self;
}

-(void)createProfilPicture:(NSString*)fbId
{
    _profilePictureView = [[UIImageView alloc] init];
    _profilePictureView.frame = CGRectMake(10, 10, 70, 70);
    _profilePictureView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    _profilePictureView.layer.cornerRadius=35;
    _profilePictureView.layer.borderWidth=1.0;
    _profilePictureView.layer.masksToBounds = YES;
    _profilePictureView.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    NSString *key = fbId;
    NSData *data = [FTWCache objectForKey:key];
    if (data) {
        _profilePictureView.image = [UIImage imageWithData:data];
    } else {
        _profilePictureView.image = [UIImage imageNamed:@"default.jpg"];
        [_profilePictureView loadImageFromURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", key]] placeholderImage:_profilePictureView.image cachingKey:key ];
    }

    [self addSubview:_profilePictureView];
}

-(void)createProfileNameLabel:(NSString*)name IsMainPanel:(BOOL)isMain
{
    if (isMain)
    {
        _userName = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, 200, 20)];
    }
    else
    {
        _userName = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 200, 20)];
    }
    _userName.text = name;
    [_userName setFont:[UIFont systemFontOfSize:22]];
    _userName.textColor = [UIColor whiteColor];
    
    [self addSubview: _userName];
}

-(void)createWishListLabel
{
    
}

-(void)createWishListDetails:(WishList*)wishList WithIsOwn:(BOOL)own
{
    _wishListName = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, self.frame.size.width - 90, 20) ];
    _wishListName.text = wishList.name;
    [_wishListName setFont:[UIFont systemFontOfSize:15]];
    _wishListName.textColor = [UIColor whiteColor];
    
    [self addSubview: _wishListName];
    
    _wishListEventDate = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, 200, 20) ];
    _wishListEventDate.text = [NSString stringWithFormat:@"Event Date: %@", wishList.eventDate];
    [_wishListEventDate setFont:[UIFont systemFontOfSize:12]];
    _wishListEventDate.textColor = [UIColor whiteColor];
    
    [self addSubview: _wishListEventDate];
    
    if (!own)
    {
        _wishListLastUpdate = [[UILabel alloc] initWithFrame:CGRectMake(90, 65, 200, 20) ];
        _wishListLastUpdate.text = [NSString stringWithFormat:@"Last User Update: %@", wishList.lastUpdate];
        [_wishListLastUpdate setFont:[UIFont systemFontOfSize:12]];
        _wishListLastUpdate.textColor = [UIColor whiteColor];
    
        [self addSubview: _wishListLastUpdate];
    }

}


@end
