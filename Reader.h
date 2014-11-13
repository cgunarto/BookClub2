//
//  Reader.h
//  BookClub2
//
//  Created by CHRISTINA GUNARTO on 11/12/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book;

@interface Reader : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * isFriend;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSSet *books;
@end

@interface Reader (CoreDataGeneratedAccessors)

- (void)addBooksObject:(Book *)value;
- (void)removeBooksObject:(Book *)value;
- (void)addBooks:(NSSet *)values;
- (void)removeBooks:(NSSet *)values;

@end
