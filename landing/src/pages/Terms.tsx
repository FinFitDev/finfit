import { Link } from "react-router-dom";
import { ArrowLeft } from "lucide-react";
import logo from "@/assets/logo.png";

const Terms = () => {
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
          <h1 className="text-3xl md:text-4xl font-bold mb-2">Terms of Use</h1>
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
              <h2 className="text-2xl font-semibold mb-4">
                1. Acceptance of Terms
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                By accessing or using the FinFit mobile application ("App"), you
                agree to be bound by these Terms of Use. If you do not agree to
                these terms, please do not use the App.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">2. Eligibility</h2>
              <p className="text-muted-foreground leading-relaxed">
                You must be at least 13 years of age to use the App. By using
                the App, you represent and warrant that you meet this
                eligibility requirement and have the legal capacity to enter
                into these Terms.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                3. Account Registration
              </h2>
              <p className="text-muted-foreground leading-relaxed mb-4">
                To use certain features of the App, you must create an account.
                You agree to:
              </p>
              <ul className="list-disc list-inside text-muted-foreground space-y-2 ml-4">
                <li>Provide accurate and complete registration information</li>
                <li>Maintain the security of your password</li>
                <li>Notify us immediately of any unauthorized access</li>
                <li>
                  Accept responsibility for all activities under your account
                </li>
              </ul>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                4. Points and Rewards System
              </h2>
              <p className="text-muted-foreground leading-relaxed mb-4">
                The FinFit points and rewards system operates under the
                following conditions:
              </p>
              <ul className="list-disc list-inside text-muted-foreground space-y-2 ml-4">
                <li>Points are earned through tracked physical activities</li>
                <li>
                  Points have no cash value and cannot be exchanged for money
                </li>
                <li>
                  We reserve the right to modify point values and earning rates
                </li>
                <li>Points may expire according to our current policies</li>
                <li>
                  Fraudulent activity will result in account termination and
                  point forfeiture
                </li>
                <li>
                  Rewards are subject to availability and partner participation
                </li>
              </ul>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                5. Point Transfers
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                Users may transfer points to other FinFit users. Point transfers
                are final and cannot be reversed. We are not responsible for
                transfers made in error. We reserve the right to limit or
                suspend point transfer functionality at any time.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                6. Third-Party Integrations
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                The App may integrate with third-party services such as Strava.
                Your use of these integrations is subject to the third party's
                terms of service. We are not responsible for the availability,
                accuracy, or functionality of third-party services.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">7. Acceptable Use</h2>
              <p className="text-muted-foreground leading-relaxed mb-4">
                You agree not to:
              </p>
              <ul className="list-disc list-inside text-muted-foreground space-y-2 ml-4">
                <li>Use the App for any unlawful purpose</li>
                <li>Manipulate or falsify activity data</li>
                <li>Use automated systems to earn points</li>
                <li>Share your account credentials with others</li>
                <li>Attempt to circumvent any security features</li>
                <li>Harass or harm other users</li>
                <li>Violate any applicable laws or regulations</li>
              </ul>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                8. Intellectual Property
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                The App and its content, features, and functionality are owned
                by FinFit and are protected by intellectual property laws. You
                may not copy, modify, distribute, or create derivative works
                without our prior written consent.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                9. Disclaimer of Warranties
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                THE APP IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND. WE
                DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING
                MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
                NON-INFRINGEMENT. WE DO NOT WARRANT THAT THE APP WILL BE
                UNINTERRUPTED OR ERROR-FREE.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                10. Limitation of Liability
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                TO THE MAXIMUM EXTENT PERMITTED BY LAW, FINFIT SHALL NOT BE
                LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR
                PUNITIVE DAMAGES ARISING FROM YOUR USE OF THE APP.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">11. Termination</h2>
              <p className="text-muted-foreground leading-relaxed">
                We may terminate or suspend your account at any time for any
                reason, including violation of these Terms. Upon termination,
                your right to use the App ceases immediately, and any
                accumulated points may be forfeited.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                12. Changes to Terms
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                We reserve the right to modify these Terms at any time. We will
                notify you of material changes through the App or via email.
                Your continued use of the App after changes constitutes
                acceptance of the modified Terms.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">13. Governing Law</h2>
              <p className="text-muted-foreground leading-relaxed">
                These Terms shall be governed by and construed in accordance
                with applicable laws, without regard to conflict of law
                principles.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                14. Contact Information
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                For questions about these Terms, please contact us at:
              </p>
              <p className="text-primary font-medium mt-2">legal@finfit.app</p>
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

export default Terms;
