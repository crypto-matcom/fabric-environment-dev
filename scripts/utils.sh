#!/bin/bash

C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_BLUE='\033[0;34m'
C_YELLOW='\033[1;33m'

# Print the usage message
function printHelp() {
  USAGE="$1"
  if [ "$USAGE" == "up" ]; then
    println "Usage: "
    println "  network.sh \033[0;32mup\033[0m [Flags]"
    println
    println
    println " Examples:"
    println "   network.sh up"
  elif [ "$USAGE" == "deployCC" ]; then
    println "Usage: "
    println "  network.sh \033[0;32mdeployCC\033[0m [Flags]"
    println
    println "    Flags:"
    println "    -c <channel name> - Name of channel to deploy chaincode to"
    println "    -ccn <name> - Chaincode name."
    println "    -ccv <version>  - Chaincode version. 1.0.0 (default), v2, version3.x, etc"
    println
    println
    println
    println " Examples:"
    println "   network.sh deployCC -ccn traceability -ccv 1.0.1"
  else
    println "Usage: "
    println "  network.sh <Mode> [Flags]"
    println "    Modes:"
    println "      \033[0;32mup\033[0m - Bring up Fabric orderer and peer nodes. Channel is created"
    println "      \033[0;32mdeployCC\033[0m - Deploy a chaincode"
    println "      \033[0;32mdown\033[0m - Bring down the network"
    println
    println "    Used with \033[0;32mnetwork.sh deployCC\033[0m"
    println "    -ccn <name> - Chaincode name."
    println "    -ccv <version>  - Chaincode version. 1.0.0 (default)"
    println
    println " Examples:"
    println "   network.sh up"
    println "   network.sh down"
    println "   network.sh deployCC -ccv 1.0.1"
    # println "   network.sh deployCC -ccn traceability -ccv 1.0.1"
  fi
}

# println echos string
function println() {
  echo -e "$1"
}

# errorln echos i red color
function errorln() {
  println "${C_RED}${1}${C_RESET}"
}

# successln echos in green color
function successln() {
  println "${C_GREEN}${1}${C_RESET}"
}

# infoln echos in blue color
function infoln() {
  println "${C_BLUE}${1}${C_RESET}"
}

# warnln echos in yellow color
function warnln() {
  println "${C_YELLOW}${1}${C_RESET}"
}

# fatalln echos in red color and exits with fail status
function fatalln() {
  errorln "$1"
  exit 1
}

export -f errorln
export -f successln
export -f infoln
export -f warnln
