#include "net_yi.h"
#include "macro.h"
#include "typemap.h"
#include "buffer_yi.h"
#include <iostream>

using yijian::buffer;

enum Session_ID : int32_t {
  regist_id = -1,
  login_id = -2,
  connect_id = -3,
  disconnect_id = -4,
  logout_id = -5,
  accept_unread_msg_id = -6,
  user_noti_id = -7,
  ping_pong_id = -8
};

netyi::netyi(const std::string & certpath):
  certpath_(certpath){
  YILOG_TRACE ("func: {}", __func__);
}

void netyi::setNetIsReachable(bool isReachable) {
  YILOG_TRACE ("func: {}", __func__);
  client_setNet_isConnect(isReachable);
}
netyi::~netyi() {
  YILOG_TRACE ("func: {}", __func__);
  clear_client();
}
/*
 * net func
 * */
void netyi::net_connect (Buffer_SP ping_sp, Client_CB client_callback) {
  YILOG_TRACE ("func: {}", __func__);
  create_client(certpath_, ping_sp,
    [&](Buffer_SP sp){
    YILOG_TRACE ("net callback");
    std::unique_lock<std::mutex> ul(sessionid_map_mutex_);
    switch(sp->datatype()) {
      case ChatType::loginnoti:
      case ChatType::addfriendnoti:
      case ChatType::addfriendauthorizenoti:
      {
        call_map(Session_ID::user_noti_id, sp);
        break;
      }
      case ChatType::nodemessagenoti:
      {
        call_map(Session_ID::accept_unread_msg_id, sp);
        break;
      }
      case ChatType::registorres:
      {
        call_map(Session_ID::regist_id, sp);
        break;
      }
      case ChatType::loginres:
      {
        call_map(Session_ID::login_id, sp);
        break;
      }
      case ChatType::clientconnectres:
      {
        call_map(Session_ID::connect_id, sp);
        break;
      }
      case ChatType::logoutres:
      {
        call_map(Session_ID::logout_id, sp);
        break;
      }
      case ChatType::clientdisconnectres:
      {
        call_map(Session_ID::disconnect_id, sp);
        break;
      }
      default:
      call_map(sp->session_id(), sp);
    }
  }, client_callback);
}


void netyi::signup(Buffer_SP sp, CB_Func_Mutiple && func) {
  YILOG_TRACE ("func: {}", __func__);
  put_map_send(Session_ID::regist_id, sp,
      std::forward<CB_Func_Mutiple>(func));
}
void netyi::login(Buffer_SP sp, CB_Func_Mutiple && func) {
  YILOG_TRACE ("func: {}", __func__);
  put_map_send(Session_ID::login_id, sp,
      std::forward<CB_Func_Mutiple>(func));
}
void netyi::connect(Buffer_SP sp, CB_Func_Mutiple && func) {
  YILOG_TRACE ("func: {}", __func__);
  put_map_send(Session_ID::connect_id, sp,
      std::forward<CB_Func_Mutiple>(func));
}

void netyi::disconnect(Buffer_SP sp, CB_Func_Mutiple && func) {
  YILOG_TRACE ("func: {}", __func__);
  put_map_send(Session_ID::disconnect_id, sp,
      std::forward<CB_Func_Mutiple>(func));
}
void netyi::logout(Buffer_SP sp, CB_Func_Mutiple && func) {
  YILOG_TRACE ("func: {}", __func__);
  put_map_send(Session_ID::logout_id, sp,
      std::forward<CB_Func_Mutiple>(func));
}

void netyi::send_buffer(Buffer_SP sp, int32_t * sessionid, CB_Func_Mutiple && func) {
  YILOG_TRACE ("func: {}", __func__);
  put_map_send(sp,
      std::forward<CB_Func_Mutiple>(func), sessionid);
}

/*
 * net noti
 *
 * */
// unread msg noti func(key)
void netyi::acceptUnreadMsg(CB_Func_Mutiple && func) {
  YILOG_TRACE ("func: {}", __func__);
  put_map(Session_ID::accept_unread_msg_id,
      std::forward<CB_Func_Mutiple>(func));
}
// other device loginNoti addFriendNoti addFriendAuthorizeNoti
void netyi::userInfoNoti(CB_Func_Mutiple && func) {
  YILOG_TRACE ("func: {}", __func__);
  put_map(Session_ID::user_noti_id,
      std::forward<CB_Func_Mutiple>(func));
}

/*
 * private
 * */
void netyi::put_map(const int32_t sessionid, CB_Func_Mutiple && func) {
  YILOG_TRACE ("func: {}", __func__);
  std::unique_lock<std::mutex> ul(sessionid_map_mutex_);
  sessionid_cbfunc_map_[sessionid] = func;
}
void netyi::put_map_send(Buffer_SP sp, CB_Func_Mutiple && func, int32_t * sessionid) {
  YILOG_TRACE ("func: {}", __func__);
  std::unique_lock<std::mutex> ul(sessionid_map_mutex_);
  uint16_t temp_session;
  client_send(sp, &temp_session);
  if (likely(nullptr != sessionid)) {
    *sessionid = temp_session;
  }
  YILOG_TRACE ("func: {}, sessionid: {}", __func__, temp_session);
  sessionid_cbfunc_map_[temp_session] = func;
}
void netyi::put_map_send(const int32_t sessionid,
    Buffer_SP sp, CB_Func_Mutiple && func) {
  YILOG_TRACE ("func: {}", __func__);
  std::unique_lock<std::mutex> ul(sessionid_map_mutex_);
  client_send(sp, nullptr);
  sessionid_cbfunc_map_[sessionid] = func;
}
bool netyi::call_map(const int32_t sessionid, Buffer_SP sp) {
  YILOG_TRACE ("func: {}", __func__);
  bool isCalled = false;
  auto lfunc = CB_Func_Mutiple();
  std::unique_lock<std::mutex> ul(sessionid_map_mutex_);
  auto it = sessionid_cbfunc_map_.find(sessionid);
  if (likely(it != sessionid_cbfunc_map_.end())) {
    lfunc = it->second;
  }else {
    YILOG_DEBUG ("user stop call back");
  }
  ul.unlock();
  if (lfunc) {
    bool isStop = true;
    auto data = std::string(sp->data(), sp->data_size());
    lfunc(sp->datatype(), data, &isStop);
    isCalled = true;
    if (isStop) {
      if (sessionid >= 0) {
        std::unique_lock<std::mutex> ul(sessionid_map_mutex_);
        sessionid_cbfunc_map_.erase(it);
      }
    }
  }
  return isCalled;
}

