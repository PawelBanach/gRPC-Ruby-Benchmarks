#!/usr/bin/env ruby

this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(File.dirname(this_dir), 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'multipleevents_services_pb'
require 'pry'

class MultiServer < EventMessage::Service
  def send_event(events)
    EventEnumerator.new(events).each_event
  end
end

class EventEnumerator
  def initialize(events)
    @events = events
  end

  def each_event
    return enum_for(:each_event) unless block_given?
    begin
      @events.each do |event|
        p "#{event.some_json} hit server #{event.counter} with event #{event.num_cli_event} "
        yield EventPull.new(some_json: 'server', counter: event.counter + 1, num_serv_event: event.num_cli_event)
      end
    rescue StandardError => e
      fail e # signal completion via an error
    end
  end
end

def main
  server = GRPC::RpcServer.new
  server.add_http2_port('0.0.0.0:50666', :this_port_is_insecure)
  server.handle(MultiServer)
  server.run_till_terminated
end

main