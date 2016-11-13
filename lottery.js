var lotteryContract = web3.eth.contract([{"constant":true,"inputs":[],"name":"ticketPrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"number","type":"uint256"},{"name":"random","type":"uint256"}],"name":"generateHash","outputs":[{"name":"result","type":"bytes32"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"maxNumber","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"withdraw","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"currentRoundIndex","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"endRound","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getOwner","outputs":[{"name":"result","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"soldOut","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"rounds","outputs":[{"name":"ticketsCount","type":"uint256"},{"name":"hitNumber","type":"uint256"},{"name":"revealed","type":"bool"},{"name":"prize","type":"uint256"},{"name":"soldOut","type":"bool"},{"name":"beforeEnd","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"timeBeforeEnd","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"getCurrentRound","outputs":[{"name":"round","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"reveal","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"newRound","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"checkBalance","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"checkTicket","outputs":[{"name":"number","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"hash","type":"bytes32"}],"name":"buyTicket","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"number","type":"uint256"},{"name":"random","type":"uint256"}],"name":"verifyNumber","outputs":[],"payable":false,"type":"function"},{"inputs":[],"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"round","type":"uint256"}],"name":"OnGameStart","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"hitNumber","type":"uint256"}],"name":"OnGameEnd","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"number","type":"uint256"}],"name":"OnVerified","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"count","type":"uint256"}],"name":"OnTicketBought","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"round","type":"uint256"},{"indexed":false,"name":"beforeEnd","type":"uint256"}],"name":"OnSoldout","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"message","type":"string"}],"name":"OnException","type":"event"}]);

//var theminer = eth.accounts[0];
//var thebuyer = eth.accounts[1];
//var anotherbuyer = eth.accounts[2];
//var theorganiser = eth.accounts[3];

var lottery = lotteryContract.new(
  {
    from: web3.eth.accounts[0],
    data: "60606040526000600160005055603c6002600050555b33600060006101000a81548173ffffffffffffffffffffffffffffffffffffffff02191690836c010000000000000000000000009081020402179055505b61192c806100616000396000f3606060405236156100ed576000357c0100000000000000000000000000000000000000000000000000000000900480631209b1f6146100f2578063324a7d341461011a5780633a4f6999146101585780633ccfd60b146101805780636896ef4b146101aa578063749aa2d9146101d2578063893d20e8146101e6578063893da6c9146102245780638c65c81f14610238578063a11afa5714610290578063a32bf597146102b8578063a475b5dd146102e0578063c5b1d9aa146102f4578063c71daccb14610308578063c8055e8314610330578063e542327414610358578063eb045dec14610370576100ed565b610002565b34610002576101046004805050610396565b6040518082815260200191505060405180910390f35b346100025761013e600480803590602001909190803590602001909190505061039b565b604051808260001916815260200191505060405180910390f35b346100025761016a6004805050610412565b6040518082815260200191505060405180910390f35b34610002576101926004805050610417565b60405180821515815260200191505060405180910390f35b34610002576101bc600480505061050e565b6040518082815260200191505060405180910390f35b34610002576101e46004805050610517565b005b34610002576101f86004805050610a14565b604051808273ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b34610002576102366004805050610a43565b005b34610002576102536004808035906020019091905050610c03565b6040518087815260200186815260200185151581526020018481526020018315158152602001828152602001965050505050505060405180910390f35b34610002576102a26004805050610c68565b6040518082815260200191505060405180910390f35b34610002576102ca6004805050610c71565b6040518082815260200191505060405180910390f35b34610002576102f26004805050610c83565b005b34610002576103066004805050610e02565b005b346100025761031a600480505061117c565b6040518082815260200191505060405180910390f35b346100025761034260048050506111bd565b6040518082815260200191505060405180910390f35b61036e60048080359060200190919050506112da565b005b3461000257610394600480803590602001909190803590602001909190505061155a565b005b606481565b600060038311156103ab57610002565b6000831115156103ba57610002565b338383604051808473ffffffffffffffffffffffffffffffffffffffff166c0100000000000000000000000002815260140183815260200182815260200193505050506040518091039020905061040c565b92915050565b600381565b60006000600460005060003373ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000505490506000600460005060003373ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600050819055503373ffffffffffffffffffffffffffffffffffffffff166108fc829081150290604051809050600060405180830381858888f19350505050156104cc576001915061050a56610509565b80600460005060003373ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600050819055506000915061050a565b5b5090565b60016000505481565b600060006000600060003373ffffffffffffffffffffffffffffffffffffffff16600060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff161415156105e8577ff4c7c533a16660254da7826d89be9740ec4c1bfbd3454ea9680fb9bf62fff91e6040518080602001828103825260098152602001807f6e6f74206f776e6572000000000000000000000000000000000000000000000081526020015060200191505060405180910390a1610002565b60036000506000600160005054815260200190815260200160002060005060030160009054906101000a900460ff16151561062257610002565b6003600050600060016000505481526020019081526020016000206000506006016000505442101561065357610002565b60009350600092505b600360005060006001600050548152602001908152602001600020600050600101600050548310156108095760011515600360005060006001600050548152602001908152602001600020600050600001600050600085815260200190815260200160002060005060020160149054906101000a900460ff161515148015610745575060036000506000600160005054815260200190815260200160002060005060020160005054600360005060006001600050548152602001908152602001600020600050600001600050600085815260200190815260200160002060005060000160005054145b156107fb57600360005060006001600050548152602001908152602001600020600050600001600050600084815260200190815260200160002060005060020160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1685600086815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff02191690836c0100000000000000000000000090810204021790555083806001019450505b5b828060010193505061065c565b600a606460036000506000600160005054815260200190815260200160002060005060010160005054028115610002570491508160646003600050600060016000505481526020019081526020016000206000506001016000505402036003600050600060016000505481526020019081526020016000206000506004016000508190555060008411156109525783600360005060006001600050548152602001908152602001600020600050600401600050548115610002570490506000925082505b8383101561095157806004600050600087600087815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828282505401925050819055505b82806001019350506108cd565b5b8160046000506000600060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828282505401925050819055507fa812ba8988dbd51077e897aad9b4a8694a9d0b408849ca9c6fadb330fbb910e9600360005060006001600050548152602001908152602001600020600050600201600050546040518082815260200191505060405180910390a15b5b5050505050565b6000600060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050610a40565b90565b3373ffffffffffffffffffffffffffffffffffffffff16600060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16141515610b0a577ff4c7c533a16660254da7826d89be9740ec4c1bfbd3454ea9680fb9bf62fff91e6040518080602001828103825260098152602001807f6e6f74206f776e6572000000000000000000000000000000000000000000000081526020015060200191505060405180910390a1610002565b600160036000506000600160005054815260200190815260200160002060005060050160006101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055506002600050544201600360005060006001600050548152602001908152602001600020600050600601600050819055507f65a31d486ff771fd3e11a56f8e5a143755be68220d16faf818b046f1deab0d2d60016000505460036000506000600160005054815260200190815260200160002060005060060160005054604051808381526020018281526020019250505060405180910390a15b5b565b60036000506020528060005260406000206000915090508060010160005054908060020160005054908060030160009054906101000a900460ff16908060040160005054908060050160009054906101000a900460ff16908060060160005054905086565b60026000505481565b60006001600050549050610c80565b90565b6000600060009150600090505b60036000506000600160005054815260200190815260200160002060005060010160005054811015610d5e57600360005060006001600050548152602001908152602001600020600050600001600050600082815260200190815260200160002060005060020160149054906101000a900460ff1615610d50576003600050600060016000505481526020019081526020016000206000506000016000506000828152602001908152602001600020600050600001600050548218915081505b5b8080600101915050610c90565b6001600383811561000257060191508150600160036000506000600160005054815260200190815260200160002060005060030160006101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055508160036000506000600160005054815260200190815260200160002060005060020160005081905550610dfd610517565b5b5050565b3373ffffffffffffffffffffffffffffffffffffffff16600060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16141515610ec9577ff4c7c533a16660254da7826d89be9740ec4c1bfbd3454ea9680fb9bf62fff91e6040518080602001828103825260098152602001807f6e6f74206f776e6572000000000000000000000000000000000000000000000081526020015060200191505060405180910390a1610002565b60016001600050541015156110155760c060405190810160405280600081526020016000815260200160008152602001600360005060006001600160005054038152602001908152602001600020600050600401600050548152602001600081526020016000815260200150600360005060006001600050548152602001908152602001600020600050600082015181600101600050556020820151816002016000505560408201518160030160006101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055506060820151816004016000505560808201518160050160006101000a81548160ff02191690837f010000000000000000000000000000000000000000000000000000000000000090810204021790555060a08201518160060160005055905050611128565b60c06040519081016040528060008152602001600081526020016000815260200160008152602001600081526020016000815260200150600360005060006001600050548152602001908152602001600020600050600082015181600101600050556020820151816002016000505560408201518160030160006101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055506060820151816004016000505560808201518160050160006101000a81548160ff02191690837f010000000000000000000000000000000000000000000000000000000000000090810204021790555060a082015181600601600050559050505b7f21b31242c523ddbc6fad7a5261208140a6262cbd09a462f5976160113977b9a56001600050546040518082815260200191505060405180910390a160016000818150548092919060010191905055505b5b565b6000600460005060003373ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060005054905080508090506111ba565b90565b60006000600090505b600360005060006001600050548152602001908152602001600020600050600101600050548110156112d5573373ffffffffffffffffffffffffffffffffffffffff16600360005060006001600050548152602001908152602001600020600050600001600050600083815260200190815260200160002060005060020160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1614156112c75760036000506000600160005054815260200190815260200160002060005060000160005060008281526020019081526020016000206000506000016000505491506112d6565b5b80806001019150506111c6565b5b5090565b600060036000506000600160005054815260200190815260200160002060005060050160009054906101000a900460ff161561131557610002565b349050606481101561132657610002565b606481111561136f5760648103600460005060003373ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828282505401925050819055505b80600360005060006001600050548152602001908152602001600020600050600401600082828250540192505081905550608060405190810160405280600081526020018381526020016000815260200160008152602001506003600050600060016000505481526020019081526020016000206000506000016000506000600360005060006001600050548152602001908152602001600020600050600101600050548152602001908152602001600020600050600082015181600001600050556020820151816001016000505560408201518160020160006101000a81548173ffffffffffffffffffffffffffffffffffffffff02191690836c0100000000000000000000000090810204021790555060608201518160020160146101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055509050506003600050600060016000505481526020019081526020016000206000506001016000818150548092919060010191905055507ffee7237fb0d996da05e4828efb5bd07ac4cd7830b14e78e5eb67a1c1db6ab7c6600360005060006001600050548152602001908152602001600020600050600101600050546040518082815260200191505060405180910390a15b5050565b6000600060003411156115d7577ff4c7c533a16660254da7826d89be9740ec4c1bfbd3454ea9680fb9bf62fff91e60405180806020018281038252600f8152602001807f73686f756c64206e6f206574686572000000000000000000000000000000000081526020015060200191505060405180910390a1610002565b338484604051808473ffffffffffffffffffffffffffffffffffffffff166c01000000000000000000000000028152601401838152602001828152602001935050505060405180910390209150600090505b60036000506000600160005054815260200190815260200160002060005060010160005054811015611924578160001916600360005060006001600050548152602001908152602001600020600050600001600050600083815260200190815260200160002060005060010160005054600019161415611916576003841115611728576000600360005060006001600050548152602001908152602001600020600050600001600050600083815260200190815260200160002060005060020160146101000a81548160ff02191690837f0100000000000000000000000000000000000000000000000000000000000000908102040217905550611925565b6000841115156117ae576000600360005060006001600050548152602001908152602001600020600050600001600050600083815260200190815260200160002060005060020160146101000a81548160ff02191690837f0100000000000000000000000000000000000000000000000000000000000000908102040217905550611925565b8360036000506000600160005054815260200190815260200160002060005060000160005060008381526020019081526020016000206000506000016000508190555033600360005060006001600050548152602001908152602001600020600050600001600050600083815260200190815260200160002060005060020160006101000a81548173ffffffffffffffffffffffffffffffffffffffff02191690836c010000000000000000000000009081020402179055506001600360005060006001600050548152602001908152602001600020600050600001600050600083815260200190815260200160002060005060020160146101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055507f12e041fea7de79dbe82d1809cb657043631dc03e05e7800e9ef33deabb61bbfe846040518082815260200191505060405180910390a15b5b8080600101915050611629565b5b5b5050505056",
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

