/*
 *
 * Copyright 2015 gRPC authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#include <iostream>
#include <memory>
#include <string>

#include <grpcpp/ext/proto_server_reflection_plugin.h>
#include <grpcpp/grpcpp.h>
#include <grpcpp/health_check_service_interface.h>

#ifdef BAZEL_BUILD
#include "src/protos/helloworld.grpc.pb.h"
#include "src/helloworld/greeter_server.h"
#else
#include "helloworld.grpc.pb.h"
#endif

using grpc::Server;
using grpc::ServerBuilder;
using grpc::ServerContext;
using grpc::Status;
using helloworld::Greeter;
using helloworld::HelloReply;
using helloworld::HelloRequest;

// Logic and data behind the server's behavior.
class GreeterServiceImpl final : public Greeter::Service {
  Status SayHello(ServerContext* context, const HelloRequest* request,
                  HelloReply* reply) override {
    std::string prefix("Hello ");
    reply->set_message(prefix + "\"" + request->name() + "\"");
    return Status::OK;
  }
};

class GreeterServer {
  private:
    GreeterServiceImpl service;
    ServerBuilder builder;
    std::string server_address;

  public:
    GreeterServer(std::string a) {
      this->server_address = a;
      grpc::EnableDefaultHealthCheckService(true);
      grpc::reflection::InitProtoReflectionServerBuilderPlugin();
      // Listen on the given address without any authentication mechanism.
      builder.AddListeningPort(this->server_address, grpc::InsecureServerCredentials());
      // Register "service" as the instance through which we'll communicate with
      // clients. In this case it corresponds to an *synchronous* service.
      builder.RegisterService(&service);
    }

    void Start() {
      // Finally assemble the server.
      std::unique_ptr<Server> server(builder.BuildAndStart());
      // std::cout << "Server listening on " << this->server_address << std::endl;
      // Wait for the server to shutdown. Note that some other thread must be
      // responsible for shutting down the server for this call to ever return.
      server->Wait();
    }
};

struct greeter_server {
	void *obj;
};

greeter_server_t *greeter_server_create(char* server_address) {
	auto g = (struct greeter_server *)malloc(sizeof(struct greeter_server));
	g->obj = new GreeterServer(std::string(server_address));
	return g;
}

void greeter_server_destroy(greeter_server_t *g) {
	if (g == NULL) return;
	delete static_cast<GreeterServer *>(g->obj);
	free(g);
}

void greeter_server_start(greeter_server_t *g) {
	if (g == NULL) return;
	static_cast<GreeterServer *>(g->obj)->Start();
}
