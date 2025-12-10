import { ArrowRight, Play } from "lucide-react";
import logo from "@/assets/logo.png";

const Hero = () => {
  return (
    <section className="relative pt-24 md:pt-32 pb-16 md:pb-24 overflow-hidden gradient-hero px-[24px]">
      {/* Background decoration */}
      <div className="absolute top-20 right-0 w-96 h-96 bg-primary/10 rounded-full blur-3xl -z-10" />
      <div className="absolute bottom-0 left-0 w-64 h-64 bg-primary/5 rounded-full blur-3xl -z-10" />

      <div className="container">
        <div className="grid lg:grid-cols-2 gap-12 lg:gap-8 items-center">
          {/* Left content */}
          <div className="text-center lg:text-left space-y-6 md:space-y-8">
            <h1
              className="text-5xl md:text-6xl lg:text-7xl font-bold !leading-[1.1] animate-fade-up"
              style={{ animationDelay: "0.1s" }}
            >
              Trenuj. <span className="text-gradient">Zarabiaj.</span>{" "}
              Korzystaj.
            </h1>

            <p
              className="text-lg md:text-xl text-muted-foreground max-w-xl mx-auto lg:mx-0 animate-fade-up"
              style={{ animationDelay: "0.2s" }}
            >
              Śledź swoje treningi i aktywności. Zdobywaj punkty za każdą
              aktywność. Wymieniaj je na świetne zniżki w swoich ulubionych
              sklepach.
            </p>

            <div
              className="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start animate-fade-up"
              style={{ animationDelay: "0.3s" }}
            >
              <a href="#download" className="btn-primary group">
                Pobierz za darmo
                <ArrowRight className="ml-2 w-5 h-5 group-hover:translate-x-1 transition-transform" />
              </a>
              <a href="#how-it-works" className="btn-outline group">
                <Play className="mr-2 w-5 h-5" />
                Jak to działa
              </a>
            </div>

            {/* Stats */}
            <div
              className="flex gap-8 md:gap-12 justify-center lg:justify-start pt-4 animate-fade-up"
              style={{ animationDelay: "0.4s" }}
            >
              <div>
                <p className="text-2xl md:text-3xl font-bold text-foreground">
                  Rosnąca
                </p>
                <p className="text-sm text-muted-foreground">Społeczność</p>
              </div>

              <div>
                <p className="text-2xl md:text-3xl font-bold text-foreground">
                  Nowi
                </p>
                <p className="text-sm text-muted-foreground">Partnerzy</p>
              </div>
            </div>
          </div>

          {/* Right - Phone mockup */}
          <div
            className="relative flex justify-center lg:justify-end animate-slide-in-right"
            style={{ animationDelay: "0.3s" }}
          >
            <div className="relative">
              {/* Main phone */}
              <div className="phone-mockup w-64 md:w-72 animate-float">
                <div className="phone-screen aspect-[9/19] flex items-center justify-center bg-gradient-to-br from-primary/20 to-primary/5">
                  <div className="text-center p-6">
                    <img
                      src={logo}
                      alt="FinFit"
                      className="w-20 h-20 mx-auto mb-4 rounded-2xl"
                    />
                    <p className="text-sm text-muted-foreground font-medium">
                      App Screenshot
                    </p>
                    <p className="text-xs text-muted-foreground/70 mt-1">
                      Coming Soon
                    </p>
                  </div>
                </div>
              </div>

              {/* Floating Strava badge */}
              <div
                className="absolute -right-4 md:-right-8 top-1/4 animate-float"
                style={{ animationDelay: "0.5s" }}
              >
                <div className="strava-badge shadow-lg">
                  <svg
                    className="w-4 h-4"
                    viewBox="0 0 24 24"
                    fill="currentColor"
                  >
                    <path d="M15.387 17.944l-2.089-4.116h-3.065L15.387 24l5.15-10.172h-3.066m-7.008-5.599l2.836 5.598h4.172L10.463 0l-7.008 13.828h4.172" />
                  </svg>
                  Connected
                </div>
              </div>

              {/* Floating points badge */}
              <div
                className="absolute -left-4 md:-left-8 bottom-1/4 animate-float"
                style={{ animationDelay: "1s" }}
              >
                <div className="px-4 py-2 rounded-full bg-card shadow-card-hover text-sm font-semibold">
                  <span className="text-primary">+50</span> pts
                </div>
              </div>

              <div
                className="absolute -left-4 md:-left-[70px] top-1/3 animate-float"
                style={{ animationDelay: "1s" }}
              >
                <div className="px-4 py-2 rounded-full btn-primary shadow-card-hover text-md font-semibold">
                  -12% discount
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Hero;
