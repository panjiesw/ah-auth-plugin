---
layout: doc
title: Installation
nav: install
nextDoc: /configuration.html
nextTitle: Configuration
prevDoc: /
prevTitle: Getting Started
---

The plugin heavily uses modules which depends on ``node-gyp``. For operating system specific instructions (like getting ``node-gyp`` working on Windows), read the official [node-gyp installation instructions](https://github.com/TooTallNate/node-gyp#installation).

## Install ah-nodemailer-plugin
First you have to install ah-nodemailer-plugin and save it into your actionhero app dependency.

```
npm install ah-nodemailer-plugin --save
```
Please refer to [ah-nodemailer-plugin](https://github.com/panjiesw/ah-nodemailer) page for more detailed instruction.

In the future this will be an optional step, only if you want to have email / password change / password reset verification process. For now this is a required step for ``ah-auth-plugin`` to work.

## Install ah-auth-plugin
```
npm install ah-auth-plugin --save
```
