//
//  netdb_yi.cpp
//  heibaiyu
//
//  Created by jiwei.wang on 2/9/17.
//  Copyright © 2017 yijian. All rights reserved.
//

#include "netdb_yi.hpp"
#include "buffer_yi_util.hpp"


netdb_yi::netdb_yi(std::string & dbpath) {
  YILOG_TRACE ("func: {}", __func__);
  isOpenNet_.store(false);
  dbyi_ = new leveldb_yi(dbpath);
}

netdb_yi::~netdb_yi() {
  YILOG_TRACE ("func: {}", __func__);
  if (isOpenNet_.load()) {
    clear_client();
  }
  delete dbyi_;
}

void netdb_yi::openNet(std::string & certpath, Client_CB client_callback) {
  YILOG_TRACE ("func: {}", __func__);
  netyi_ = new netyi(certpath);
  client_callback_ = client_callback;
  auto ping = chat::Ping();
  ping.set_msg("ping");
  netyi_->net_connect(yijian::buffer::Buffer(ping), [this](int error_no, std::string && error_msg) {
    if (0 == error_no) {
      isOpenNet_.store(true);
      client_callback_(error_no, std::forward<std::string>(error_msg));
    }
  });
}

