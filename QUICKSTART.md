# W2K - QUICK START GUIDE
# Deploy rapido su server - PACCHETTO COMPLETO

## 🚀 INSTALLAZIONE ZERO-TOUCH (2 minuti)

```bash
# 1. Estrai pacchetto completo
unzip w2k-complete.zip
cd w2k-package/

# 2. Installazione automatica TUTTO (Webtoon-Downloader + w2k + dipendenze)
./install.sh

# 3. Aggiungi prima serie da monitorare
w2k --add-series "https://www.webtoons.com/en/drama/your-series/list?title_no=123"

# 4. (OPZIONALE) Setup automazione ogni 6 ore  
./install-cron.sh
```

**FATTO! Sistema completo funzionante immediatamente.**

---

## ⚡ COSA INCLUDE QUESTO PACCHETTO

✅ **Webtoon-Downloader completo** - Engine download Python
✅ **W2K sistema completo** - Conversione e monitoraggio automatico
✅ **Installazione automatica dipendenze** - Poetry/pip gestiti automaticamente  
✅ **Pre-configurazione paths** - Tutto configurato automaticamente
✅ **Setup cron guidato** - Monitoraggio ogni 6 ore opzionale

---

## 🎯 COMANDI ESSENZIALI POST-INSTALLAZIONE

```bash
w2k --help                    # Guida completa
w2k --list-series             # Vedi serie monitorate  
w2k --check-updates           # Test manuale aggiornamenti
w2k --download "URL"          # Download singolo + conversione
w2k --download "URL" --latest # Solo ultimo capitolo
```

---

## 🔧 ZERO TROUBLESHOOTING

**✅ Tutto automatico**: ./install.sh gestisce tutto
**✅ Dipendenze Python**: Installate automaticamente  
**✅ Path configurati**: Webtoon-Downloader path pre-impostato
**✅ Directory create**: ~/Downloads/webtoons/ pronta  
**✅ Command globale**: w2k disponibile ovunque

---

## 📁 STRUTTURA POST-INSTALLAZIONE

```
~/git/Webtoon-Downloader/     # Engine Python completo
~/w2k/                        # Sistema w2k
├── w2k                       # Script principale
├── install-cron.sh          # Setup automazione
├── w2k-cron-example.conf    # Esempi cron
├── README.md                # Docs completa
├── QUICKSTART.md            # Questa guida
└── VERSION                  # Info versione

~/bin/w2k                     # Link globale (in PATH)
~/.config/w2k/               # Configurazione auto-generata
├── config                   # Settings pre-configurati  
├── series.db               # Database serie (creato al primo uso)
└── w2k.lock               # Lock file automazione

~/Downloads/webtoons/        # Directory download default
```

---

## 🚀 ESEMPI UTILIZZO IMMEDIATO

### Monitoraggio Torre of God automatico
```bash
w2k --add-series "https://www.webtoons.com/en/fantasy/tower-of-god/list?title_no=95"
./install-cron.sh  # Setup controllo ogni 6 ore
# Sistema ora monitora Torre of God automaticamente!
```

### Download batch singolo
```bash  
w2k --download "https://..." --start 100 --end 120 --quality 100
# Scarica capitoli 100-120 alta qualità + conversione Kavita
```

### Solo ultimo capitolo tutte le serie
```bash
w2k --check-updates  # Controlla tutte le serie, scarica solo nuovi capitoli
```

---

**Il sistema più completo per webtoon automation! 🎯**  
**Zero configurazione manuale, tutto automatico.**