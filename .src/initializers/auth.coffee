###
#Auth Initializer
*__Author__: Panjie SW <panjie@panjiesw.com>*
*__Project__: ah-auth-plugin*
*__Company__: Panjie SW*

Defines ``api.Auth``
*********************************************
###

Q = require 'q'
_ = require 'underscore'
scrypt = require 'scrypt'
jwt = require 'jsonwebtoken'
uuid = require 'node-uuid'

AuthError = (message, code) ->
  @name = "AuthError"
  @message = message
  @code = code
  @status = 500
  return

AuthError:: = new Error()
AuthError::constructor = AuthError

ImplementationError = (message, code) ->
  @name = "ImplementationError"
  @message = message
  @code = code
  @status = 500
  return

ImplementationError:: = new Error()
ImplementationError::constructor = ImplementationError

SignupError = (message, code) ->
  @name = "SignupError"
  @message = message
  @code = code
  @status = 400
  return

SignupError:: = new Error()
SignupError::constructor = SignupError

UnauthorizedError = (message, code) ->
  @name = "UnauthorizedError"
  @message = message
  @code = code
  @status = 401
  return

UnauthorizedError:: = new Error()
UnauthorizedError::constructor = UnauthorizedError

Auth = (api, next) ->
  config = api.config.auth

  _encodePassword =
    scrypt: (password) ->
      Q.nfcall(scrypt.passwordHash, password, config.scrypt.maxtime)

  _encodePasswordPromise = (password) ->
    if Q.isPromiseAlike api.AuthImpl.encodePassword
      api.AuthImpl.encodePassword password
    else
      Q.nfcall api.AuthImpl.encodePassword, password

  encodePassword = (password, callback) ->
    if api.AuthImpl and api.AuthImpl.encodePassword
      _encodePasswordPromise(password).nodeify callback
    else
      _encodePassword['scrypt'](password).nodeify callback

  _matchPassword =
    scrypt: (passwordHash, password) ->
      deferred = Q.defer()
      scrypt.verifyHash passwordHash, password, (err, result) ->
        if err
          deferred.reject err
        else
          deferred.resolve result
      deferred.promise

  _matchPasswordPromise = (passwordHash, password) ->
    if Q.isPromiseAlike api.AuthImpl.matchPassword
      api.AuthImpl.matchPassword passwordHash, password
    else
      Q.nfcall api.AuthImpl.matchPassword, passwordHash, password

  matchPassword = (passwordHash, password, callback) ->
    deferred = Q.defer()
    if api.AuthImpl and api.AuthImpl.encodePassword
      unless api.AuthImpl.matchPassword
        deferred.reject(
          new ImplementationError(
            "No 'api.AuthImpl.matchPassword' implementation"))
      else
        _matchPasswordPromise['scrypt'](passwordHash, password)
        .then (result) ->
          deferred.resolve result
        .catch (error) ->
          deferred.reject error
    else
      _matchPassword['scrypt'](passwordHash, password)
      .then (result) ->
        deferred.resolve result
      .catch (err) ->
        error = null
        if err.err_message
          error = new UnauthorizedError(
            'Invalid credentials', 'incorrect_password')
        else
          error = new AuthError(
            err.message, 'server_error')
        deferred.reject error

    deferred.promise.nodeify callback

  signPayload = (payload, expire=config.jwt.expire) ->
    jwt.sign payload, config.jwt.secret,
      expiresInMinutes: expire
      algorithm: config.jwt.algorithm

  verifyToken = (token, options, callback) ->
    Q.ninvoke(jwt, 'verify', token, config.jwt.secret, options).nodeify callback

  _signUpPromise = (userData, uuid) ->
    if Q.isPromiseAlike api.AuthImpl.signUp
      api.AuthImpl.signUp userData, uuid
    else
      Q.nfcall api.AuthImpl.signUp, userData, uuid

  signUp = (userData, passwordField, needVerify, callback) ->
    deferred = Q.defer()

    userData.verified = !needVerify
    encodePassword(userData[passwordField])
    .then (passwordHash) ->
      userData[passwordField] = passwordHash
      unless api.AuthImpl and api.AuthImpl.signUp
        throw new ImplementationError(
          "no 'api.AuthImpl.signUp' implementation.")
      _uuid = null
      if config.enableVerification and needVerify
        _uuid = uuid.v4()
      return _signUpPromise(userData, _uuid)
    .then (data) ->
      unless data.user
        throw new ImplementationError("no 'user' field in returned hash of
          'api.AuthImpl.signUp'")
      if config.enableVerification
        unless data.uuid
          throw new ImplementationError("Verification is enabled but no 'uuid'
            field in returned hash of 'api.AuthImpl.signUp'.")
        unless api.Mailer
          throw new Error("You need to install ah-nodemailer-plugin
              to be able to send verification mail.")

        options =
          mail:
            to: data.user.email
          locals:
            uuid: data.uuid
        if data.options and data.options.template
          options.template = data.options.template
        else
          options.template = 'welcome'

        if data.options
          _.defaults options.mail, data.options.mail
          _.defaults options.locals, data.options.locals

        return api.Mailer.send options
      else
        return Q data
    .then (responseOrData) ->
      deferred.resolve true
    .catch (error) ->
      deferred.reject error

    deferred.promise.nodeify callback

  _findUserPromise = (login) ->
    if Q.isPromiseAlike api.AuthImpl.findUser
      api.AuthImpl.findUser login
    else
      Q.nfcall api.AuthImpl.findUser, login

  _jwtPayloadPromise = (user) ->
    if Q.isPromiseAlike api.AuthImpl.jwtPayload
      api.AuthImpl.jwtPayload user
    else
      Q.nfcall api.AuthImpl.jwtPayload, user

  signIn = (login, password, callback) ->
    deferred = Q.defer()
    unless api.AuthImpl and api.AuthImpl.findUser and api.AuthImpl.jwtPayload
      deferred.reject(
        new ImplementationError("no 'api.AuthImpl.findUser' and or
          'api.AuthImpl.jwtPayload' implementation.", 'signin_impl_error'))

    _findUserPromise(login)
    .then (user) ->
      Q.all [
        Q(user)
        matchPassword(user.password, password)
      ]
    .spread (user, match) ->
      if match
        return _jwtPayloadPromise user

      throw new UnauthorizedError(
        'Invalid credentials', 'incorrect_password')
    .then (data) ->
      signedPayload = signPayload data.payload, data.expire
      deferred.resolve signedPayload
    .catch (err) ->
      deferred.reject err

    deferred.promise.nodeify callback

  api.Auth =
    encodePassword: encodePassword
    matchPassword: matchPassword
    signPayload: signPayload
    verifyToken: verifyToken
    signUp: signUp
    signIn: signIn
    authenticate: signIn
    AuthError: AuthError
    ImplementationError: ImplementationError
    SignupError: SignupError
    UnauthorizedError: UnauthorizedError

  next()

exports.auth = Auth
