#!/bin/bash

# Script di installazione automatica cron per w2k
# Questo script configura automaticamente il cron job per il monitoraggio
# webtoon ogni 6 ore.

set -e

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Trova il percorso assoluto dello script w2k
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
W2K_PATH="$SCRIPT_DIR/w2k"

if [[ ! -f "$W2K_PATH" ]]; then
    print_error "Script w2k non trovato in: $W2K_PATH"
    exit 1
fi

print_info "=== SETUP CRON AUTOMATICO W2K ==="
echo
print_info "Questo script configurerà w2k per controlli automatici ogni 6 ore"
print_info "Percorso w2k: $W2K_PATH"
echo

# Controlla se w2k è configurato
if ! "$W2K_PATH" --dry-run --auto >/dev/null 2>&1; then
    print_warning "w2k non sembra configurato correttamente"
    print_info "Esegui prima: $W2K_PATH --setup"
    read -p "Vuoi eseguire il setup ora? (y/N): " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        "$W2K_PATH" --setup
    else
        print_error "Setup necessario prima di configurare cron"
        exit 1
    fi
fi

# Controlla se ci sono serie monitorate
if ! "$W2K_PATH" --list-series | grep -q "Totale serie monitorate:" 2>/dev/null; then
    print_warning "Nessuna serie configurata per il monitoraggio"
    print_info "Aggiungi serie con: $W2K_PATH --add-series <url>"
    echo
    read -p "Vuoi aggiungere una serie ora? (y/N): " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Inserisci URL webtoon: " url
        if [[ -n "$url" ]]; then
            "$W2K_PATH" --add-series "$url"
        fi
    fi
fi

# Mostra cron job proposto
echo
print_info "Cron job che verrà installato:"
echo "0 */6 * * * $W2K_PATH --auto --cron --notify-kavita >/dev/null 2>&1"
echo
print_info "Questo controllerà aggiornamenti ogni 6 ore (00:00, 06:00, 12:00, 18:00)"
echo

# Chiedi conferma
read -p "Installare questo cron job? (y/N): " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Installazione annullata"
    exit 0
fi

# Backup cron esistente
print_info "Creando backup cron esistente..."
crontab -l > "$HOME/crontab-backup-$(date +%Y%m%d-%H%M%S).txt" 2>/dev/null || true

# Installa nuovo cron job
print_info "Installando cron job..."
(crontab -l 2>/dev/null || true; echo "0 */6 * * * $W2K_PATH --auto --cron --notify-kavita >/dev/null 2>&1") | crontab -

print_success "Cron job installato con successo!"
echo
print_info "Comandi utili:"
print_info "  crontab -l                    # Mostra cron jobs attivi"
print_info "  $W2K_PATH --list-series      # Mostra serie monitorate"
print_info "  $W2K_PATH --check-updates    # Test manuale aggiornamenti"
echo
print_info "Il prossimo controllo automatico avverrà alla prossima ora multipla di 6"
print_info "Per vedere i logs: tail -f ~/.config/w2k/debug.log"