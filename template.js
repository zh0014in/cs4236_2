var lotteryContract = web3.eth.contract($ABI);

//var theminer = eth.accounts[0];
//var thebuyer = eth.accounts[1];
//var anotherbuyer = eth.accounts[2];
//var theorganiser = eth.accounts[3];

var lottery = lotteryContract.new(
  {
    from: web3.eth.accounts[0],
    data: "$BIN",
    gas: 3000000
  }, function(e, contract){
       if(!e) { if(!contract.address) {
         console.log("Contract transaction send: TransactionHash: " + contract.transactionHash + " waiting to be mined...");
       } else {
         console.log("Contract mined! Address: " + contract.address);
         console.log(contract);
       }
     }
});

