import nodemailer from "nodemailer";
import SMTPTransport from "nodemailer/lib/smtp-transport";
import { readFile } from "./fileHandler";
import path from "path";

let _transporter: nodemailer.Transporter<
  SMTPTransport.SentMessageInfo,
  SMTPTransport.Options
> | null = null;

export const getTransporter = () => {
  if (!_transporter) {
    _transporter = nodemailer.createTransport({
      service: "gmail",
      auth: {
        user: "finfit.app.contact@gmail.com",
        pass: "seja qcbq gsqk szif",
      },
    });
  }

  return _transporter;
};

export const sendVerificationEmail = async (
  userEmail: string,
  token: string,
  username: string
) => {
  const transporter = getTransporter();

  const htmlContent = readFile(
    path.join(__dirname, "../../../views/email/verify.html")
  );
  const emailHtml = htmlContent
    .replace("{{USERNAME}}", username)
    .replace("{{TOKEN}}", token);

  const mailOptions = {
    from: "finfit.app.contact@gmail.com",
    to: userEmail,
    subject: "Verify Your Email",
    html: emailHtml,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log("Verification email sent");
  } catch (error) {
    console.error("Error sending email:", error);
  }
};

export const sendPasswordResetEmail = async (
  userEmail: string,
  code: string,
  username: string
) => {
  const transporter = getTransporter();

  const htmlContent = readFile(
    path.join(__dirname, "../../../views/email/verify.html")
  );
  const emailHtml = htmlContent
    .replace("{{USERNAME}}", username)
    .replace("{{CODE}}", code);

  const mailOptions = {
    from: "finfit.app.contact@gmail.com",
    to: userEmail,
    subject: "Reset your password",
    html: emailHtml,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log("Reset password email sent");
  } catch (error) {
    console.error("Error sending email:", error);
  }
};
