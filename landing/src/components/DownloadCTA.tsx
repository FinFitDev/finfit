import appScreenshotHero from "@/assets/app_hero.png";
import googlePlay from "@/assets/google_play.png";
import logo from "@/assets/logo.png";
import appStore from "@/assets/appstore.png";

const DownloadCTA = () => {
  return (
    <section id="download" className="py-20 md:py-28">
      <div className="container">
        <div className="relative gradient-primary rounded-3xl p-8 md:p-16 overflow-hidden">
          {/* Background decorations */}
          <div className="absolute top-0 right-0 w-96 h-96 bg-white/10 rounded-full blur-3xl" />
          <div className="absolute bottom-0 left-0 w-64 h-64 bg-white/5 rounded-full blur-3xl" />

          <div className="relative z-10 flex flex-col lg:flex-row items-center gap-12 lg:gap-16">
            {/* Content */}
            <div className="flex-1 text-center lg:text-left text-primary-foreground">
              <h2 className="text-3xl md:text-4xl lg:text-5xl font-bold mb-6">
                Zacznij zdobywać nagrody już dziś
              </h2>
              <p className="text-lg md:text-xl text-white/90 max-w-lg mx-auto lg:mx-0 mb-8">
                Dołącz do tysięcy użytkowników, którzy zamieniają aktywność w
                prawdziwe korzyści. Pobierz FinFit za darmo.
              </p>

              {/* App store buttons */}
              <div className="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
                <a
                  href="#"
                  className="inline-flex items-center gap-3 px-6 py-4 bg-foreground text-background rounded-xl hover:bg-foreground/90 transition-colors"
                >
                  <img src={appStore} className="w-10 h-10" />
                  <div className="text-left">
                    <p className="text-xs opacity-70">Pobierz w</p>
                    <p className="text-lg font-semibold">App Store</p>
                  </div>
                </a>
                <a
                  href="#"
                  className="inline-flex items-center gap-3 px-6 py-4 bg-foreground text-background rounded-xl hover:bg-foreground/90 transition-colors"
                >
                  <img src={googlePlay} className="w-10 h-10" />
                  <div className="text-left">
                    <p className="text-xs opacity-70">Pobierz z</p>
                    <p className="text-lg font-semibold">Google Play</p>
                  </div>
                </a>
              </div>
            </div>

            {/* Phone mockup */}
            <div className="hidden lg:block flex-shrink-0">
              <div className="phone-mockup w-[220px] bg-white animate-float">
                <div className="phone-screen aspect-[9/19] flex items-center justify-center !bg-gradient-to-tr from-finfit-blue/50 to-white">
                  <img
                    src={logo}
                    alt="FinFit"
                    className="w-[120px] h-[120px] mx-auto mb-4 rounded-[30px] shadow-lg"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default DownloadCTA;
