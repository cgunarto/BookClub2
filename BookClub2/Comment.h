//
//  Comment.h
//  BookClub2
//
//  Created by CHRISTINA GUNARTO on 11/12/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSManagedObject *book;

@end
