import Navbar from "../components/Navbar";
import Hero from "../components/Hero";
import Features from "../components/Features";
import HowItWorks from "../components/HowItWorks";
import Rewards from "../components/Rewards";
import DownloadCTA from "../components/DownloadCTA";
import Footer from "../components/Footer";

const Index = () => {
  return (
    <div className="min-h-screen">
      <Navbar />
      <main>
        <Hero />
        <Features />
        <HowItWorks />
        <Rewards />
        <DownloadCTA />
      </main>
      <Footer />
    </div>
  );
};

export default Index;
