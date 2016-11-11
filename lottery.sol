
pragma solidity ^0.4.0;

// <ORACLIZE_API>
/*
Copyright (c) 2015-2016 Oraclize SRL
Copyright (c) 2016 Oraclize LTD



Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:



The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.



THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

pragma solidity ^0.4.0;

contract OraclizeI {
    address public cbAddress;
    function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
    function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
    function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
    function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
    function getPrice(string _datasource) returns (uint _dsprice);
    function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
    function useCoupon(string _coupon);
    function setProofType(byte _proofType);
    function setCustomGasPrice(uint _gasPrice);
}
contract OraclizeAddrResolverI {
    function getAddress() returns (address _addr);
}
contract usingOraclize {
    uint constant day = 60*60*24;
    uint constant week = 60*60*24*7;
    uint constant month = 60*60*24*30;
    byte constant proofType_NONE = 0x00;
    byte constant proofType_TLSNotary = 0x10;
    byte constant proofStorage_IPFS = 0x01;
    uint8 constant networkID_auto = 0;
    uint8 constant networkID_mainnet = 1;
    uint8 constant networkID_testnet = 2;
    uint8 constant networkID_morden = 2;
    uint8 constant networkID_consensys = 161;

    OraclizeAddrResolverI OAR;
    
    OraclizeI oraclize;
    modifier oraclizeAPI {
        if(address(OAR)==0) oraclize_setNetwork(networkID_auto);
        oraclize = OraclizeI(OAR.getAddress());
        _;
    }
    modifier coupon(string code){
        oraclize = OraclizeI(OAR.getAddress());
        oraclize.useCoupon(code);
        _;
    }

    function oraclize_setNetwork(uint8 networkID) internal returns(bool){
        if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){
            OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
            return true;
        }
        if (getCodeSize(0x9efbea6358bed926b293d2ce63a730d6d98d43dd)>0){
            OAR = OraclizeAddrResolverI(0x9efbea6358bed926b293d2ce63a730d6d98d43dd);
            return true;
        }
        if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){
            OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
            return true;
        }
        if (getCodeSize(0x9a1d6e5c6c8d081ac45c6af98b74a42442afba60)>0){
            OAR = OraclizeAddrResolverI(0x9a1d6e5c6c8d081ac45c6af98b74a42442afba60);
            return true;
        }
        return false;
    }
    
    function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
        return oraclize.query.value(price)(0, datasource, arg);
    }
    function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
        return oraclize.query.value(price)(timestamp, datasource, arg);
    }
    function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
        return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
    }
    function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
        return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
    }
    function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
        return oraclize.query2.value(price)(0, datasource, arg1, arg2);
    }
    function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource);
        if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
        return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
    }
    function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
        return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
    }
    function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
        return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
    }
    function oraclize_cbAddress() oraclizeAPI internal returns (address){
        return oraclize.cbAddress();
    }
    function oraclize_setProof(byte proofP) oraclizeAPI internal {
        return oraclize.setProofType(proofP);
    }
    function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
        return oraclize.setCustomGasPrice(gasPrice);
    }    
    function oraclize_setConfig(bytes config) oraclizeAPI internal {
        //return oraclize.setConfig(config);
    }

    function getCodeSize(address _addr) constant internal returns(uint _size) {
        assembly {
            _size := extcodesize(_addr)
        }
    }


    function parseAddr(string _a) internal returns (address){
        bytes memory tmp = bytes(_a);
        uint160 iaddr = 0;
        uint160 b1;
        uint160 b2;
        for (uint i=2; i<2+2*20; i+=2){
            iaddr *= 256;
            b1 = uint160(tmp[i]);
            b2 = uint160(tmp[i+1]);
            if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
            else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
            if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
            else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
            iaddr += (b1*16+b2);
        }
        return address(iaddr);
    }


    function strCompare(string _a, string _b) internal returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
   } 

    function indexOf(string _haystack, string _needle) internal returns (int)
    {
        bytes memory h = bytes(_haystack);
        bytes memory n = bytes(_needle);
        if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
            return -1;
        else if(h.length > (2**128 -1))
            return -1;                                  
        else
        {
            uint subindex = 0;
            for (uint i = 0; i < h.length; i ++)
            {
                if (h[i] == n[0])
                {
                    subindex = 1;
                    while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
                    {
                        subindex++;
                    }   
                    if(subindex == n.length)
                        return int(i);
                }
            }
            return -1;
        }   
    }

    function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
        for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
        for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
        return string(babcde);
    }
    
    function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
        return strConcat(_a, _b, _c, _d, "");
    }

    function strConcat(string _a, string _b, string _c) internal returns (string) {
        return strConcat(_a, _b, _c, "", "");
    }

    function strConcat(string _a, string _b) internal returns (string) {
        return strConcat(_a, _b, "", "", "");
    }

    // parseInt
    function parseInt(string _a) internal returns (uint) {
        return parseInt(_a, 0);
    }

    // parseInt(parseFloat*10^_b)
    function parseInt(string _a, uint _b) internal returns (uint) {
        bytes memory bresult = bytes(_a);
        uint mint = 0;
        bool decimals = false;
        for (uint i=0; i<bresult.length; i++){
            if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
                if (decimals){
                   if (_b == 0) break;
                    else _b--;
                }
                mint *= 10;
                mint += uint(bresult[i]) - 48;
            } else if (bresult[i] == 46) decimals = true;
        }
        if (_b > 0) mint *= 10**_b;
        return mint;
    }
    

}
// </ORACLIZE_API>


contract lottery is usingOraclize{
    address private owner;
    uint public constant ticketPrice = 100 finney;
    uint public constant maxNumber = 50;
    uint public revealedDate;
    uint public currentGameIndex = 0;
    
    struct ticket{
        uint guess;
        bytes32 hashValue;
        address playerAddress;
        bool valid; // indicate if this ticket is valid
    }
    
    struct round {
        mapping(uint => ticket) tickets;
        uint ticketsCount;
        uint hitNumber;
        bool revealed;
        bytes32 oraclizeId;
        uint prize;
    }
    round[] public rounds;
    
    mapping(address => uint) pendingWithdrawals;
    
    // modifiers
    modifier onlyOwner() { if (owner != msg.sender) { throw; } _; }
    modifier noEther() { if (msg.value > 0) { throw; } _; }
    
    // events
    event OnGameStart(uint round);
    event OnGameEnd(uint hitNumber);
    event OnHitNumberGenerated(uint hitNumber);
    event OnTicketBought(uint count);

    // constructor
    function lottery(){
        owner = msg.sender;
    }
    
    // owner call this function to start a new round
    function newRound() onlyOwner{
        rounds.length++;
        currentGameIndex = rounds.length - 1;
        rounds[currentGameIndex].ticketsCount = 0;
        rounds[currentGameIndex].hitNumber = 0;
        rounds[currentGameIndex].revealed = false;
        rounds[currentGameIndex].oraclizeId = 0;
        if(currentGameIndex >= 1){
            // start from the second round, tranfser previous round's prize to current round if any
            rounds[currentGameIndex].prize = rounds[currentGameIndex-1].prize;
        }else{
            rounds[currentGameIndex].prize = 0;
        }
        OnGameStart(currentGameIndex);
    }
    
    // owner call this to end a round and send prize to winner
    function endRound() onlyOwner{
        if(!rounds[currentGameIndex].revealed) throw;
        address[] winners;
        for(uint i = 0; i < rounds[currentGameIndex].ticketsCount; i++){
            if(rounds[currentGameIndex].tickets[i].valid == true &&
                rounds[currentGameIndex].tickets[i].guess == rounds[currentGameIndex].hitNumber){
                winners.push(rounds[currentGameIndex].tickets[i].playerAddress);
            }
        }
        // %10 of the pot goes to owner
        var commission = rounds[currentGameIndex].ticketsCount * ticketPrice / 10;
        // rest is the prize
        rounds[currentGameIndex].prize = rounds[currentGameIndex].ticketsCount * ticketPrice - commission;
        
        if(winners.length > 0){
            var share = rounds[currentGameIndex].prize / winners.length;
            for(i = 0; i < winners.length; i++){
                pendingWithdrawals[winners[i]] += share;
            }
        }
        
        // owner has the commision
        pendingWithdrawals[owner] += commission;
        OnGameEnd(rounds[currentGameIndex].hitNumber);
    }
    
    function buyTicket(bytes32 hash)
    payable
    {
        uint value = msg.value;
        if(value < ticketPrice){
            throw;
        }
        for(uint i = 0; i < rounds[currentGameIndex].ticketsCount; i++){
            if(rounds[currentGameIndex].tickets[i].playerAddress == msg.sender){
                // the player has bought a ticket
                throw;
            }
        }
        if(value > ticketPrice){
            // mark exceeding value as withdraw
            pendingWithdrawals[msg.sender] += value - ticketPrice;
        }
        rounds[currentGameIndex].prize += value;
        rounds[currentGameIndex].tickets[rounds[currentGameIndex].ticketsCount] = ticket(0, hash, msg.sender, false);
        rounds[currentGameIndex].ticketsCount++;
        OnTicketBought(rounds[currentGameIndex].ticketsCount);
    }

    function reveal()
    {
        getRandom();
    }

    function getRandom(){
        rounds[currentGameIndex].oraclizeId = oraclize_query(0, "WolframAlpha", "random number between 1 and 6");
    }

    function __callback(bytes32 _id, string _result) {
       if (rounds[currentGameIndex].revealed) throw;
       if (rounds[currentGameIndex].oraclizeId ==0 || rounds[currentGameIndex].oraclizeId != _id) throw;
       rounds[currentGameIndex].revealed = true;
       revealedDate = now;
       rounds[currentGameIndex].hitNumber = parseInt(_result,10);
       OnHitNumberGenerated(rounds[currentGameIndex].hitNumber);
    }
    
    // player call to verify their numbers
    function verifyNumber(uint number) noEther {
    for(uint i = 0; i < rounds[currentGameIndex].ticketsCount; i++){
            if(rounds[currentGameIndex].tickets[i].playerAddress == msg.sender){
                if(number > maxNumber){
                    rounds[currentGameIndex].tickets[i].valid = false;
                }
                if(number <= 0){
                    rounds[currentGameIndex].tickets[i].valid = false;
                }
                var toHash = uint(msg.sender) + number;
                if(rounds[currentGameIndex].tickets[i].hashValue == sha3(toHash)){
                    rounds[currentGameIndex].tickets[i].valid = true;
                    rounds[currentGameIndex].tickets[i].guess = number;
                }else{
                    rounds[currentGameIndex].tickets[i].valid = false;
                }
            }
        }
}

    function checkBalance() returns(uint balance){
        balance = pendingWithdrawals[msg.sender];
    }

    // withdraw the pending amount
    function withdraw() returns(bool){
        uint amount = pendingWithdrawals[msg.sender];
        pendingWithdrawals[msg.sender] = 0;
        if(msg.sender.send(amount)){
            return true;
        }else{
            pendingWithdrawals[msg.sender] = amount;
            return false;
        }
    }
    
    // functions not modifying the state of contract
    function generateHash(uint number) constant returns(bytes32 result){
        if(number > maxNumber){
            throw;
        }
        if(number <= 0){
            throw;
        }
        var toHash = uint(msg.sender) + number;
        return sha3(toHash);
    }
}
