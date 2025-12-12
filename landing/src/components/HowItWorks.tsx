import { Download, Footprints, Gift, Trophy } from "lucide-react";

const HowItWorks = () => {
  const steps = [
    {
      icon: Download,
      step: "01",
      title: "Pobierz aplikację",
      description:
        "Pobierz FinFit na iOS lub Androida i załóż konto w kilka sekund - całkowicie za darmo",
    },
    {
      icon: Footprints,
      step: "02",
      title: "Śledź lub Połącz",
      description:
        "Uywaj naszego trackera albo połącz Stravę, aby automatycznie synchronizować aktywności.",
    },
    {
      icon: Trophy,
      step: "03",
      title: "Zdobywaj Punkty",
      description:
        "Każdy trening daje Ci punkty. Im więcej się ruszasz, tym więcej zyskujesz.",
    },
    {
      icon: Gift,
      step: "04",
      title: "Odbieraj Nagrody",
      description:
        "Wymieniaj punkty na ekskluzywne zniżki w wielu partnerskich sklepach - online i stacjonarnie.",
    },
  ];

  return (
    <section id="how-it-works" className="py-20 md:py-28">
      <div className="container">
        {/* Section header */}
        <div className="text-center mb-16 md:mb-20">
          <h2 className="section-title mb-4">
            Jak <span className="text-gradient">FinFit</span> działa
          </h2>
          <p className="section-subtitle mx-auto">
            Zacznij zdobywać nagrody za swoje aktywności fizyczne w zaledwie
            czterech prostych krokach.
          </p>
        </div>

        {/* Steps */}
        <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-8 lg:gap-6">
          {steps.map((item, index) => (
            <div key={item.step} className="relative">
              {index < steps.length - 1 && (
                <div className="hidden lg:block absolute top-14 left-1/2 w-full h-0.5 bg-border" />
              )}

              <div className="relative z-10 text-center">
                <div className="relative inline-flex mb-6">
                  <div className="w-28 h-28 rounded-full gradient-primary flex items-center justify-center shadow-finfit">
                    <item.icon className="w-12 h-12 text-primary-foreground" />
                  </div>

                  {item.step === "02" && (
                    <div className="absolute -top-3 right-0">
                      <span className="strava-badge aspect-square p-[10px]">
                        <svg
                          className="w-6 h-6"
                          viewBox="0 0 24 24"
                          fill="currentColor"
                        >
                          <path d="M15.387 17.944l-2.089-4.116h-3.065L15.387 24l5.15-10.172h-3.066m-7.008-5.599l2.836 5.598h4.172L10.463 0l-7.008 13.828h4.172" />
                        </svg>
                      </span>
                    </div>
                  )}
                </div>

                <h3 className="text-xl font-semibold mb-3">{item.title}</h3>
                <p className="text-muted-foreground">{item.description}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default HowItWorks;
