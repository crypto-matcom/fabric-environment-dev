## Running the test network

Development environment for the ***fuel traceability*** project.

A development network with 1 Organization, 1 peer and 1 couchDB.

Navigate to the test network directory by using the following command:

```bash
cd fabric-samples/test-network
```

In this directory, you can find an annotated script, network.sh, that stands up a Fabric network using the Docker images on your local machine.

From inside the test-network directory, run the following command to remove any containers or artifacts from any previous runs:

```bash
./network.sh down
```

You can then bring up the network by issuing the following command. You will experience problems if you try to run the script from another directory:

```bash
./network.sh up createChannel
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
 ./test-network/opscript/allprocess.sh 0.1
```

## Setup Logspout (optional): Monitor peer
To monitor the logs of the smart contract, an administrator can view the aggregated output from a set of Docker containers using the logspout tool.

Open a new terminal and navigate to the test-network directory.

```bash
cd fabric-samples/test-network

./monitordocker.sh net_test
```

```bash
./network.sh restart
```


peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA -C $CHANNEL_NAME -n $CC_NAME --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE  -c '{"function":"org.tecnomatica.fuelbatch:GetBatch","Args":[]}'


peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA -C $CHANNEL_NAME -n $CC_NAME --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE  -c '{"function":"org.tecnomatica.fuelbatch:CreateBatch","Args":[]}'


["{\"identifier\":\"tom\",\"issuer\":\"tom\",\"issueDateTime\":\"2020-04-21\",\"fuelType\":1,\"owner\":\"kmilo\",\"origin\":1}"]


	Identifier    string   `json:"identifier"`
	Issuer        string   `json:"issuer"`
	IssueDateTime string   `json:"issueDateTime"`
	Type          FuelType `json:"fuelType"`
	Owner         string   `json:"owner"`
	Origin        Origin   `json:"origin"`