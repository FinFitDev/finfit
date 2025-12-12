import { Link } from "react-router-dom";
import { Instagram, Twitter, Facebook, Linkedin } from "lucide-react";
import logo from "../assets/logo.png";

const Footer = () => {
  const socialLinks = [
    { icon: Instagram, href: "#", label: "Instagram" },
    { icon: Twitter, href: "#", label: "Twitter" },
    { icon: Facebook, href: "#", label: "Facebook" },
    { icon: Linkedin, href: "#", label: "LinkedIn" },
  ];

  return (
    <footer className="bg-foreground text-background py-16">
      <div className="container">
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-12 mb-12">
          {/* Brand */}
          <div className="lg:col-span-2">
            <Link to="/" className="inline-flex items-center gap-3 mb-4">
              <img
                src={logo}
                alt="FinFit Logo"
                className="h-12 w-12 rounded-xl"
              />
              <span className="text-2xl font-bold">FinFit</span>
            </Link>
            <p className="text-background/70 max-w-md mb-6">
              Zamieniaj swoją aktywność na realne nagrody. Śledź treningi,
              zdobywaj punkty i korzystaj ze zniżek u naszych partnerów.
            </p>
            <div className="flex gap-4">
              {socialLinks.map((social) => (
                <a
                  key={social.label}
                  href={social.href}
                  aria-label={social.label}
                  className="w-10 h-10 rounded-full bg-background/10 flex items-center justify-center hover:bg-primary transition-colors"
                >
                  <social.icon className="w-5 h-5" />
                </a>
              ))}
            </div>
          </div>

          {/* Quick Links */}
          <div>
            <h4 className="font-semibold text-lg mb-4">Szybkie linki</h4>
            <ul className="space-y-3">
              <li>
                <a
                  href="#features"
                  className="text-background/70 hover:text-background/50 ransition-colors"
                >
                  Funkcje
                </a>
              </li>
              <li>
                <a
                  href="#how-it-works"
                  className="text-background/70 hover:text-background/50 transition-colors"
                >
                  Jak to działa
                </a>
              </li>
              <li>
                <a
                  href="#rewards"
                  className="text-background/70 hover:text-background/50 transition-colors"
                >
                  Nagrody
                </a>
              </li>
              <li>
                <a
                  href="#download"
                  className="text-background/70 hover:text-background/50 transition-colors"
                >
                  Pobierz aplikację
                </a>
              </li>
            </ul>
          </div>

          {/* Legal */}
          <div>
            <h4 className="font-semibold text-lg mb-4">Informacje prawne</h4>
            <ul className="space-y-3">
              <li>
                <Link
                  to="/privacy"
                  className="text-background/70 hover:text-background/50 transition-colors"
                >
                  Polityka prywatności
                </Link>
              </li>
              <li>
                <Link
                  to="/terms"
                  className="text-background/70 hover:text-background/50 transition-colors"
                >
                  Regulamin
                </Link>
              </li>
              <li>
                <a
                  href="#"
                  className="text-background/70 hover:text-background/50 transition-colors"
                >
                  Kontakt
                </a>
              </li>
            </ul>
          </div>
        </div>

        {/* Bottom bar */}
        <div className="pt-8 border-t border-background/10 flex flex-col md:flex-row justify-between items-center gap-4">
          <p className="text-background/60 text-sm">
            © {new Date().getFullYear()} FinFit. Wszelkie prawa zastrzeżone.
          </p>
          <div className="flex items-center gap-2">
            <span className="strava-badge text-xs">
              <svg className="w-3 h-3" viewBox="0 0 24 24" fill="currentColor">
                <path d="M15.387 17.944l-2.089-4.116h-3.065L15.387 24l5.15-10.172h-3.066m-7.008-5.599l2.836 5.598h4.172L10.463 0l-7.008 13.828h4.172" />
              </svg>
              Partner Strava
            </span>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
