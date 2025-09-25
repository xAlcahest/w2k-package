# WebtoonDL to Kavita Format Converter (w2k)

Script unificato per **download automatico**, **conversione** e **monitoraggio continuo** di webtoon per Kavita Reader.

## 🚀 Funzionalità Principali

- **🔄 Monitoraggio Automatico**: Controlla nuovi capitoli ogni 6 ore
- **📚 Database Serie**: Ricorda le serie monitorate automaticamente  
- **⚡ Download Intelligente**: Integrazione completa con Webtoon Downloader
- **📦 Conversione CBZ**: Formato Kavita con nomi Volume consistenti
- **🕒 Scheduling Cron**: Setup automatico per controlli programmati
- **🔔 Notifiche Kavita**: Aggiornamento automatico libreria

## Utilizzo

### Script W2K (Conversione locale)

```bash
./w2k /path/to/webtoon/directory [options]
```

#### Opzioni:
- `--dir` : Crea cartelle separate per ogni episodio (default)
- `--cbz` : Crea file CBZ compressi (formato raccomandato per Kavita)

#### Esempi:

```bash
# Crea cartelle (default)
./w2k /home/user/webtoons/Down_To_Earth
./w2k /home/user/webtoons/Down_To_Earth --dir

# Crea file CBZ (raccomandato per Kavita)
./w2k /home/user/webtoons/Down_To_Earth --cbz
```

### Script W2K-Auto (Sistema automatizzato)

```bash
./w2k-auto <webtoon_url> [options]
```

#### Opzioni principali:
- `--cbz` / `--dir` : Formato output
- `--start <num>` / `--end <num>` : Range capitoli
- `--latest` : Solo ultimo capitolo
- `--kavita-url <url>` : URL server Kavita
- `--kavita-token <token>` : Token API Kavita
- `--library-id <id>` : ID libreria da aggiornare
- `--setup` : Configurazione interattiva
- `--dry-run` : Simulazione senza esecuzione

#### Esempi:

```bash
# Setup iniziale
./w2k-auto --setup

# Download e conversione automatica
./w2k-auto "https://www.webtoons.com/en/fantasy/tower-of-god/list?title_no=95" --latest --cbz

# Download range specifico
./w2k-auto "https://www.webtoons.com/en/drama/lore-olympus/list?title_no=1320" --start 10 --end 20 --cbz

# Test senza esecuzione
./w2k-auto "https://www.webtoons.com/en/fantasy/unordinary/list?title_no=679" --latest --dry-run
```

## Cosa fa lo script

1. **Analizza** la directory del webtoon
2. **Normalizza** il nome della serie (sostituisce `_` con spazi e converte in proper case)
3. **Identifica** gli episodi della Season 1 (`Episode X`) e Season 2 (`(S2) Episode X`)
4. **Converte** la nomenclatura seguendo le convenzioni Kavita per i manga:
   - `Episode 1` → `Down To Earth Chapter 001`
   - `Episode 2` → `Down To Earth Chapter 002`
   - `(S2) Episode 79` → `Down To Earth Volume 2 Chapter 079`
   - `(S2) Episode 80` → `Down To Earth Volume 2 Chapter 080`
5. **Crea** una nuova directory `[ORIGINALE]_Kavita` con la struttura convertita
6. **Crea** cartelle o file CBZ a seconda dell'opzione scelta
7. **Copia** tutti i file delle immagini nelle nuove strutture

## Struttura risultante

### Con opzione --dir (cartelle):
```
Down_To_Earth_Kavita/
├── Down To Earth Chapter 001/
│   ├── 01.jpg
│   ├── 02.jpg
│   └── ...
├── Down To Earth Chapter 002/
├── ...
├── Down To Earth Volume 2 Chapter 079/
├── Down To Earth Volume 2 Chapter 080/
└── ...
```

### Con opzione --cbz (file compressi):
```
Down_To_Earth_Kavita/
├── Down To Earth Chapter 001.cbz
├── Down To Earth Chapter 002.cbz
├── ...
├── Down To Earth Volume 2 Chapter 079.cbz
├── Down To Earth Volume 2 Chapter 080.cbz
└── ...
```

## Compatibilità Kavita

La struttura risultante è completamente compatibile con Kavita per librerie Manga:
- ✅ Ogni serie in una cartella separata
- ✅ Numerazione Volume/Chapter riconosciuta (`Chapter 001`, `Volume 2 Chapter 079`)
- ✅ Nessun file al livello root
- ✅ Naming convention manga rispettata
- ✅ Supporto per multiple stagioni/serie

## Automazione con Cron

Il sistema supporta l'automazione completa per aggiornamenti programmati:

### Setup automazione:

1. **Configurazione iniziale:**
   ```bash
   ./w2k-auto --setup
   ```

2. **Test configurazione:**
   ```bash
   ./w2k-auto "your_webtoon_url" --latest --dry-run
   ```

3. **Aggiungere a crontab:**
   ```bash
   crontab -e
   ```

### Esempi cron:

```bash
# Aggiorna ogni 6 ore
0 */6 * * * /path/to/w2k-auto "https://www.webtoons.com/en/fantasy/tower-of-god/list?title_no=95" --latest --cbz

# Aggiorna giornalmente alle 2 AM
0 2 * * * /path/to/w2k-auto "https://www.webtoons.com/en/drama/lore-olympus/list?title_no=1320" --latest --cbz

# Aggiorna settimanalmente la domenica alle 3 AM
0 3 * * 0 /path/to/w2k-auto "https://www.webtoons.com/en/fantasy/unordinary/list?title_no=679" --latest --cbz
```

### Integrazione Kavita:

Lo script può automaticamente notificare Kavita per refreshare la libreria:

```bash
./w2k-auto "webtoon_url" --latest --cbz --kavita-url "http://localhost:5000" --kavita-token "your_token" --library-id "1"
```

## Requisiti

### Base:
- Bash shell
- Comandi standard Unix (cp, mkdir, basename)
- `zip` command (richiesto per l'opzione --cbz)
- `curl` command (per notifiche Kavita)

### Per W2K-Auto:
- Python 3.10+
- `webtoon-downloader` installato via pipx:
  ```bash
  pipx install webtoon_downloader
  ```

### Opzionali:
- `tree` per visualizzazione struttura

## Installazione rapida

```bash
# Clona il repository
git clone https://github.com/your-repo/WebtoonDL2KavitaFormat.git
cd WebtoonDL2KavitaFormat

# Esegui l'installazione automatica
./install.sh

# Configura il sistema
./w2k-auto --setup
```

## File inclusi

- **w2k** - Script di conversione formato
- **w2k-auto** - Sistema automatizzato completo  
- **install.sh** - Script di installazione automatica
- **cron-examples.conf** - Esempi di configurazione cron
- **systemd-example.conf** - Esempio servizio systemd
- **Webtoon-Downloader/** - Tool di download integrato

## Note

- Lo script **non modifica** i file originali
- Crea una **copia** nella directory `[NOME]_Kavita`
- Mantiene tutte le immagini originali
- Gestisce automaticamente entrambe le stagioni
- **CBZ format**: I file CBZ sono creati con compressione zero (`-rv0`) per velocità massima
- **Raccomandazione**: Usa `--cbz` per una migliore compatibilità con Kavita
- **Automazione**: Supporta cron, systemd timers e notifiche API Kavita
- **Sicurezza**: Modalità `--dry-run` per testare senza modifiche