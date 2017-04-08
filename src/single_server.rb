#!/usr/bin/env ruby

this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(File.dirname(this_dir), 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'singleevent_services_pb'
require 'pry'

class SingleServer < EventMessage::Service
  def send_event(req, _call)
    count = req.counter + 1
    p "#{req.some_json} hit server #{count} time's"
    # Server respond to Client
    EventPull.new(some_json: '{ color: blue }', counter: count)
  end
end

def main
  server = GRPC::RpcServer.new
  server.add_http2_port('0.0.0.0:50666', :this_port_is_insecure)
  server.handle(SingleServer)
  server.run_till_terminated
end

main