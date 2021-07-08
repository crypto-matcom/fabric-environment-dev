## Running the test network

Development environment for the ***fuel traceability*** project.

A development network with 1 Organization, 1 peer and 1 couchDB.

Navigate to the test network directory by using the following command:

```bash
cd fabric-samples
```

In this directory, you can find an annotated script, network.sh, that stands up a Fabric network using the Docker images on your local machine.

From inside the fabric-samples directory, run the following command to down network previous runs:

```bash
./network.sh down
```

You can then bring up the network by issuing the following command. You will experience problems if you try to run the script from another directory:

```bash
./network.sh up
./network.sh createChannel
```

## Install traceability Chaincode

To install the traceability chaincode, create a chaincode ex folder: fabric-samples/chaincode
```bash
	cd fabric-samples
	mkdir chaincode
```
And inside exec a git clone of the traceability chaincode.
Then to install the chaincode on peer0 you just have to run the allprocess script, ex: ./allprocess.sh #version

```bash
 ./opscript/allprocess.sh 0.1
```

## Setup Logspout (optional): Monitor peer
To monitor the logs of the smart contract, an administrator can view the aggregated output from a set of Docker containers using the logspout tool.

Open a new terminal and navigate to the fabric-samples directory.

```bash
cd fabric-samples

./monitordocker.sh
```

```bash
./network.sh restart
```

## Environment Variable

Add the following environment variables to your profile:
```bash
nano ~/.profile
```

```bash
export CHANNEL_NAME="channel"
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/home/portainer/fabric-samples/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/home/portainer/fabric-samples/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/
export CORE_PEER_ADDRESS=127.0.0.1:7051
export ORDERER_ADDRESS=127.0.0.1:7050
export ORDERER_HOSTNAME=orderer.example.com
export ORDERER_TLS_CA=/home/portainer/fabric-samples/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export CC_NAME=traceability
```
If you don't use the blockchain-matcom VM you must modify the paths (CORE_PEER_TLS_ROOTCERT_FILE, CORE_PEER_MSPCONFIGPATH and ORDERER_TLS_CA) with the correct paths

## Interacting with chaincode
From the shell you can invoke the chaincode

```bash
// OnlyDev: populate with fake data
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA -C $CHANNEL_NAME -n $CC_NAME --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE  -c  '{"function":"org.tecnomatica.identity:OnlyDev","Args":[]}'
```

```bash
// CreateIssuing
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA -C $CHANNEL_NAME -n $CC_NAME --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE  -c  '{"function":"org.tecnomatica.identity:CreateIssuing","Args":["{\"name\":\"Autoridad de Certificación Tecnomática\",\"certPem\":\"CertPem\"}"]}'
```

```bash
// CreateIdentity
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA -C $CHANNEL_NAME -n $CC_NAME --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE  -c  '{"function":"org.tecnomatica.identity:CreateIdentity","Args":["{\"did\":\"did:vtn:tecnomatica:aa43bdf5b4bcfac88ce9093ec3f0d58290f11c7ef6d2a683a7ee56746b333ec71\",\"certPem\":\"CertPem\"}"]}'
```

```bash
// GetIdentity
peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA -C $CHANNEL_NAME -n $CC_NAME --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE  -c  '{"function":"org.tecnomatica.identity:GetIdentity","Args":["{\"did\":\"did:vtn:tecnomatica:aa43bdf5b4bcfac88ce9093ec3f0d58290f11c7ef6d2a683a7ee56746b333ec71\"}"]}'
```

