import { Link } from "react-router-dom";
import { ArrowLeft } from "lucide-react";
import logo from "@/assets/logo.png";

const Privacy = () => {
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
            Polityka Prywatności (Privacy Policy)
          </h1>
          <p className="text-muted-foreground mb-8">
            Ostatnia aktualizacja: {currentDate}
          </p>

          <div className="prose prose-lg max-w-none space-y-8">
            <section>
              <h2 className="text-2xl font-semibold mb-4">
                1. Wprowadzenie (Introduction)
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                Witamy w aplikacji FinFit. Twoja prywatność jest dla nas
                priorytetem. Niniejsza polityka wyjaśnia, że zbieramy Twoje dane{" "}
                <b>wyłącznie w celu zapewnienia funkcjonalności aplikacji</b>,
                tj. tworzenia konta, śledzenia postępów treningowych i
                przyznawania punktów wymiennych na zniżki. Nie sprzedajemy
                Twoich danych osobowych podmiotom trzecim.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                2. Dane, które zbieramy (Information We Collect)
              </h2>
              <p className="text-muted-foreground leading-relaxed mb-4">
                W celu prawidłowego działania Aplikacji i systemu nagród,
                zbieramy następujące typy danych:
              </p>
              <ul className="list-disc list-inside text-muted-foreground space-y-2 ml-4">
                <li>
                  <b>Dane Konta:</b> Adres e-mail, imię i hasło (zaszyfrowane).
                  Są one niezbędne do utworzenia unikalnego profilu użytkownika
                  i zabezpieczenia dostępu do zgromadzonych punktów.
                </li>
                <li>
                  <b>Dane Zdrowotne i Aktywności (Health & Fitness Data):</b>{" "}
                  Informacje o Twoich treningach (dystans, czas trwania, tempo,
                  lokalizacja GPS), które są rejestrowane bezpośrednio przez
                  aplikację lub synchronizowane ze Stravy. Dane te są podstawą
                  do naliczania punktów.
                </li>
                <li>
                  <b>Dane ze Stravy (Strava Data):</b> Jeśli wyrazisz zgodę na
                  połączenie konta, pobieramy informacje o ukończonych
                  aktywnościach wyłącznie w celu ich weryfikacji i
                  synchronizacji.
                </li>
              </ul>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                3. Cel wykorzystania danych (How We Use Your Information)
              </h2>
              <p className="text-muted-foreground leading-relaxed mb-4">
                Zgodnie z wymaganiami sklepów (Apple App Store, Google Play),
                oświadczamy, że Twoje dane są wykorzystywane <b>wyłącznie</b>{" "}
                do:
              </p>
              <ul className="list-disc list-inside text-muted-foreground space-y-2 ml-4">
                <li>
                  <b>Obsługi Konta:</b> Uwierzytelniania użytkownika w systemie.
                </li>
                <li>
                  <b>Funkcjonalności Aplikacji (App Functionality):</b>{" "}
                  Przeliczania Twojego wysiłku fizycznego na punkty w systemie
                  lojalnościowym.
                </li>
                <li>
                  <b>Synchronizacji (Sync):</b> Importowania historii treningów
                  z platformy Strava (na żądanie użytkownika).
                </li>
                <li>
                  <b>Realizacji Nagród:</b> Umożliwienia wymiany punktów na kody
                  zniżkowe.
                </li>
              </ul>
              <p className="text-muted-foreground mt-4">
                <b>Nie wykorzystujemy</b> Twoich danych zdrowotnych ani danych
                ze Stravy do celów reklamowych, marketingowych ani do trenowania
                modeli sztucznej inteligencji (AI).
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                4. Integracja i Dane Strava (Strava Integration Policy)
              </h2>
              <p className="text-muted-foreground leading-relaxed mb-4">
                FinFit jest partnerem integrującym się z API Strava. W przypadku
                połączenia konta FinFit ze Stravą, obowiązują następujące
                zasady:
              </p>
              <ul className="list-disc list-inside text-muted-foreground space-y-2 ml-4">
                <li>
                  <b>Przejrzystość:</b> Treningi zaimportowane ze Stravy są w
                  aplikacji FinFit <b>wyraźnie oznaczone</b> jako pochodzące z
                  platformy zewnętrznej. Służy to jedynie synchronizacji Twoich
                  osiągnięć.
                </li>
                <li>
                  <b>Ograniczone Przechowywanie:</b> Przechowujemy
                  identyfikatory aktywności Strava, aby zapobiec podwójnemu
                  naliczaniu punktów za ten sam wysiłek.
                </li>
                <li>
                  <b>Brak Udostępniania:</b> Nie przekazujemy danych otrzymanych
                  ze Stravy żadnym stronom trzecim, w tym sieciom reklamowym czy
                  brokerom danych.
                </li>
              </ul>
              <p className="text-muted-foreground mt-2">
                Prosimy o zapoznanie się również z Polityką Prywatności serwisu
                Strava przed dokonaniem integracji.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                5. Udostępnianie Danych (Data Sharing)
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                Nie sprzedajemy Twoich danych. Udostępniamy je jedynie w
                minimalnym zakresie niezbędnym do działania usługi:
              </p>
              <ul className="list-disc list-inside text-muted-foreground space-y-2 ml-4 mt-2">
                <li>
                  <b>Partnerzy Handlowi (Sklepy):</b> Gdy wymieniasz punkty na
                  nagrodę, sklep otrzymuje informację o wygenerowaniu unikalnego
                  kodu zniżkowego. Sklep <b>nie otrzymuje</b> dostępu do Twojej
                  historii treningów ani danych zdrowotnych.
                </li>
                <li>
                  <b>Dostawcy Usług:</b> Zaufani dostawcy infrastruktury (np.
                  hosting), którzy przetwarzają dane w naszym imieniu przy
                  zachowaniu standardów bezpieczeństwa.
                </li>
              </ul>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                6. Usuwanie Danych (Data Deletion)
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                Masz pełne prawo do usunięcia swojego konta i wszystkich
                powiązanych z nim danych w dowolnym momencie. Opcja{" "}
                <b>"Usuń Konto"</b> jest dostępna poprzez kontakt z naszym
                działem obsługi na adres email{" "}
                <a
                  className="text-finfit-blue "
                  href="mailto:finfit.app.contact@gmail.com"
                >
                  <b>finfit.app.contact@gmail.com</b>
                </a>
                . Po jej wybraniu, trwale usuwamy Twoje dane osobowe, historię
                treningów oraz saldo punktów z naszych serwerów.
              </p>
            </section>

            <section>
              <h2 className="text-2xl font-semibold mb-4">
                7. Kontakt (Contact Us)
              </h2>
              <p className="text-muted-foreground leading-relaxed">
                Jeśli masz pytania dotyczące prywatności lub integracji danych,
                skontaktuj się z nami:
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

export default Privacy;
