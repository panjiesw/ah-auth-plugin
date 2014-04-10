---
layout: doc
title: Configuration
nav: config
prevDoc: /installation.html
prevTitle: Installation
nextDoc: /usage/implementation.html
nextTitle: Implementation
---

After the plugin is installed, there will be a config file named ``auth.js`` copied to your ``/config/plugins`` folder. Below is the default value provided along with its explanation. Change / override it as you wish to meet your requirements.

## Config Values

### api.config.auth
This section contains configuration directly related to ah-auth-plugin.

- ``enableVerification=true``, Defines whether verification process is enabled. If it's enabled then a newly signed up user and password change / reset process will, by default, lead to an email sending further instructions to complete the process.

### api.config.jwt
This section contains configuration needed to sign, verify and decode JSON Web Token.

- ``secret='some-secret'``, A string or buffer containing either the secret for HMAC algorithms, or the path of PEM encoded private key for RSA and ECDSA.
- ``algorithm='HS512'``, Algorithm used in signing the json payload. See [supported algorithms](https://github.com/auth0/node-jsonwebtoken#algorithms-supported).
- ``expire=2 hours``, How long the token will expire in milisecond.

### api.config.scrypt
This section contains configuration for encoding / decoding user's password. ``scrypt`` is the default but you can define your own password hasher, as explained later in [Custom Password Hasher](/usage/custom-password-hasher.html).

- ``maxtime=0.2``, A decimal (double) representing the maxtime in seconds for running scrypt.
