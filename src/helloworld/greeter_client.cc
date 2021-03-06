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

#include <grpcpp/grpcpp.h>

#ifdef BAZEL_BUILD
#include "src/protos/helloworld.grpc.pb.h"
#include "src/helloworld/greeter_client.h"
#else
#include "helloworld.grpc.pb.h"
#endif

using grpc::Channel;
using grpc::ClientContext;
using grpc::Status;
using helloworld::Greeter;
using helloworld::HelloReply;
using helloworld::HelloRequest;

class GreeterClient {
 public:
  GreeterClient(std::shared_ptr<Channel> channel)
      : stub_(Greeter::NewStub(channel)) {}

  // Assembles the client's payload, sends it and presents the response back
  // from the server.
  std::string SayHello(const std::string& user) {
    // Data we are sending to the server.
    HelloRequest request;
    request.set_name(user);

    // Container for the data we expect from the server.
    HelloReply reply;

    // Context for the client. It could be used to convey extra information to
    // the server and/or tweak certain RPC behaviors.
    ClientContext context;

    // The actual RPC.
    Status status = stub_->SayHello(&context, request, &reply);

    // Act upon its status.
    if (status.ok()) {
      return reply.message();
    } else {
      std::cout << status.error_code() << ": " << status.error_message()
                << std::endl;
      return "RPC failed";
    }
  }

 private:
  std::unique_ptr<Greeter::Stub> stub_;
};

struct greeter_client {
	void *obj;
};

greeter_client_t *greeter_client_create(char* target) {
	auto g = (struct greeter_client *)malloc(sizeof(struct greeter_client));
	g->obj = new GreeterClient(grpc::CreateChannel(std::string(target), grpc::InsecureChannelCredentials()));
	return g;
}

void greeter_client_destroy(greeter_client_t *g) {
	if (g == NULL) return;
	delete static_cast<GreeterClient *>(g->obj);
	free(g);
}

const char* greeter_client_say_hello(greeter_client_t *g, char* user) {
	if (g == NULL) return "";
	std::string reply = static_cast<GreeterClient *>(g->obj)->SayHello(strdup(user));
  return strdup(reply.c_str());
}
