# Generated by the gRPC Python protocol compiler plugin. DO NOT EDIT!
"""Client and server classes corresponding to protobuf-defined services."""
import grpc

import swdc_comfort_seats_pb2 as swdc__comfort__seats__pb2


class SeatsStub(object):
    """*
    @brief 
    
    """

    def __init__(self, channel):
        """Constructor.

        Args:
            channel: A grpc.Channel.
        """
        self.Move = channel.unary_unary(
                '/swdc.comfort.Seats/Move',
                request_serializer=swdc__comfort__seats__pb2.MoveRequest.SerializeToString,
                response_deserializer=swdc__comfort__seats__pb2.MoveReply.FromString,
                )
        self.MoveComponent = channel.unary_unary(
                '/swdc.comfort.Seats/MoveComponent',
                request_serializer=swdc__comfort__seats__pb2.MoveComponentRequest.SerializeToString,
                response_deserializer=swdc__comfort__seats__pb2.MoveComponentReply.FromString,
                )
        self.CurrentPosition = channel.unary_unary(
                '/swdc.comfort.Seats/CurrentPosition',
                request_serializer=swdc__comfort__seats__pb2.CurrentPositionRequest.SerializeToString,
                response_deserializer=swdc__comfort__seats__pb2.CurrentPositionReply.FromString,
                )


class SeatsServicer(object):
    """*
    @brief 
    
    """

    def Move(self, request, context):
        """Set the desired seat position 
        """
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def MoveComponent(self, request, context):
        """Set a seat component position 
        """
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def CurrentPosition(self, request, context):
        """Get the current position of the seat 
        """
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')


def add_SeatsServicer_to_server(servicer, server):
    rpc_method_handlers = {
            'Move': grpc.unary_unary_rpc_method_handler(
                    servicer.Move,
                    request_deserializer=swdc__comfort__seats__pb2.MoveRequest.FromString,
                    response_serializer=swdc__comfort__seats__pb2.MoveReply.SerializeToString,
            ),
            'MoveComponent': grpc.unary_unary_rpc_method_handler(
                    servicer.MoveComponent,
                    request_deserializer=swdc__comfort__seats__pb2.MoveComponentRequest.FromString,
                    response_serializer=swdc__comfort__seats__pb2.MoveComponentReply.SerializeToString,
            ),
            'CurrentPosition': grpc.unary_unary_rpc_method_handler(
                    servicer.CurrentPosition,
                    request_deserializer=swdc__comfort__seats__pb2.CurrentPositionRequest.FromString,
                    response_serializer=swdc__comfort__seats__pb2.CurrentPositionReply.SerializeToString,
            ),
    }
    generic_handler = grpc.method_handlers_generic_handler(
            'swdc.comfort.Seats', rpc_method_handlers)
    server.add_generic_rpc_handlers((generic_handler,))


 # This class is part of an EXPERIMENTAL API.
class Seats(object):
    """*
    @brief 
    
    """

    @staticmethod
    def Move(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(request, target, '/swdc.comfort.Seats/Move',
            swdc__comfort__seats__pb2.MoveRequest.SerializeToString,
            swdc__comfort__seats__pb2.MoveReply.FromString,
            options, channel_credentials,
            insecure, call_credentials, compression, wait_for_ready, timeout, metadata)

    @staticmethod
    def MoveComponent(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(request, target, '/swdc.comfort.Seats/MoveComponent',
            swdc__comfort__seats__pb2.MoveComponentRequest.SerializeToString,
            swdc__comfort__seats__pb2.MoveComponentReply.FromString,
            options, channel_credentials,
            insecure, call_credentials, compression, wait_for_ready, timeout, metadata)

    @staticmethod
    def CurrentPosition(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(request, target, '/swdc.comfort.Seats/CurrentPosition',
            swdc__comfort__seats__pb2.CurrentPositionRequest.SerializeToString,
            swdc__comfort__seats__pb2.CurrentPositionReply.FromString,
            options, channel_credentials,
            insecure, call_credentials, compression, wait_for_ready, timeout, metadata)
