// Ethereum + Solidity
// This code sample & more @ dev.oraclize.it

import "oraclizeAPI.sol";

contract PriceFeed is usingOraclize {
  uint public ETHUSD;
    
  function PriceFeed(){
    oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
    update(0); // first check at contract creation
  }
    
  function __callback(bytes32 myid, string result, bytes proof) {
    if (msg.sender != oraclize_cbAddress()) throw;
    ETHUSD = parseInt(result, 2); // save it as $ cents
    // do something with ETHUSD
    //update(60); //recursive update disabled
  }
  
  function update(uint delay){
    // call oraclize and retrieve the latest USD/ETH price from Poloniex APIs
    oraclize_query(delay, "URL",
      "json(https://poloniex.com/public?command=returnTicker).USDT_ETH.last");
  }
}