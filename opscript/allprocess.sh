#!/bin/bash
# Script to install chaincode onto a peer node

ROOT=/home/portainer/fabric-samples/
source ${ROOT}/scripts/utils.sh

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}

export CHANNEL_NAME="channel"
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/home/portainer/fabric-samples/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/home/portainer/fabric-samples/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/
export CORE_PEER_ADDRESS=127.0.0.1:7051
export ORDERER_ADDRESS=127.0.0.1:7050
export ORDERER_HOSTNAME=orderer.example.com
export ORDERER_TLS_CA=/home/portainer/fabric-samples/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem


CC_VERSION="$1"
: ${CC_VERSION:="0.1"}

INIT_REQUIRED="$2"
: ${INIT_REQUIRED:=""}

CC_COLL_CONFIG=${4:-"NA"}

export CC_VERSION
export CC_NAME=traceability
export CC_SRC_PATH_ROOT=/home/portainer/fabric-samples/chaincode
export CC_SRC_PATH="${CC_SRC_PATH_ROOT}/"
export CC_LABEL="${CC_NAME}_${CC_VERSION}"
export INIT_REQUIRED

if [ "$CC_COLL_CONFIG" = "NA" ]; then
  CC_COLL_CONFIG=""
else
  CC_COLL_CONFIG="--collections-config $CC_COLL_CONFIG"
fi

echo "Eliminando container de chaincodes instalados previamente"
set -x
docker rmi -f $(docker images dev-peer* -q);
set +x
echo
echo "INICIANDO PROCESO DE INSTALACION"
echo "VARIABLES DE ENTORNO:"
echo ""
echo "CHAINCODE NAME: ${CC_NAME}"
echo "CHAINCODE LABEL: ${CC_LABEL}"
echo "CHAINCODE VERSION: ${CC_VERSION}"
# echo "CHAINCODE POLICY: ${CC_END_POLICY}"
echo "CHAINCODE CARPETA RAIZ: ${CC_SRC_PATH_ROOT}"


cd $CC_SRC_PATH_ROOT

  # go env -w GOPROXY=https://goproxy.cn,direct

if [ -f "cc-${CC_NAME}-go.tar.gz" ]; then
  rm ./cc-${CC_NAME}-go.tar.gz
fi

if [ ! -f "cc-${CC_NAME}-go.tar.gz" ]; then
  cd cc-${CC_NAME}-go
  go mod vendor
  cd -
  peer lifecycle chaincode package cc-${CC_NAME}-go.tar.gz -p cc-${CC_NAME}-go/ --lang golang --label ${CC_LABEL}
fi

# peer lifecycle chaincode package cc-${CC_NAME}-go.tar.gz -p cc-${CC_NAME}-go/ --lang golang --label ${CC_LABEL}

echo "install chaincode "
peer lifecycle chaincode install cc-${CC_NAME}-go.tar.gz


queryInstalled() {
  echo "query installed in: ${CC_SRC_PATH_ROOT}"
  set -x
  peer lifecycle chaincode queryinstalled >&log.txt
  res=$?
  { set +x; } 2>/dev/null
  cat log.txt
  PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
  verifyResult $res "Query installed on peer0.org${ORG} has failed"
  successln "Query installed successful on peer0.org${ORG} on channel"
  # peer lifecycle chaincode queryinstalled -O json | jq -r ".installed_chaincodes | .[] | select(.package_id|startswith(\"${CC_LABEL}:\"))" > ccstatus.json
}

approveForMyOrg() {
  set -x
  peer lifecycle chaincode approveformyorg -o ${ORDERER_ADDRESS} --ordererTLSHostnameOverride ${ORDERER_HOSTNAME} --tls --cafile ${ORDERER_TLS_CA} --channelID ${CHANNEL_NAME} --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED}  ${CC_COLL_CONFIG} >&log.txt
  res=$?
  { set +x; } 2>/dev/null
  cat log.txt
  verifyResult $res "Chaincode definition approved on peer0.org${ORG} on channel '$CHANNEL_NAME' failed"
  successln "Chaincode definition approved on peer0.org${ORG} on channel '$CHANNEL_NAME'"
}

queryInstalled

peer lifecycle chaincode queryinstalled -O json | jq -r ".installed_chaincodes | .[] | select(.package_id|startswith(\"${CC_LABEL}:\"))" > ccstatus.json
PKID=$(jq '.package_id' ccstatus.json | xargs)
REF=$(jq ".references.${CHANNEL_NAME}" ccstatus.json)

SID=$(peer lifecycle chaincode querycommitted -C $CHANNEL_NAME -O json \
  | jq -r ".chaincode_definitions|.[]|select(.name==\"${CC_NAME}\")|.sequence" || true)


if [[ -z $SID ]]; then
  CC_SEQUENCE=1
elif [[ -z $REF ]]; then
  CC_SEQUENCE=$SID
else
  CC_SEQUENCE=$((1+$SID))
fi

cat ./ccstatus.json

# approve
# set -x
# peer lifecycle chaincode approveformyorg --channelID ${CHANNEL_NAME} --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PKID} --sequence ${CC_SEQUENCE} -o ${ORDERER_ADDRESS} --tls --cafile $ORDERER_TLS_CA
# set +x

approveForMyOrg


set -x
# query the latest approved definition
peer lifecycle chaincode queryapproved -C  ${CHANNEL_NAME} -n ${CC_NAME} --sequence ${CC_SEQUENCE} --output json
set +x


set -x
# Check whether a chaincode definition is ready to be committed
peer lifecycle chaincode checkcommitreadiness -o ${ORDERER_ADDRESS} --channelID ${CHANNEL_NAME} --tls --cafile ${ORDERER_TLS_CA} --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE}
set +x

set -x
# Commit the definition the channel
peer lifecycle chaincode commit -o ${ORDERER_ADDRESS} --channelID ${CHANNEL_NAME} --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} --tls --cafile $ORDERER_TLS_CA --peerAddresses $CORE_PEER_ADDRESS  --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE
set +x


set -x
# query all chaincode definitions on that channel
peer lifecycle chaincode querycommitted -o $ORDERER_ADDRESS --channelID $CHANNEL_NAME --tls --cafile $ORDERER_TLS_CA --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE
set +x

echo "FINISH..."