//
//  BPCDatabase.h
//  AsUBus 0.2
//
//  Created by Brian Clee on 3/29/14.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface BPCDatabase : NSObject {
    sqlite3 *_database;
}

+ (BPCDatabase*)database;
//- (NSArray *)dbInfos;

@end
