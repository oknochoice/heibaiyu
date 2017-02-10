//
//  buffer_yi_util.hpp
//  heibaiyu
//
//  Created by jiwei.wang on 2/10/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#ifndef buffer_yi_util_hpp
#define buffer_yi_util_hpp

#include "buffer_yi.h"
#include "typemapre.h"
#include <google/protobuf/util/json_util.h>

#include <stdio.h>
// c++ protobuf 
template <typename Proto>
std::shared_ptr<yijian::buffer> yijian::buffer::Buffer(Proto && any) {

  std::string value;
  google::protobuf::util::MessageToJsonString(any, &value);
  YILOG_TRACE("func: {}, any: {}", __func__, value);
  auto data = any.SerializeAsString();
  return Buffer(dispatchType(any), data);
}

#endif /* buffer_yi_util_hpp */
