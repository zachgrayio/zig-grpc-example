#ifndef ZIG_GRPC_EXAMPLE_GREETER_CLIENT_H
#define ZIG_GRPC_EXAMPLE_GREETER_CLIENT_H

#ifdef __cplusplus
extern "C" {
#endif

struct greeter_client;
typedef struct greeter_client greeter_client_t;

greeter_client_t *greeter_client_create(char* target);
void greeter_client_destroy(greeter_client_t *g);
const char* greeter_client_say_hello(greeter_client_t *g, char* user);

#ifdef __cplusplus
}
#endif

#endif //ZIG_GRPC_EXAMPLE_GREETER_CLIENT_H
