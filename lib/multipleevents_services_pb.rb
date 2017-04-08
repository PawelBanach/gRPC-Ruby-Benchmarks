# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: multipleevents.proto for package ''

require 'grpc'
require 'multipleevents_pb'

module EventMessage
  class Service

    include GRPC::GenericService

    self.marshal_class_method = :encode
    self.unmarshal_class_method = :decode
    self.service_name = 'EventMessage'

    # Sends multiple events
    rpc :SendEvent, stream(EventPush), stream(EventPull)
  end

  Stub = Service.rpc_stub_class
end
