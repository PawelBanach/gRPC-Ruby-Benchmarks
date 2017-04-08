#!/usr/bin/env ruby

this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(File.dirname(this_dir), 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'singleevent_services_pb'
require 'pry'
require 'benchmark'

def main
  stub = EventMessage::Stub.new('localhost:50666', :this_channel_is_insecure)
  msgs_per_sec = ARGV.size > 0 ? ARGV[0].to_i : 10
  client = ARGV.size > 1 ? ARGV[1] : 'Client'
  server_hits = 0
  while(true)
    # Meassure time to hit server, and take answer
    Benchmark.bm do |x|
      x.report { stub.send_event(EventPush.new(some_json: client, counter: server_hits)) }
    end
    server_hits += 1
    sleep 1/msgs_per_sec
  end
end

main