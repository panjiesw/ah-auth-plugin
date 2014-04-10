---
layout: doc
title: Getting Started
nav: intro
lead: ActionHero Authentication Plugin - A Stateless authentication plugin for actionhero.js API Server.
nextDoc: /installation.html
nextTitle: Installation
---

[ah-auth-plugin](https://github.com/panjiesw/ah-auth-plugin) is a plugin for [actionhero](http://actionherojs.com) which enables stateless authentication to API Server using [JSON Web Token](http://self-issued.info/docs/draft-ietf-oauth-json-web-token.html). It doesn't enforce you to use a certain database to persist user data, nor it uses any session or cache to store the user state. Instead, with some interface you provide using the nice ``api`` object of actionhero, it abstracts only the authentication flow for you. This flow is somewhat similiar to those in [securesocial](http://securesocial.ws), an authentication plugin for [Play Framework](http://playframework.com).

## Features
- Stateless, via JSON Web Token
- Database-agnostic
- Email verification, via [ah-nodemailer-plugin](http://github.com/panjiesw/ah-nodemailer-plugin)
- Easy configuration
- Extendable

## Dependency
- node ``>=0.10 and <0.11``
- [actionhero](https://github.com/evantahler/actionhero) ``>=8.0.0``
- [ah-nodemailer-plugin](http://github.com/panjiesw/ah-nodemailer-plugin), ``>=0.0.4``
- [node-jsonwebtoken](https://github.com/auth0/node-jsonwebtoken), ``>=0.2.0``
- node-gyp, for building ``scypt`` and ``email-templates`` package.
    For operating system specific instructions (like getting ``node-gyp`` working on Windows), read the official [node-gyp installation instructions](https://github.com/TooTallNate/node-gyp#installation).
