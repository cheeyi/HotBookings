//
//  NSValue+MKMapPoint.m
//  HotBookings
//
//  Created by Chee Yi Ong on 6/6/16.
//  Copyright © 2016 Expedia Inc. All rights reserved.
//

#import "NSValue+MKMapPoint.h"

@implementation NSValue (MKMapPoint)

+ (NSValue *)valueWithMKMapPoint:(MKMapPoint)mapPoint {
    return [NSValue value:&mapPoint withObjCType:@encode(MKMapPoint)];
}
- (MKMapPoint)MKMapPointValue {
    MKMapPoint mapPoint;
    [self getValue:&mapPoint];
    return mapPoint;
}

@end
