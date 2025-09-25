#!/bin/bash

# W2K - Webtoon to Kavita Converter
# Script di installazione completa con Webtoon-Downloader integrato
# Versione: 1.0

set -e

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_header() { echo -e "${CYAN}[W2K]${NC} $1"; }

echo
print_header "╔══════════════════════════════════════════════════════════════╗"
print_header "║           W2K - Webtoon to Kavita Converter v1.0            ║"
print_header "║           Installazione Completa con Dependencies           ║"
print_header "╚══════════════════════════════════════════════════════════════╝"
echo

# Controlla se eseguito come utente normale (non root)
if [[ $EUID -eq 0 ]]; then
    print_warning "Non eseguire questo script come root!"
    print_info "Esegui come utente normale: ./install.sh"
    exit 1
fi

# Directory di installazione
INSTALL_DIR="$HOME/w2k"
BIN_DIR="$HOME/bin"
WEBTOON_DOWNLOADER_DIR="$HOME/git/Webtoon-Downloader"

print_info "Directory W2K: $INSTALL_DIR"
print_info "Directory Webtoon-Downloader: $WEBTOON_DOWNLOADER_DIR"
print_info "Directory binari: $BIN_DIR"
echo

# Verifica dipendenze sistema
print_info "Verificando dipendenze di sistema..."

MISSING_DEPS=()

if ! command -v zip >/dev/null 2>&1; then
    MISSING_DEPS+=("zip")
fi

if ! command -v curl >/dev/null 2>&1; then
    MISSING_DEPS+=("curl")
fi

if ! command -v python3 >/dev/null 2>&1; then
    MISSING_DEPS+=("python3")
fi

if ! command -v pip3 >/dev/null 2>&1; then
    MISSING_DEPS+=("python3-pip")
fi

if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
    print_error "Dipendenze mancanti: ${MISSING_DEPS[*]}"
    echo
    print_info "Installa le dipendenze mancanti:"
    print_info "Ubuntu/Debian: sudo apt update && sudo apt install ${MISSING_DEPS[*]}"
    print_info "CentOS/RHEL:   sudo yum install ${MISSING_DEPS[*]}"
    print_info "Arch Linux:    sudo pacman -S ${MISSING_DEPS[*]}"
    echo
    exit 1
fi

print_success "Tutte le dipendenze di sistema sono presenti"
echo

# Crea directory di installazione
print_info "Creando directory di installazione..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$(dirname "$WEBTOON_DOWNLOADER_DIR")"

# Installa Webtoon-Downloader
print_info "Installando Webtoon-Downloader..."
if [[ -d "$WEBTOON_DOWNLOADER_DIR" ]]; then
    print_warning "Webtoon-Downloader già presente. Aggiornando..."
    rm -rf "$WEBTOON_DOWNLOADER_DIR"
fi

cp -r "Webtoon-Downloader" "$WEBTOON_DOWNLOADER_DIR"
print_success "Webtoon-Downloader copiato in $WEBTOON_DOWNLOADER_DIR"

# Installa dipendenze Python per Webtoon-Downloader
print_info "Installando dipendenze Python..."
cd "$WEBTOON_DOWNLOADER_DIR"

# Controlla se poetry è disponibile
if command -v poetry >/dev/null 2>&1; then
    print_info "Usando Poetry per installazione dipendenze..."
    poetry install --no-dev
    print_success "Dipendenze Poetry installate"
else
    print_info "Poetry non trovato, usando pip..."
    if [[ -f "requirements.txt" ]]; then
        pip3 install --user -r requirements.txt
    else
        print_info "Installando dipendenze comuni..."
        pip3 install --user requests aiohttp rich-click aiofiles
    fi
    print_success "Dipendenze pip installate"
fi

# Torna alla directory originale
cd - >/dev/null

# Copia file W2K
print_info "Installando W2K..."
cp -v w2k "$INSTALL_DIR/"
cp -v install-cron.sh "$INSTALL_DIR/"
cp -v w2k-cron-example.conf "$INSTALL_DIR/"
cp -v README.md "$INSTALL_DIR/"
cp -v VERSION "$INSTALL_DIR/"
cp -v QUICKSTART.md "$INSTALL_DIR/"

# Rendi eseguibili
chmod +x "$INSTALL_DIR/w2k"
chmod +x "$INSTALL_DIR/install-cron.sh"

# Crea symlink in bin per accesso globale
print_info "Creando symlink per accesso globale..."
ln -sf "$INSTALL_DIR/w2k" "$BIN_DIR/w2k"

# Verifica se ~/bin è nel PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    print_warning "$BIN_DIR non è nel PATH"
    print_info "Aggiungendo $BIN_DIR al PATH..."
    
    # Aggiungi a bashrc o zshrc
    if [[ -f "$HOME/.zshrc" ]]; then
        if ! grep -q "export PATH.*$BIN_DIR" "$HOME/.zshrc"; then
            echo "export PATH=\"\$HOME/bin:\$PATH\"" >> "$HOME/.zshrc"
            print_info "Aggiunto PATH a ~/.zshrc"
        fi
    elif [[ -f "$HOME/.bashrc" ]]; then
        if ! grep -q "export PATH.*$BIN_DIR" "$HOME/.bashrc"; then
            echo "export PATH=\"\$HOME/bin:\$PATH\"" >> "$HOME/.bashrc"
            print_info "Aggiunto PATH a ~/.bashrc"
        fi
    fi
    
    print_warning "Riavvia il terminale o esegui: source ~/.bashrc (o ~/.zshrc)"
fi

# Pre-configura W2K con il path di Webtoon-Downloader
print_info "Pre-configurando W2K..."
mkdir -p "$HOME/.config/w2k"
if [[ ! -f "$HOME/.config/w2k/config" ]]; then
    cat > "$HOME/.config/w2k/config" << EOF
# Configurazione w2k - Auto-generata dall'installazione
WEBTOON_DOWNLOADER_DIR="$WEBTOON_DOWNLOADER_DIR"
DOWNLOAD_DIR="$HOME/Downloads/webtoons"
KAVITA_BASE_URL=""
KAVITA_API_KEY=""
KAVITA_LIBRARY_ID=""
EOF
    print_success "Configurazione base creata"
fi

# Crea directory download
mkdir -p "$HOME/Downloads/webtoons"

print_success "Installazione completata!"
echo

# Verifica installazione
print_info "Verificando installazione..."

INSTALLATION_OK=true

if [[ ! -x "$INSTALL_DIR/w2k" ]]; then
    print_error "w2k non installato correttamente"
    INSTALLATION_OK=false
fi

if [[ ! -L "$BIN_DIR/w2k" ]]; then
    print_error "Symlink w2k non creato"
    INSTALLATION_OK=false
fi

if [[ ! -d "$WEBTOON_DOWNLOADER_DIR" ]]; then
    print_error "Webtoon-Downloader non installato"
    INSTALLATION_OK=false
fi

# Test rapido Webtoon-Downloader
cd "$WEBTOON_DOWNLOADER_DIR"
if command -v poetry >/dev/null 2>&1; then
    if ! poetry run python -c "import webtoon_downloader" >/dev/null 2>&1; then
        print_error "Webtoon-Downloader non funziona correttamente"
        INSTALLATION_OK=false
    fi
else
    if ! python3 -c "import webtoon_downloader" >/dev/null 2>&1; then
        print_error "Webtoon-Downloader non funziona correttamente"
        INSTALLATION_OK=false
    fi
fi
cd - >/dev/null

if [[ "$INSTALLATION_OK" == "true" ]]; then
    print_success "Tutti i componenti installati correttamente"
else
    print_error "Problemi con l'installazione"
    exit 1
fi

echo
print_header "╔══════════════════════════════════════════════════════════════╗"
print_header "║                    INSTALLAZIONE COMPLETATA                 ║"
print_header "╚══════════════════════════════════════════════════════════════╝"
echo

print_info "🎯 SISTEMA PRONTO ALL'USO - PROSSIMI PASSI:"
echo
print_success "1. Setup finale Kavita (opzionale ma raccomandato):"
print_info "   w2k --setup"
echo
print_success "2. Aggiungi prima serie da monitorare:"
print_info "   w2k --add-series \"https://www.webtoons.com/en/drama/example/list?title_no=123\""
echo
print_success "3. Test download manuale:"
print_info "   w2k --download \"https://www.webtoons.com/en/drama/example/list?title_no=123\" --latest"
echo
print_success "4. Setup automazione ogni 6 ore (opzionale):"
print_info "   cd $INSTALL_DIR && ./install-cron.sh"
echo

print_info "📚 COMANDI ESSENZIALI:"
print_info "   w2k --help              # Guida completa"
print_info "   w2k --list-series       # Lista serie monitorate"
print_info "   w2k --check-updates     # Controlla aggiornamenti manuali"
print_info "   w2k --download <url>    # Download singolo + conversione"
echo

print_info "📁 COMPONENTI INSTALLATI:"
print_info "   $INSTALL_DIR/           # W2K sistema principale"
print_info "   $WEBTOON_DOWNLOADER_DIR/  # Webtoon-Downloader engine"
print_info "   $BIN_DIR/w2k           # Link globale"
print_info "   ~/.config/w2k/         # Configurazione"
print_info "   ~/Downloads/webtoons/  # Directory download default"
echo

print_success "🚀 SISTEMA W2K COMPLETO INSTALLATO E PRONTO!"
print_info "Inizia subito con: w2k --add-series \"<URL_WEBTOON>\""
echo