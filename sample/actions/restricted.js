var action = {};

/////////////////////////////////////////////////////////////////////
// metadata
action.name = 'restricted';
action.description = 'I only accessible to authenticated user';
action.inputs = {
  'required' : [],
  'optional' : []
};
action.blockedConnectionTypes = [];
action.outputExample = {};
action.authenticate = true;

/////////////////////////////////////////////////////////////////////
// functional
action.run = function(api, connection, next){
  connection.response.user = connection.user;
  next(connection, true);
};

/////////////////////////////////////////////////////////////////////
// exports
exports.action = action;
