#ifndef LIB_CLIENT_H_
#define LIB_CLIENT_H_

#include "macro.h"
#include <arpa/inet.h>
#include <netinet/in.h>
#include <ev.h>
#include "buffer_yi.h"
#include <functional>
#include <string>

#include <openssl/ssl.h>

typedef std::shared_ptr<yijian::buffer> Buffer_SP;
typedef std::function<void(Buffer_SP)> Read_CB;
//typedef void (*IsConnectSuccess)();
typedef std::function<void()> ConnectNoti;
typedef std::function<void(int error_no, std::string error_msg)> Error_CB;

// main thread call, read_cb subthread callback
void create_client(std::string certpath, Buffer_SP ping,
                   Read_CB && read_cb,
                   ConnectNoti connectNoti, Error_CB error_cb);
// main thread call
void client_send(Buffer_SP sp_buffer, uint16_t * sessionid);
void clear_client();
// set net is connect
void client_setNet_isConnect(bool isConnect);

#endif
