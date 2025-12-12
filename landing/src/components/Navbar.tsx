import { Link } from "react-router-dom";
import logo from "@/assets/logo.png";

const Navbar = () => {
  return (
    <nav className="fixed top-0 left-0 right-0 z-50 bg-background/80 backdrop-blur-md border-b border-border/50">
      <div className="container flex items-center justify-between h-16 md:h-20">
        <Link to="/" className="flex items-center gap-3">
          <img
            src={logo}
            alt="FinFit Logo"
            className="h-10 w-10 md:h-12 md:w-12 rounded-xl"
          />
          <span className="text-xl md:text-2xl font-bold text-gradient">
            FinFit
          </span>
        </Link>

        <div className="hidden md:flex items-center gap-8">
          <a
            href="#features"
            className="text-muted-foreground hover:text-foreground transition-colors font-medium"
          >
            Funkcje
          </a>
          <a
            href="#how-it-works"
            className="text-muted-foreground hover:text-foreground transition-colors font-medium"
          >
            Jak to działa
          </a>
          <a
            href="#rewards"
            className="text-muted-foreground hover:text-foreground transition-colors font-medium"
          >
            Nagrody
          </a>
        </div>

        <a href="#download" className="btn-primary text-sm px-6 py-3">
          Pobierz aplikację
        </a>
      </div>
    </nav>
  );
};

export default Navbar;
