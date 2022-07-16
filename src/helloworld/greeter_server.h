#ifndef ZIG_GRPC_EXAMPLE_GREETER_SERVER_H
#define ZIG_GRPC_EXAMPLE_GREETER_SERVER_H

#ifdef __cplusplus
extern "C" {
#endif

struct greeter_server;
typedef struct greeter_server greeter_server_t;

greeter_server_t *greeter_server_create(char* server_address);
void greeter_server_destroy(greeter_server_t *g);
void greeter_server_start(greeter_server_t *g);

#ifdef __cplusplus
}
#endif

#endif //ZIG_GRPC_EXAMPLE_GREETER_SERVER_H
