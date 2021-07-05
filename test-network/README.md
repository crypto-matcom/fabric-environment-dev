## Running the test network

```bash
./network.sh down
```

```bash
./network.sh up createChannel
```

```bash
 ./opscript/allprocess.sh 0.1
```

## Monitor peer
```bash
 ./monitordocker.sh net_test
```

```bash
./network.sh restart
```


peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA -C $CHANNEL_NAME -n $CC_NAME --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE  -c '{"function":"org.tecnomatica.fuelbatch:GetBatch","Args":[]}'


peer chaincode invoke -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA -C $CHANNEL_NAME -n $CC_NAME --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE  -c '{"function":"org.tecnomatica.fuelbatch:CreateBatch","Args":[]}'