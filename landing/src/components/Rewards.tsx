import { Coffee, Pizza, ShoppingBag, Shirt, Store, Truck } from "lucide-react";
import appScreenshotAllOffers from "@/assets/app_all_offers.png";
import appScreenshotOfferModal from "@/assets/app_offer_modal.png";
import appScreenshotClaims from "@/assets/app_claims.png";

const Rewards = () => {
  const categories = [
    { icon: ShoppingBag, label: "Sklepy online", count: "—" },
    { icon: Truck, label: "Za dostawą", count: "—" },
    { icon: Store, label: "Punkty stacjon.", count: "—" },
  ];

  const partnerLogos = [
    { icon: Coffee, name: "Cafes" },
    { icon: Pizza, name: "Food" },
    { icon: Shirt, name: "Fashion" },
    { icon: ShoppingBag, name: "Retail" },
    { icon: Truck, name: "Delivery" },
    { icon: Store, name: "More" },
  ];

  return (
    <section id="rewards" className="py-20 md:py-28 bg-secondary/30">
      <div className="container">
        <div className="grid lg:grid-cols-2 gap-12 lg:gap-16 items-center">
          {/* Left - Content */}
          <div className="space-y-8">
            <div>
              <h2 className="section-title mb-4 !leading-[1.2]">
                Przekształć swoje treningi w{" "}
                <span className="text-gradient">Realne korzyści</span>
              </h2>
              <p className="section-subtitle">
                Trenuj regularnie, zbieraj punkty i wymieniaj je na nagrody.
                Partnerów dokładamy na bieżąco, a Twój wysiłek zawsze się
                opłaca.
              </p>
            </div>

            <div className="grid grid-cols-3 gap-4">
              {categories.map((cat) => (
                <div
                  key={cat.label}
                  className="p-4 rounded-2xl bg-card shadow-card text-center"
                >
                  <cat.icon className="w-8 h-8 text-primary mx-auto mb-[16px]" />
                  <p className="text-sm text-muted-foreground">{cat.label}</p>
                </div>
              ))}
            </div>

            <ul className="space-y-4">
              {[
                "Stałe dodawanie nowych partnerów",
                "Punkty nigdy się nie przedawniają",
                "Całodobowe wsparcie i szybka pomoc",
                "Wymieniaj punkty, kiedy tylko chcesz",
              ].map((benefit) => (
                <li key={benefit} className="flex items-center gap-3">
                  <div className="w-6 h-6 rounded-full gradient-primary flex items-center justify-center flex-shrink-0">
                    <svg
                      className="w-3 h-3 text-primary-foreground"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={3}
                        d="M5 13l4 4L19 7"
                      />
                    </svg>
                  </div>
                  <span className="text-foreground">{benefit}</span>
                </li>
              ))}
            </ul>
          </div>

          {/* Right - Visual */}
          <div className="relative flex items-center justify-center scale-[0.6] sm:scale-[0.7] md:scale-[0.9] min-h-[400px] md:min-h-[600px]">
            <div className="!absolute phone-mockup w-64 md:w-72 animate-float !rotate-[10deg] translate-x-[120px] sm:translate-x-[130px] scale-[0.9]">
              <div className="phone-screen aspect-[9/19] flex items-center justify-center bg-gradient-to-br from-primary/20 to-primary/5">
                <div className="text-center">
                  <img src={appScreenshotClaims} className="scale-[1.06]" />
                </div>
              </div>
            </div>
            <div className="!absolute phone-mockup w-64 md:w-72 animate-float !-rotate-[10deg] -translate-x-[120px] sm:-translate-x-[130px] scale-[0.9]">
              <div className="phone-screen aspect-[9/19] flex items-center justify-center bg-gradient-to-br from-primary/20 to-primary/5">
                <div className="text-center">
                  <img src={appScreenshotOfferModal} className="scale-[1.06]" />
                </div>
              </div>
            </div>
            <div className="!absolute phone-mockup w-64 md:w-72 animate-float ">
              <div className="phone-screen aspect-[9/19] flex items-center justify-center bg-gradient-to-br from-primary/20 to-primary/5">
                <div className="text-center">
                  <img
                    src={appScreenshotAllOffers}
                    className="scale-[1.05] scale-x-[1.07]"
                  />
                </div>
              </div>
            </div>
            {/* <div className="relative bg-card rounded-3xl p-8 shadow-card-hover"> */}
            {/* Partner icons grid */}
            {/* <div className="grid grid-cols-3 gap-4 mb-8">
                {partnerLogos.map((partner, index) => (
                  <div
                    key={partner.name}
                    className="aspect-square rounded-2xl bg-secondary flex flex-col items-center justify-center p-4 transition-transform hover:scale-105"
                    style={{ animationDelay: `${index * 0.1}s` }}
                  >
                    <partner.icon className="w-8 h-8 text-primary mb-2" />
                    <span className="text-xs text-muted-foreground">
                      {partner.name}
                    </span>
                  </div>
                ))}
              </div> */}

            {/* Sample discount card */}
            {/* <div className="gradient-primary rounded-2xl p-6 text-primary-foreground">
                <div className="flex items-center justify-between mb-4">
                  <span className="text-sm font-medium opacity-90">
                    Your Discount Code
                  </span>
                  <span className="px-3 py-1 bg-white/20 rounded-full text-xs font-semibold">
                    Active
                  </span>
                </div>
                <p className="text-3xl font-bold tracking-wider mb-2">
                  FINFIT20
                </p>
                <p className="text-sm opacity-80">20% off at Partner Store</p>
              </div>
            </div> */}

            {/* Floating elements */}
            {/* <div className="absolute -top-4 -right-4 w-20 h-20 rounded-2xl gradient-primary shadow-finfit flex items-center justify-center animate-float">
              <span className="text-2xl font-bold text-primary-foreground">
                %
              </span>
            </div> */}
          </div>
        </div>
      </div>
    </section>
  );
};

export default Rewards;
