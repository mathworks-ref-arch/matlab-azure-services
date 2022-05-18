function subscriber = subscribe(obj)
% SUBSCRIBE Subscribe to this Mono and request unbounded demand
% Used to trigger the device code challenge flow.
% Returns a Java reactor.core.publisher.LambdaMonoSubscriber object.
% The return value is not normally required.

% Copyright 2021 The MathWorks, Inc.

subscriber = obj.Handle.subscribe();

end