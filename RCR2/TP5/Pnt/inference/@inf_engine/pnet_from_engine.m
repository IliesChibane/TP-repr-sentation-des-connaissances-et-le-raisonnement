function pnet = pnet_from_engine(engine)
% pnet_FROM_ENGINE Return the pnet structure stored inside the engine (inf_engine)
% pnet = pnet_from_engine(engine)

pnet = engine.pnet;

% We cannot write 'engine.pnet' without writing a 'subsref' function,
% since engine is an object with private parts.
% The pnet field should be the only thing external users of the engine should need access to.
% We do not pass pnet as a separate argument, since it could get out of synch with the one
% encoded inside the engine.
       
