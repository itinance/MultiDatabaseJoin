//
//  AppDelegate.m
//  MultiDatabaseJoin
//
//  Created by Hagen Hübel on 08/06/15.
//  Copyright (c) 2015 ITinance GmbH. All rights reserved.
//

#import "AppDelegate.h"
#import <FMDB/FMDB.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {



    FMDatabase *db1 = [FMDatabase databaseWithPath:@"/tmp/tmp1.db"];
    FMDatabase *db2 = [FMDatabase databaseWithPath:@"/tmp/tmp2.db"];

    [db1 open];
    [db2 open];

    [db1 executeStatements:@"CREATE TABLE a (id INTEGER, name TEXT)"];
    [db1 executeStatements:@"INSERT INTO a (id, name) VALUES (1, 'foo'), (2, 'bar')"];

    [db2 executeStatements:@"CREATE TABLE b (id INTEGER, a_id INTEGER, name TEXT)"];
    [db2 executeStatements:@"INSERT INTO b (id, a_id, name) VALUES (1, 1, 'b_foo'), (2, 2, 'b_bar')"];

    bool success = [db1 executeStatements:@"ATTACH DATABASE '/tmp/tmp2.db' AS second_db"];
    if(!success) {
        NSLog(@"%@", db1.lastErrorMessage);
        return YES;
    }

    FMResultSet* rs = [db1 executeQuery:@"SELECT a.id, a.name AS aname, b.name AS bname FROM a INNER JOIN second_db.b ON b.a_id = a.id"];
    while( [rs next]) {
        NSLog(@"%@, %@", [rs stringForColumn:@"aname"], [rs stringForColumn:@"bname"]);
    }
    [rs close];


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
