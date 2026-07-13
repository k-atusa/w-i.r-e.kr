import styles from "./page.module.css";
import { Button } from "@/components/ui/Button";
import { Shield, Lock, Code, Server, MessageSquare, ArrowRight } from "lucide-react";
import Link from "next/link";

export default function Home() {
  return (
    <main className={styles.main}>
      <div className={styles.backgroundEffects}>
        <div className={styles.glowBlob1} />
        <div className={styles.glowBlob2} />
      </div>

      <header className={styles.header}>
        <div className={styles.logo}>
          <Shield className={styles.logoIcon} size={28} />
          <span className="heading-gradient">WIRE</span>
        </div>
        <nav className={styles.nav}>
          <Link href="#features" className={styles.navLink}>Features</Link>
          <a href="https://web.wire.remotewire.net/#/login" target="_blank" rel="noopener noreferrer">
            <Button variant="outline" size="sm">Login</Button>
          </a>
        </nav>
      </header>

      <section className={styles.hero}>
        <div className={styles.heroContent}>
          <div className="animate-fade-in">
            <span className={styles.badge}>KATUSA Programming Club</span>
            <h1 className={styles.title}>
              Privacy First.<br />
              <span className="heading-gradient">End-to-End Encrypted.</span><br />
              Open Source.
            </h1>
            <p className={styles.description}>
              Wire - The official secure and transparent communication platform for KPC.<br />
              No ads, no tracking. Just focus on your conversations.
            </p>

            <div className={styles.actions}>
              <a href="https://web.wire.remotewire.net/#/register" target="_blank" rel="noopener noreferrer">
                <Button size="lg" variant="primary">
                  Sign Up <ArrowRight size={18} />
                </Button>
              </a>
              <a href="https://web.wire.remotewire.net/#/login" target="_blank" rel="noopener noreferrer">
                <Button size="lg" variant="secondary">
                  Login
                </Button>
              </a>
            </div>
          </div>
        </div>
      </section>

      <section id="features" className={styles.features}>
        <h2 className={styles.sectionTitle}>Trust & Technology</h2>
        <div className={styles.featureGrid}>
          <div className={`${styles.featureCard} glass`}>
            <div className={styles.featureIcon}><Server size={24} /></div>
            <h3>Matrix Protocol</h3>
            <p>All chats are securely routed based on the Matrix protocol, a decentralized open communication standard.</p>
          </div>
          <div className={`${styles.featureCard} glass delay-100`}>
            <div className={styles.featureIcon}><MessageSquare size={24} /></div>
            <h3>Element Web Client</h3>
            <p>We use Element Web, a verified open-source Matrix client, ensuring high reliability and a familiar user experience.</p>
          </div>
          <div className={`${styles.featureCard} glass delay-200`}>
            <div className={styles.featureIcon}><Lock size={24} /></div>
            <h3>End-to-End Encryption</h3>
            <p>All messages in 1:1 chats and encrypted rooms are protected by strong end-to-end encryption so only the participants can read them.</p>
          </div>
          <div className={`${styles.featureCard} glass delay-300`}>
            <div className={styles.featureIcon}><Code size={24} /></div>
            <h3>100% Open Source</h3>
            <p>Our servers, clients, and even this landing page are transparently open-sourced for anyone to verify.</p>
          </div>
        </div>
      </section>

      <footer className={styles.footer}>
        <p>© 2026 <a href="https://github.com/k-atusa" target="_blank" rel="noopener noreferrer" className="hover-link">KATUSA Programming Club</a>. All rights reserved.</p>
      </footer>
    </main>
  );
}
