###
#Authentication Actions
*__Author__: Panjie SW <panjie@panjiesw.com>*
*__Project__: ah-auth-plugin*
*__Company__: PanjieSW*

Defines actions related to authentication process
*********************************************
###

authenticateAction =
  name: "authenticate"
  description: "Authenticate a user"
  inputs:
    required: ['login', 'password']
    optional: []
  blockedConnectionTypes: []
  outputExample:
    token: 'The user payload encoded with JSON Web Token'
  run: (api, connection, next) ->
    api.Auth.authenticate(
      connection.params.login, connection.params.password)
    .then (token) ->
      connection.response.token = token
      next connection, yes
    .catch (err) ->
      connection.error = err
      if error.status
        connection.rawConnection.responseHttpCode = error.status
      next connection, no

signupAction =
  name: "signup"
  description: "Sign a new user up"
  inputs:
    required: ['data']
    optional: []
  blockedConnectionTypes: []
  outputExample: {}
  run: (api, connection, next) ->
    api.Auth.signUp(connection.params.data, 'password', yes)
    .then (response) ->
      if response
        connection.rawConnection.responseHttpCode = 201
        next connection, yes
    .catch (err) ->
      connection.error = err
      if error.status
        connection.rawConnection.responseHttpCode = error.status
      next connection, no

exports.authenticate = authenticateAction
exports.signup = signupAction
