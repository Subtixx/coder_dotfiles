#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

info() {
  echo -e "${CYAN}ℹ️  $1${NC}"
  printf "[%-19s] [%-7s] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "INFO" "$1" >> /tmp/startup.log
}
success() {
  echo -e "${GREEN}✅ $1${NC}"
  printf "[%-19s] [%-7s] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "SUCCESS" "$1" >> /tmp/startup.log
}
warn() {
  echo -e "${YELLOW}⚠️  $1${NC}"
  printf "[%-19s] [%-7s] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "WARN" "$1" >> /tmp/startup.log
}
error() {
  echo -e "${RED}❌ $1${NC}"
  printf "[%-19s] [%-7s] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "ERROR" "$1" >> /tmp/startup.log
}
