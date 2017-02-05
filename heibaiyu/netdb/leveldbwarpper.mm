//
//  leveldbwarpper.cpp
//  heibaiyu
//
//  Created by yijian on 2/5/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#include "leveldbwarpper.h"
#include <leveldb/db.h>
#include <leveldb/write_batch.h>

static leveldb::DB * db_;

@implementation leveldbwarpper

+ (BOOL)open_dbWith:(NSString*)path {
  leveldb::Options options;
  options.create_if_missing = true;
  leveldb::Status status = leveldb::DB::Open(options, std::string([path UTF8String]), &db_);
  
  if (!status.ok()) {
    return true;
  }else {
    return false;
  }
}
+ (void)close_db {
  delete db_;
  db_ = nullptr;
}
+ (BOOL)db_putWith:(NSString*)key Data:(NSString*)data {
  auto status = db_->Put(leveldb::WriteOptions(), std::string([key UTF8String]), std::string([data UTF8String]));
  if (status.ok()) {
    return true;
  }else {
    return false;
  }
}
+ (NSString*)db_getWith:(NSString*)key {
  std::string data;
  auto status = db_->Get(leveldb::ReadOptions(), std::string([key  UTF8String]), &data);
  if (status.ok()) {
    return [NSString stringWithCString:data.c_str() encoding: NSUTF8StringEncoding];
  }else{
    return nil;
  }
}
+ (BOOL)db_deleteWith:(NSString *)key {
  auto status = db_->Delete(leveldb::WriteOptions(), std::string([key UTF8String]));
  if (status.ok()) {
    return true;
  }else {
    return false;
  }
}

@end
