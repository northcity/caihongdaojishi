//
//  LZDataModel.m
//  SqliteTest
//
//  Created by Artron_LQQ on 16/4/19.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZDataModel.h"
#import "LZStringTool.h"

#define knickName @"nickName"
#define kgroupName @"groupName"
#define kuserName @"userName"
#define kpassword @"password"
#define kurlString @"urlString"
#define kdsc @"dsc"
#define kidentifier @"identifier"
#define kgroupID @"groupID"
#define kemail @"email"
#define ktitleString @"titleString"
#define kcontentString @"contentString"
#define kcolorString @"colorString"
#define kpcmData @"pcmData"


@implementation LZDataModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        
    }
    
    return self;
}

- (NSString *)nickName {
    if (_nickName == nil) {
        _nickName = @"";
    }
    
    return _nickName;
}

-(NSString *)groupName {
    if (_groupName == nil) {
        _groupName = @"";
    }
    
    return _groupName;
}

- (NSString *)groupID {
    if (_groupID == nil) {
        _groupID = @"";
    }
    
    return _groupID;
}

- (NSString *)userName {
    if (_userName == nil) {
        _userName = @"";
    }
    
    return _userName;
}

- (NSString *)password {
    if (_password == nil) {
        _password = @"";
    }
    
    return _password;
}

- (NSString *)urlString {
    if (_urlString == nil) {
        _urlString = @"";
    }
    
    return _urlString;
}

- (NSString *)dsc {
    if (_dsc == nil) {
        _dsc = @"";
    }
    
    return _dsc;
}

- (NSString *)email {
    if (_email == nil) {
        _email = @"";
    }
    
    return _email;
}
- (NSString *)identifier {
    
    if (_identifier == nil) {
        _identifier = [LZStringTool creatRedomMD5String];
    }
    
    return _identifier;
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_nickName forKey:knickName];
    [aCoder encodeObject:_groupName forKey:kgroupName];
    [aCoder encodeObject:_userName forKey:kuserName];
    [aCoder encodeObject:_password forKey:kpassword];
    [aCoder encodeObject:_urlString forKey:kurlString];
    [aCoder encodeObject:_dsc forKey:kdsc];
    [aCoder encodeObject:_identifier forKey:kidentifier];
    [aCoder encodeObject:_groupID forKey:kgroupID];
    [aCoder encodeObject:_email forKey:kemail];
    [aCoder encodeObject:_titleString forKey:ktitleString];
    [aCoder encodeObject:_contentString forKey:kcontentString];
    [aCoder encodeObject:_colorString forKey:kcolorString];
    [aCoder encodeObject:_pcmData forKey:kpcmData];

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
//        _nickName = [aDecoder decodeObjectForKey:knickName];
//        _groupName = [aDecoder decodeObjectForKey:kgroupName];
//        _userName = [aDecoder decodeObjectForKey:kuserName];
//        _password = [aDecoder decodeObjectForKey:kpassword];
//        _urlString = [aDecoder decodeObjectForKey:kurlString];
//        _dsc = [aDecoder decodeObjectForKey:kdsc];
//        _identifier = [aDecoder decodeObjectForKey:kidentifier];
//        _groupID = [aDecoder decodeObjectForKey:kgroupID];
//        _email = [aDecoder decodeObjectForKey:kemail];
//        _titleString = [aDecoder decodeObjectForKey:ktitleString];
//        _contentString = [aDecoder decodeObjectForKey:kcontentString];
//        _colorString = [aDecoder decodeObjectForKey:kcolorString];
//        _pcmData = [aDecoder decodeObjectForKey:kpcmData];

        _nickName = [aDecoder decodeObjectOfClass:[NSString class] forKey:knickName];
        _groupName = [aDecoder decodeObjectOfClass:[NSString class] forKey:kgroupName];
        _userName = [aDecoder decodeObjectOfClass:[NSString class] forKey:kuserName];
        _password = [aDecoder decodeObjectOfClass:[NSString class] forKey:kpassword];
        _urlString = [aDecoder decodeObjectOfClass:[NSString class] forKey:kurlString];
        _dsc = [aDecoder decodeObjectOfClass:[NSString class] forKey:kdsc];
        _identifier = [aDecoder decodeObjectOfClass:[NSString class] forKey:kidentifier];
        _groupID = [aDecoder decodeObjectOfClass:[NSString class] forKey:kgroupID];
        _email = [aDecoder decodeObjectOfClass:[NSString class] forKey:kemail];
        _titleString = [aDecoder decodeObjectOfClass:[NSString class] forKey:ktitleString];
        _contentString = [aDecoder decodeObjectOfClass:[NSString class] forKey:kcontentString];
        _colorString = [aDecoder decodeObjectOfClass:[NSString class] forKey:kcolorString];
        _pcmData = [aDecoder decodeObjectOfClass:[NSString class] forKey:kpcmData];


    }
    return self;
}

#pragma mark - NSCoping
- (id)copyWithZone:(NSZone *)zone {
    LZDataModel *copy = [[[self class] allocWithZone:zone] init];
    copy.nickName = [self.nickName copyWithZone:zone];
    copy.groupName = [self.groupName copyWithZone:zone];
    copy.userName = [self.userName copyWithZone:zone];
    copy.password = [self.password copyWithZone:zone];
    copy.urlString = [self.urlString copyWithZone:zone];
    copy.dsc = [self.dsc copyWithZone:zone];
    copy.identifier = [self.identifier copyWithZone:zone];
    copy.groupID = [self.groupID copyWithZone:zone];
    copy.email = [self.email copyWithZone:zone];
    copy.titleString = [self.titleString copyWithZone:zone];
    copy.contentString = [self.contentString copyWithZone:zone];
    copy.colorString = [self.colorString copyWithZone:zone];
    copy.pcmData = [self.pcmData copyWithZone:zone];

    return copy;
}

@end
