//
//  SQLManager.m
//  NameList
//
//  Created by Yi Zhang on 2019/4/21.
//  Copyright © 2019 Yi Zhang. All rights reserved.
//

#import "SQLManager.h"

@implementation SQLManager

#define kNameFile (@"Student.sqlite")

static SQLManager *manager = nil;

+ (SQLManager *)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        [manager createDatabaseTableIfNeeded];
    });
    return manager;
}

- (StudentModel *)searchwithIdNum:(StudentModel *)model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        NSAssert(NO, @"Open database failed");
        sqlite3_close(db);
    } else {
        NSString *qsql = @"SELECT idNum,name FROM StudentName where idNum = ?";
        // 语句对象
        sqlite3_stmt *statement;
        
        // -1 为全部执行
        if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            // 主键查询
            NSString *idNum = model.idNum;
            sqlite3_bind_text(statement, 1, [idNum UTF8String], -1, NULL);
            sqlite3_step(statement);
            
            if (sqlite3_step(statement) == SQLITE_ROW) {
                // 提取数据
                char *idNum = (char *)sqlite3_column_text(statement, 0);
                NSString *idNumStr = [[NSString alloc] initWithUTF8String:idNum];
                char *name = (char *)sqlite3_column_text(statement, 1);
                NSString *nameStr = [[NSString alloc] initWithUTF8String:name];
                StudentModel *model = [[StudentModel alloc] init];
                model.idNum = idNumStr;
                model.name = nameStr;
                sqlite3_finalize(statement);
                sqlite3_close(db);
                return model;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return nil;
}

- (int)insert:(StudentModel *)model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        NSAssert(NO, @"Open database failed");
        sqlite3_close(db);
    } else {
        NSString *sql = @"INSERT OR REPLACE INTO StudentName (idNum, name) VALUES (?, ?)";
        sqlite3_stmt *statement;
        // 预处理
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [model.idNum UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [model.name UTF8String], -1, NULL);
            
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"插入数据失败");
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    return 0;
}

- (NSString *)applicationDocumentsDirectoryFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:kNameFile];
    return filePath;
}

- (void)createDatabaseTableIfNeeded
{
    NSString *writeTablePath = [self applicationDocumentsDirectoryFile];
    NSLog(@"数据库地址：%@", writeTablePath);
    
    // 数据库路径为基数数据类型
    if (sqlite3_open([writeTablePath UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
    } else {
        char *err;
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS StudentName (idNum TEXT PRIMARYKEY, name TEXT);"];
        if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            // 失败
            sqlite3_close(db);
            NSAssert(NO, @"建表失败 %s", err);
        }
        sqlite3_close(db);
    }
}



@end
