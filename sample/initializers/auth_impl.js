/**
 * Auth Implementation Initializer example.
 */

 exports.auth_impl = function(api, next) {

  var users = [];
  var activationTokens = [];

  api.AuthImpl = {};
  api.AuthImpl.signUp = function(userData, uuid, callback) {
    users.push(userData);
    activationTokens.push({uuid: uuid});
    var data = {
      user: userData,
      uuid: uuid,
      options: {
        locals: {
          firstName: userData.firstName,
          lastName: userData.lastName
        }
      }
    };

    // No error here, so the first argument of callback is null.
    callback(null, data);
  };

  api.AuthImpl.findUser = function(login, callback) {
    for (var i = users.length - 1; i >= 0; i--) {
      if (users[i].username == login) {
        // No error here, user is found, so the first argument of callback is null.
        callback(null, users[i]);
        return;
      }
    }
    // No user is found.
    callback(new Error('No user found'), null);
  };

  api.AuthImpl.jwtPayload = function(user, callback) {
    // We remove the user's password from soon to be signed jwt payload.
    var payload = JSON.parse(JSON.stringify(user));
    delete payload.password;
    callback(null, {payload: payload});
  };

  next();

 };
