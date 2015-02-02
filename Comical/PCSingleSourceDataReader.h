//
//  PCSingleSourceDataReader.h
//  Comical
//
//  Created by Eric Weaver on 6/1/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCDataReader.h"
#import "PCBaseDataReader.h"

@interface PCSingleSourceDataReader : PCBaseDataReader <PCDataReader>

- (id) initWithSource:(NSString *)sourceId;

@end
