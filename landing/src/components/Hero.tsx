import { ArrowRight, Play } from "lucide-react";
import videoSrc from "@/assets/running_video1.mp4";

const Hero = () => {
  return (
    <section className="relative pt-[200px] pb-16 md:pb-24 overflow-hidden bg-white sm:gradient-hero px-[24px] min-h-[100vh]">
      <div className="absolute w-full h-full sm:gradient-hero-vertical left-0 top-0"></div>
      <div className="absolute inset-0 w-full h-full -z-20 flex justify-end">
        <video
          autoPlay
          loop
          muted
          playsInline
          className="lg:w-3/4 h-full object-cover sm:block hidden"
          src={videoSrc}
        />

        <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" />
      </div>

      <div className="absolute top-20 right-0 w-96 h-96 bg-primary/10 rounded-full blur-3xl -z-10" />
      <div className="absolute bottom-0 left-0 w-64 h-64 bg-primary/5 rounded-full blur-3xl -z-10" />

      <div className="container relative z-10">
        <div className="grid lg:grid-cols-2 gap-12 lg:gap-8 items-center">
          <div className="text-center lg:text-left space-y-6 md:space-y-8 text-white">
            <h1
              className="text-5xl md:text-6xl lg:text-7xl font-bold !leading-[1.2] animate-fade-up text-black"
              style={{ animationDelay: "0.1s" }}
            >
              Trenuj. <span className="text-gradient">Zarabiaj.</span>{" "}
              Korzystaj.
            </h1>

            <p
              className="text-lg md:text-xl text-gray-600 max-w-xl mx-auto lg:mx-0 animate-fade-up"
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
          </div>
        </div>
      </div>
    </section>
  );
};

export default Hero;
