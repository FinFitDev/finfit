import clsx from "clsx";
import {
  Activity,
  Bike,
  Gift,
  MapPin,
  Send,
  Smartphone,
  Users,
  Zap,
} from "lucide-react";

const Features = () => {
  const mainFeatures = [
    {
      icon: Activity,
      title: "Śledź swoje treningi",
      description:
        "Rejestruj biegi, jazdę na rowerze i spacery dzięki wbudowanemu GPS. Każdy krok przybliża Cię do nagród.",
    },
    {
      icon: Zap,
      title: "Integracja STRAVA",
      description:
        "Korzystasz już ze Stravy? Połącz swoje konto i automatycznie synchronizuj wszystkie treningi!",
      isHighlighted: true,
    },
    {
      icon: Gift,
      title: "Zarabiaj i odbieraj nagrody",
      description:
        "Przekształć swój wysiłek w oszczędności. Odbierz ekskluzywne kody rabatowe w wielu wspieranych sklepach.",
    },
    {
      icon: Send,
      title: "Dziel się",
      description:
        "Podaruj punkty znajomym i rodzinie. Motywujcie się nawzajem i dzielcie się nagrodami.",
    },
  ];

  const activityTypes = [
    { icon: Activity, label: "Bieganie", color: "bg-primary" },
    { icon: Bike, label: "Jazda na rowerze", color: "bg-accent-foreground" },
    { icon: MapPin, label: "Spacerowanie", color: "bg-muted-foreground" },
  ];

  return (
    <section id="features" className="py-20 md:py-28 bg-secondary/30">
      <div className="container">
        <div className="text-center mb-16 md:mb-10">
          <h2 className="section-title mb-4">
            Wszystko czego potrzebujesz by{" "}
            <span className="text-gradient">być aktywnym</span>
          </h2>
          <p className="section-subtitle mx-auto">
            Śledź swoje treningi, zdobywaj nagrody i doceniaj swój wysiłek!
            FinFit sprawia, że aktywność opłaca się nie tylko dla zdrowia.
          </p>
        </div>

        <div className="flex flex-wrap justify-center gap-4 mb-16">
          {activityTypes.map((activity) => (
            <div
              key={activity.label}
              className="flex items-center gap-3 px-6 py-3 rounded-full bg-card shadow-card"
            >
              <activity.icon className="w-5 h-5 text-primary" />
              <span className="font-medium">{activity.label}</span>
            </div>
          ))}
          <div className="flex items-center justify-center">
            <p className="text-finfit-blue-dark font-semibold">
              I wiele więcej...
            </p>
          </div>
        </div>

        <div className="grid md:grid-cols-2 gap-6 lg:gap-8">
          {mainFeatures.map((feature) => (
            <div
              key={feature.title}
              className={`feature-card relative ${
                feature.isHighlighted ? "border-2 border-strava bg-strava" : ""
              }`}
            >
              <div
                className={`w-14 h-14 rounded-2xl flex items-center justify-center mb-6 ${
                  feature.isHighlighted ? "gradient-strava" : "gradient-primary"
                }`}
              >
                {feature.isHighlighted ? (
                  <div className="w-[56px] aspect-square bg-white/20 rounded-2xl bg-white/20 flex items-center justify-center">
                    <svg
                      className="w-10 h-10 text-white"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                    >
                      <path d="M15.387 17.944l-2.089-4.116h-3.065L15.387 24l5.15-10.172h-3.066m-7.008-5.599l2.836 5.598h4.172L10.463 0l-7.008 13.828h4.172" />
                    </svg>
                  </div>
                ) : (
                  <feature.icon className="w-7 h-7 text-primary-foreground" />
                )}
              </div>

              <h3
                className={clsx(
                  "text-xl md:text-2xl font-semibold mb-3",
                  feature.isHighlighted ? "text-primary-foreground" : ""
                )}
              >
                {feature.title}
              </h3>
              <p
                className={clsx(
                  "text-muted-foreground leading-relaxed",
                  feature.isHighlighted ? "text-white/90" : ""
                )}
              >
                {feature.description}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Features;
