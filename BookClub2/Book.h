//
//  Book.h
//  BookClub2
//
//  Created by CHRISTINA GUNARTO on 11/12/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment;

@interface Book : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSSet *readers;
@property (nonatomic, retain) NSSet *comments;
@end

@interface Book (CoreDataGeneratedAccessors)

- (void)addReadersObject:(NSManagedObject *)value;
- (void)removeReadersObject:(NSManagedObject *)value;
- (void)addReaders:(NSSet *)values;
- (void)removeReaders:(NSSet *)values;

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
