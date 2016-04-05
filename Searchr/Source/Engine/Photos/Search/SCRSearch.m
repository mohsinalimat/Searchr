//
//  SCRSearch.m
//  Searchr
//
//  Created by Merrick Sapsford on 05/04/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "SCRSearch.h"
#import "SCRSearchPrivate.h"

NSString *const kSCRSearchTextKey = @"text";
NSString *const kSCRSearchMinimumUploadDateKey = @"min_upload_date";
NSString *const kSCRSearchMaximumUploadDateKey = @"max_upload_date";
NSString *const kSCRSearchMinimumTakenDateKey = @"min_taken_date";
NSString *const kSCRSearchMaximumTakenDateKey = @"max_taken_date";
NSString *const kSCRSearchLatitudeKey = @"lat";
NSString *const kSCRSearchLongitudeKey = @"lon";
NSString *const kSCRSearchRadiusKey = @"radius";
NSString *const kSCRSearchRadiusUnitsKey = @"radius_units";

NSString *const kSCRSearchRadiusUnitKilometers = @"km";
NSString *const kSCRSearchRadiusUnitMiles = @"mi";

@implementation SCRSearch

@synthesize failed = _failed;
@synthesize results = _results;

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        _components = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - Lifecycle

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        SCRSearch *otherSearch = (SCRSearch *)object;
        return [self.components isEqualToDictionary:otherSearch.components];
    }
    return NO;
}

#pragma mark - Public

- (SCRPagedList<SCRPhotoModel *> *)results {
    if (!_results) {
        _results = [SCRPagedList new];
    }
    return _results;
}

- (void)setText:(NSString *)text {
    _text = text;
    [self registerComponent:text forKey:kSCRSearchTextKey];
}

- (void)setMinimumUploadDate:(NSDate *)minimumUploadDate {
    _minimumUploadDate = minimumUploadDate;
    [self registerComponent:minimumUploadDate forKey:kSCRSearchMinimumUploadDateKey];
}

- (void)setMaximumUploadDate:(NSDate *)maximumUploadDate {
    _maximumUploadDate = maximumUploadDate;
    [self registerComponent:maximumUploadDate forKey:kSCRSearchMaximumUploadDateKey];
}

- (void)setMinimumTakenDate:(NSDate *)minimumTakenDate {
    _minimumTakenDate = minimumTakenDate;
    [self registerComponent:minimumTakenDate forKey:kSCRSearchMinimumTakenDateKey];
}

- (void)setMaximumTakenDate:(NSDate *)maximumTakenDate {
    _maximumTakenDate = maximumTakenDate;
    [self registerComponent:maximumTakenDate forKey:kSCRSearchMaximumTakenDateKey];
}

- (void)setLocationCoordinate:(CLLocationCoordinate2D)locationCoordinate {
    _locationCoordinate = locationCoordinate;
    [self registerComponent:@(locationCoordinate.latitude) forKey:kSCRSearchLatitudeKey];
    [self registerComponent:@(locationCoordinate.longitude) forKey:kSCRSearchLongitudeKey];
}

- (void)setLocationRadius:(NSInteger)locationRadius {
    _locationRadius = locationRadius;
    [self registerComponent:@(locationRadius)
                     forKey:kSCRSearchRadiusKey];
}

- (void)setLocationRadiusUnit:(SCRSearchRadiusUnit)locationRadiusUnit {
    _locationRadiusUnit = locationRadiusUnit;
    [self registerComponent:[self locationRadiusUnitStringForRadiusUnit:locationRadiusUnit]
                     forKey:kSCRSearchRadiusUnitsKey];
}

- (NSDictionary *)components {
    return _components;
}

#pragma mark - Internal

- (void)registerComponent:(id)data forKey:(NSString *)key {
    [_components setObject:data forKey:key];
}

- (NSString *)locationRadiusUnitStringForRadiusUnit:(SCRSearchRadiusUnit)radiusUnit {
    switch (self.locationRadiusUnit) {
        case SCRSearchRadiusUnitKilometers:
            return kSCRSearchRadiusUnitKilometers;
            
        case SCRSearchRadiusUnitMiles:
            return kSCRSearchRadiusUnitMiles;
            
    }
}

#pragma mark - Private

- (void)setFailed:(BOOL)failed {
    if (!self.results) { // only set failed if we have no results
        _failed = failed;
    }
}

@end
