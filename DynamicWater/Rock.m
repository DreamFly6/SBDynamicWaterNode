//
//  Rock.m
//  DynamicWater
//
//  Created by Steve Barnegren on 08/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "Rock.h"

@interface Rock ()
@end


@implementation Rock

-(instancetype)initWithImageNamed:(NSString *)name{
    
    if (self = [super initWithImageNamed:name]) {
        self.isAboveWater = YES;
        self.velocity = CGPointZero;
    }
    return self;
}

@end
