const functions = require("firebase-functions");
const nodemailer = require("nodemailer");
const cors = require("cors")({origin: true});

// Configure the email transport using the default SMTP transport and a Gmail account.
const gmailEmail = functions.config().gmail.email;
const gmailPassword = functions.config().gmail.password;

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: gmailEmail,
    pass: gmailPassword
  }
});

// Create a function that sends an email when the endpoint is hit.
exports.sendEmail = functions.https.onRequest((req, res) => {
  cors(req, res, () => {
    const mailOptions = {
      from: gmailEmail,
      to: req.body.to, // Email address to send the email
      subject: req.body.subject, // Subject of the email
      text: req.body.text // Email body
    };

    // Send the email using the defined transport object
    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.error("Error sending email:", error);
        return res.status(500).send(error.toString());
      }
      console.log("Email sent:", info.response);
      return res.status(200).send("Email sent: " + info.response);
    });
  });
});
