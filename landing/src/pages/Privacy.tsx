import { Link } from "react-router-dom";
import { ArrowLeft } from "lucide-react";
import logo from "@/assets/logo.png";

const Privacy = () => {
  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="border-b border-border bg-background/80 backdrop-blur-md sticky top-0 z-50">
        <div className="container flex items-center justify-between h-16 md:h-20">
          <Link to="/" className="flex items-center gap-3">
            <img
              src={logo}
              alt="FinFit Logo"
              className="h-10 w-10 rounded-xl"
            />
            <span className="text-xl font-bold text-gradient">FinFit</span>
          </Link>
          <Link
            to="/"
            className="flex items-center gap-2 text-muted-foreground hover:text-foreground transition-colors"
          >
            <ArrowLeft className="w-4 h-4" />
            Back to Home
          </Link>
        </div>
      </header>

      {/* Content */}
      <main className="container py-12 md:py-20">
        <div className="max-w-3xl mx-auto">
          <h1 className="text-3xl md:text-4xl font-bold mb-2">
            Privacy Policy
          </h1>
          <p className="text-muted-foreground mb-8">
            Last updated:{" "}
            {new Date().toLocaleDateString("en-US", {
              month: "long",
              day: "numeric",
              year: "numeric",
            })}
          </p>

          <div className="prose prose-lg max-w-none space-y-8">
            <section>
              <h2 className="text-2xl font-semibold mb-4">1. Introduction</h2>
              <p className="text-muted-foreground leading-relaxed">
                Welcome to FinFit ("we," "our," or "us"). We are committed to
                protecting your personal information and your right to privacy.
                This Privacy Policy explains how we collect, use, disclose, and
                safeguard your information when you use our mobile application.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                2. Information We Collect
              </h2>
              <p className="text-muted-foreground leading-relaxed mb-4">
                We collect information that you provide directly to us,
                including:
              </p>
              <ul className="list-disc list-inside text-muted-foreground space-y-2 ml-4">
                <li>Account information (name, email address, password)</li>
                <li>Profile information (profile picture, fitness goals)</li>
                <li>
                  Activity data (GPS location during workouts, distance,
                  duration, pace)
                </li>
                <li>
                  Strava account data when connected (workout history, activity
                  types)
                </li>
                <li>Points balance and reward redemption history</li>
                <li>Transaction data when sharing points with other users</li>
              </ul>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                3. How We Use Your Information
              </h2>
              <p className="text-muted-foreground leading-relaxed mb-4">
                We use the information we collect to:
              </p>
              <ul className="list-disc list-inside text-muted-foreground space-y-2 ml-4">
                <li>Provide, maintain, and improve our services</li>
                <li>
                  Track your fitness activities and calculate earned points
                </li>
                <li>Process reward redemptions and point transfers</li>
                <li>Sync with third-party services like Strava</li>
                <li>Send you notifications about your account and rewards</li>
                <li>Communicate with you about updates and promotions</li>
                <li>Ensure the security and integrity of our platform</li>
              </ul>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                4. Sharing of Information
              </h2>
              <p className="text-muted-foreground leading-relaxed mb-4">
                We may share your information in the following circumstances:
              </p>
              <ul className="list-disc list-inside text-muted-foreground space-y-2 ml-4">
                <li>With partner merchants when you redeem rewards</li>
                <li>With Strava when you connect your account</li>
                <li>With service providers who assist our operations</li>
                <li>To comply with legal obligations</li>
                <li>With your consent or at your direction</li>
              </ul>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">5. Data Security</h2>
              <p className="text-muted-foreground leading-relaxed">
                We implement appropriate technical and organizational security
                measures to protect your personal information. However, no
                method of transmission over the Internet or electronic storage
                is 100% secure, and we cannot guarantee absolute security.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">6. Your Rights</h2>
              <p className="text-muted-foreground leading-relaxed mb-4">
                Depending on your location, you may have the following rights:
              </p>
              <ul className="list-disc list-inside text-muted-foreground space-y-2 ml-4">
                <li>Access your personal data</li>
                <li>Correct inaccurate data</li>
                <li>Delete your personal data</li>
                <li>Object to processing of your data</li>
                <li>Data portability</li>
                <li>Withdraw consent at any time</li>
              </ul>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                7. Third-Party Services
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                Our app integrates with Strava. When you connect your Strava
                account, their privacy policy applies to the data they collect.
                We encourage you to review Strava's privacy policy before
                connecting your account.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                8. Children's Privacy
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                Our service is not intended for users under the age of 13. We do
                not knowingly collect personal information from children under
                13. If we become aware of such collection, we will take steps to
                delete that information.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                9. Changes to This Policy
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                We may update this Privacy Policy from time to time. We will
                notify you of any changes by posting the new Privacy Policy on
                this page and updating the "Last updated" date.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">10. Contact Us</h2>
              <p className="text-muted-foreground leading-relaxed">
                If you have any questions about this Privacy Policy, please
                contact us at:
              </p>
              <p className="text-primary font-medium mt-2">
                privacy@finfit.app
              </p>
            </section>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="border-t border-border py-8">
        <div className="container text-center text-muted-foreground text-sm">
          © {new Date().getFullYear()} FinFit. All rights reserved.
        </div>
      </footer>
    </div>
  );
};

export default Privacy;
