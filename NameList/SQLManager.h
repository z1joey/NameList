//
//  SQLManager.h
//  NameList
//
//  Created by Yi Zhang on 2019/4/21.
//  Copyright © 2019 Yi Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "StudentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SQLManager : NSObject
{
    sqlite3 *db;
}

+ (SQLManager *)shared;
- (StudentModel *)searchwithIdNum: (StudentModel *) model;
- (int)insert:(StudentModel *) model;

@end

NS_ASSUME_NONNULL_END
