# gRPC-Ruby-Benchmarks
Few benchmarks in Ruby to verify connection speed between client and server (with bidirectional streaming examples).

## Overview
Environment setup: http://www.grpc.io/docs/tutorials/basic/ruby.html

Proto files are in folder /protos

Generated server and client are in /lib 

## Usage
To run server just type:

`./src/single_server.rb`
 
 or to run bidirectional streaming server:
 
 `./src/multi_server.rb`

To run client type:

`./src/single_client.rb <message_per_second> <client_name>`

or to run bidirectional streaming client:

`./src/multi_client.rb <message_per_second> <client_name>`
