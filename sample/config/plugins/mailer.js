
/*
 *Mailer Configuration
*__Author__: Panjie SW <panjie@panjiesw.com>*
*__Project__: ah-nodemailer-plugin*
*__Company__: PanjieSW*

Defines configuration for Mailer.
*********************************************
 */

(function() {
  exports["default"] = {
    mailer: function(api) {
      return {

        /*
        Type of transport to use.
        See [nodemailer](http://www.nodemailer.com/docs/transports).
        If set to ``stdout``, no email will be sent,
        instead it will be piped to stdout.
         */
        transport: "stdout",

        /*
        This is an example of options to use in transport creation, using SMTP.
        For other nodemailer supported transport, please see nodemailer's site.
         */
        options: {

          /*
          an optional well known service identifier ("Gmail", "Hotmail" etc.,
          see Well known Services for a list of supported services)
          to auto-configure host, port and secure connection settings
           */
          service: "Gmail",
          host: "smtp.example.com",
          port: 25,
          secureConnection: false,
          name: "example-mailer",
          auth: {
            user: "email.user@example.com",
            pass: "some_password"
          }
        },

        /*
        Default options when sending email.
        Define other fields here if you wish.
         */
        mailOptions: {
          from: "admin@somewhere.com"
        },

        /*
        Email templates directory.
        Defaults to root `templates` directory.
         */
        templates: "" + __dirname + "/../../templates"
      };
    }
  };

}).call(this);
