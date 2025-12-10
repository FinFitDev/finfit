import { Coffee, Pizza, ShoppingBag, Shirt, Store, Truck } from "lucide-react";

const Rewards = () => {
  const categories = [
    { icon: ShoppingBag, label: "Online Shops", count: "80+" },
    { icon: Truck, label: "Delivery Services", count: "45+" },
    { icon: Store, label: "Local Stores", count: "75+" },
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
              <h2 className="section-title mb-4">
                Turn Your Workouts Into{" "}
                <span className="text-gradient">Real Rewards</span>
              </h2>
              <p className="section-subtitle">
                From your favorite coffee shop to online retailers, your fitness
                points unlock exclusive discounts everywhere you shop.
              </p>
            </div>

            {/* Categories */}
            <div className="grid grid-cols-3 gap-4">
              {categories.map((cat) => (
                <div
                  key={cat.label}
                  className="p-4 rounded-2xl bg-card shadow-card text-center"
                >
                  <cat.icon className="w-8 h-8 text-primary mx-auto mb-2" />
                  <p className="text-2xl font-bold">{cat.count}</p>
                  <p className="text-sm text-muted-foreground">{cat.label}</p>
                </div>
              ))}
            </div>

            {/* Benefits list */}
            <ul className="space-y-4">
              {[
                "Exclusive member-only discounts",
                "Points never expire",
                "New partners added weekly",
                "Share points with friends & family",
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
          <div className="relative">
            <div className="relative bg-card rounded-3xl p-8 shadow-card-hover">
              {/* Partner icons grid */}
              <div className="grid grid-cols-3 gap-4 mb-8">
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
              </div>

              {/* Sample discount card */}
              <div className="gradient-primary rounded-2xl p-6 text-primary-foreground">
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
            </div>

            {/* Floating elements */}
            <div className="absolute -top-4 -right-4 w-20 h-20 rounded-2xl gradient-primary shadow-finfit flex items-center justify-center animate-float">
              <span className="text-2xl font-bold text-primary-foreground">
                %
              </span>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Rewards;
