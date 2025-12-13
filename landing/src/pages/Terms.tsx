import { Link } from "react-router-dom";
import { ArrowLeft } from "lucide-react";
import logo from "@/assets/logo.png";

const Terms = () => {
  const currentDate = new Date().toLocaleDateString("pl-PL", {
    month: "long",
    day: "numeric",
    year: "numeric",
  });

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
            Powrót / Back
          </Link>
        </div>
      </header>

      {/* Content */}
      <main className="container py-12 md:py-20">
        <div className="max-w-3xl mx-auto">
          <h1 className="text-3xl md:text-4xl font-bold mb-2">
            Regulamin Użytkowania (Terms of Use)
          </h1>
          <p className="text-muted-foreground mb-8">
            Ostatnia aktualizacja: {currentDate}
          </p>

          <div className="prose prose-lg max-w-none space-y-8">
            <section>
              <h2 className="text-2xl font-semibold mb-4">
                1. Akceptacja Warunków (Acceptance of Terms)
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                Pobierając lub używając aplikacji FinFit ("Aplikacja"), zgadzasz
                się na przestrzeganie niniejszego Regulaminu. Aplikacja służy do
                śledzenia aktywności fizycznej i nagradzania użytkowników
                punktami wymiennymi na zniżki.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                2. Kwalifikowalność (Eligibility)
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                Korzystając z Aplikacji, oświadczasz, że posiadasz pełną
                zdolność do czynności prawnych niezbędną do zaakceptowania
                niniejszego Regulaminu zgodnie z prawem obowiązującym w Twoim
                kraju zamieszkania.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                3. System Punktów i Nagród (Points & Rewards System)
              </h2>
              <p className="text-muted-foreground leading-relaxed mb-4">
                Zasady działania programu lojalnościowego FinFit:
              </p>
              <ul className="list-disc list-inside text-muted-foreground space-y-2 ml-4">
                <li>
                  <b>Zdobywanie Punktów:</b> Punkty są przyznawane wyłącznie za
                  rzeczywistą, zweryfikowaną aktywność fizyczną (treningi)
                  zarejestrowaną przez Aplikację lub zaimportowaną z połączonego
                  konta Strava.
                </li>
                <li>
                  <b>Brak Wartości Pieniężnej:</b> Punkty zgromadzone w
                  Aplikacji nie posiadają wartości pieniężnej, nie są walutą i
                  nie mogą być wymienione na gotówkę. Służą wyłącznie do
                  uzyskania kodów rabatowych.
                </li>
                <li>
                  <b>Wymiana (Redemption):</b> Punkty można wymieniać na zniżki
                  w sklepach partnerskich widocznych w Aplikacji. Dostępność
                  nagród może ulegać zmianie.
                </li>
              </ul>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                4. Integracja ze Stravą (Strava Integration)
              </h2>
              <p className="text-muted-foreground leading-relaxed mb-4">
                FinFit oferuje funkcję synchronizacji z platformą Strava.
                Korzystając z tej funkcji, przyjmujesz do wiadomości, że:
              </p>
              <ul className="list-disc list-inside text-muted-foreground space-y-2 ml-4">
                <li>
                  Integracja służy jedynie ułatwieniu importu treningów w celu
                  zaliczenia ich do puli punktów FinFit.
                </li>
                <li>
                  W Aplikacji FinFit treningi pochodzące ze Stravy są{" "}
                  <b>wyraźnie oznaczone</b> logotypem lub informacją tekstową,
                  aby odróżnić je od treningów rejestrowanych natywnie.
                </li>
                <li>
                  FinFit nie ponosi odpowiedzialności za dostępność usług Strava
                  ani za ewentualne błędy w danych dostarczanych przez API
                  Strava.
                </li>
              </ul>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                5. Zasady Uczciwego Korzystania (Fair Play & Anti-Fraud)
              </h2>
              <p className="text-muted-foreground leading-relaxed mb-4">
                Aby zapewnić uczciwość systemu nagród, surowo zabrania się:
              </p>
              <ul className="list-disc list-inside text-muted-foreground space-y-2 ml-4">
                <li>
                  Manipulowania danymi GPS lub używania symulatorów lokalizacji
                  w celu sztucznego generowania dystansu.
                </li>
                <li>
                  Wgrywania fałszywych plików treningowych (.gpx, .tcx) do
                  Stravy w celu ich synchronizacji z FinFit.
                </li>
                <li>
                  Używania botów lub zautomatyzowanych skryptów do obsługi
                  Aplikacji.
                </li>
              </ul>
              <p className="text-muted-foreground mt-2">
                Naruszenie tych zasad skutkuje{" "}
                <b>natychmiastową blokadą konta</b> i przepadkiem wszystkich
                zgromadzonych punktów.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                6. Zbieranie Danych (Data Collection & Usage)
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                Akceptując Regulamin, zgadzasz się na zbieranie danych
                niezbędnych do świadczenia usługi (takich jak lokalizacja
                podczas treningu). Szczegóły dotyczące zakresu i celu
                przetwarzania danych znajdują się w naszej{" "}
                <Link className="text-finfit-blue" to={"/privacy"}>
                  <b>Polityce Prywatności</b>
                </Link>
                . Przypominamy, że zbieramy dane wyłącznie w celu umożliwienia
                Ci zakładania konta, monitorowania postępów i korzystania z
                benefitów (zniżek).
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                7. Wyłączenie Odpowiedzialności (Disclaimer)
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                Aplikacja jest dostarczana w stanie "tak jak jest". FinFit nie
                gwarantuje, że Aplikacja będzie wolna od błędów, ani że
                integracja z partnerami zewnętrznymi (Strava, sklepy) będzie
                działać nieprzerwanie. Podejmujesz aktywność fizyczną na własną
                odpowiedzialność; zalecamy konsultację z lekarzem przed
                rozpoczęciem intensywnych treningów.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                8. Kontakt (Contact)
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                W sprawach dotyczących Regulaminu prosimy o kontakt:
              </p>
              <p className="text-finfit-blue mt-2">
                <a href="mailto:finfit.app.contact@gmail.com">
                  <b>finfit.app.contact@gmail.com</b>
                </a>
              </p>
            </section>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="border-t border-border py-8">
        <div className="container text-center text-muted-foreground text-sm">
          © {new Date().getFullYear()} FinFit. Wszelkie prawa zastrzeżone.
        </div>
      </footer>
    </div>
  );
};

export default Terms;
