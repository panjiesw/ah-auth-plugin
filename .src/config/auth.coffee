###
#Auth Configuration
*__Author__: Panjie SW <panjie@panjiesw.com>*
*__Project__: ah-auth-plugin*
*__Company__: PanjieSW*

Defines configuration for Auth plugin.
*********************************************
###

exports['default'] = auth: (api) ->
  ###
  Verification process.
  If it's enabled then a newly signed up
  user will have to verify their email account
  before able to sign in. Defaults to ``true``.
  ###
  enableVerification: yes

  ###
  JSON Web Token configurations.
  ###
  jwt:
    ###
    Secret string used in signing the json payload.
    Be sure to change this in production.
    ###
    secret: 'some-secret'
    ###
    Algorithm used in signing the json payload.
    See https://github.com/auth0/node-jsonwebtoken#algorithms-supported
    for list of supported algorithms. Defaults to ``HS512``.
    ###
    algorithm: "HS512"
    ###
    How long the token will expire in milisecond.
    If the token is expired then the signed in
    user has to relogin. Defaults to 2 hours time.
    ###
    expire: 2*60*60*1000

  ###
  Scrypt configurations.
  Scrypt is used in encoding the user's password
  before saving it to database. Also for verifying it
  later in signin process.
  ###
  scrypt:
    # Password hash maxtime used in encoding password, in second.
    maxtime: 0.2
