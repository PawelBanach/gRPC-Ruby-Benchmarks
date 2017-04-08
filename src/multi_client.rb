#!/usr/bin/env ruby

this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(File.dirname(this_dir), 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'multipleevents_services_pb'
require 'pry'
require 'benchmark'

def run_send_event(stub, events)
  p 'Sending 10 000 events'
  p '---------------------'
  event_enumerator = EventEnumerator.new(events)
  stub.send_event(event_enumerator.each_event)
end

class EventEnumerator
  def initialize(events)
    @events = events
  end

  def each_event
    return enum_for(:each_event) unless block_given?
    begin
      @events.each do |event|
        yield event
      end
    rescue StandardError => e
      fail e # signal completion via an error
    end
  end
end

def main
  # Connect
  stub = EventMessage::Stub.new('localhost:50666', :this_channel_is_insecure)

  msgs_per_sec = ARGV.size > 0 ? ARGV[0].to_i : 10
  client = ARGV.size > 1 ? ARGV[1] : 'Client'

  server_hits = 0
  events = []
  while(true)
    # Create 10 000 events
    (0..10000).each do |i|
      events << EventPush.new(some_json: client, counter: server_hits, num_cli_event: i)
    end

    # Meassure time to hit server, and take answer
    Benchmark.bm do |x|
      x.report { run_send_event(stub, event_pulls) }
    end

    server_hits += 1
    events = []
    sleep 1/msgs_per_sec
  end
end

main