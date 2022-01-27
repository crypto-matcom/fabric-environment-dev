## Running the test network

Development environment for ***fabric*** projects.

A development network with 1 Organization, 1 peer and 1 couchDB.

Navigate to the test network directory by using the following command:

```bash
cd fabric-environment-dev
```

In this directory, you can find an annotated script, network.sh, that stands up a Fabric network using the Docker images on your local machine.

From inside the fabric-environment-dev directory, run the following command to down network previous runs:

```bash
./network.sh down
```

You can then bring up the network by issuing the following command. You will experience problems if you try to run the script from another directory:

```bash
./network.sh up
```

 ❗ As impoortant note, you have to check that the /bin, /script and /chaincode folders has execution (+x) permission.

## Install Chaincode

The chaincode(s) must be located in the _chaincode_ folder. The chaincode folder name must comply with the following encoding rule: cc-__foldername__-go.

for example: cc-traceability-go

```bash
cd ./chaincode
```
Once located in the "__chaincode__" folder, execute a __git clone__ of the chaincode.
Then to install the chaincode on __peer0__ you just have to run the following command:

```bash
 ./network.sh deployCC -ccv 1.0.1 -ccn chaincode_name
```

```bash
# for example:

 ./network.sh deployCC -ccv 0.1 -ccn traceability
```
The above command installs the traceability chaincode which is in the chaincode folder and is called __cc-traceability-go__

The value of the -ccn parameter is the name of the chaincode folder without the cc- and without the -go.

## Setup Logspout (optional): Monitor peer
To monitor the logs of the smart contract, an administrator can view the aggregated output from a set of Docker containers using the logspout tool.

Open a new terminal and navigate to the fabric-environment-dev directory.

```bash
cd fabric-environment-dev

./monitordocker.sh
```

## Environment Variable

Add the following environment variables to your profile:
```bash
nano ~/.profile
```

```bash
export FABRIC_ENV_DEV=${HOME}/fabric-environment-dev
export PATH=${FABRIC_ENV_DEV}/bin:$PATH


export CHANNEL_NAME="channel"
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export FABRIC_CFG_PATH=${FABRIC_ENV_DEV}/config/
export CORE_PEER_TLS_ROOTCERT_FILE=${FABRIC_ENV_DEV}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${FABRIC_ENV_DEV}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/
export CORE_PEER_ADDRESS=127.0.0.1:7051
export ORDERER_ADDRESS=127.0.0.1:7050
export ORDERER_HOSTNAME=orderer.example.com
export ORDERER_TLS_CA=${FABRIC_ENV_DEV}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export CC_NAME=traceability
```
If you don't use the blockchain-matcom VM you must modify the paths (CORE_PEER_TLS_ROOTCERT_FILE, CORE_PEER_MSPCONFIGPATH and ORDERER_TLS_CA) with the correct paths

## Interacting with chaincode
From the shell you can invoke the chaincode

```bash
// example:

peer chaincode invoke -c '{"function":"chaincode_name:TransactionExample","Args":[]}' -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA -C $CHANNEL_NAME -n $CC_NAME --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE 
```


