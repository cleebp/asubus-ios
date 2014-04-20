/*
//  BPCDatabase.m
//  AsUBus 0.2
//
//  Created by Brian Clee on 3/29/14.
//
//

#import "BPCDatabase.h"

@implementation BPCDatabase

@end

static BPCDatabase *_database;

+ (BPCDatabase*)database {
    if (_database == nil) {
        _database = [[BPCDatabase alloc] init];
    }
    return _database;
}

- (id)init {
    if ((self = [super init])) {
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"asubus"
                    ofType:@"sqlite3"];
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

- (void)dealloc {
    sqlite3_close(_database);
    [super dealloc];
}

@end*/