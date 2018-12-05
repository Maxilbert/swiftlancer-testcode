pragma solidity ^0.4.25;

import "./Big_Number_Library.sol";

contract Majority_Dispute{
    using BigNumber for *;
    BigNumber.instance _p;    
    BigNumber.instance _h;
    uint n; // number of workers
    BigNumber.instance rew;
    
    event Worker_Reward(string a);
    
    event Requester_Reward(string b);
    
    constructor () public {
        bytes memory p_val = hex"da04e8c7457591a5f303377378fdf9777bc7f9bb2957458b40107605692fd8a938e34c8cc0f63486d375ffc9f17ff170c06b1d9d4d6c40d16bc34b5f145f36598c987c624d60c25335b258460f1dcaaa15df44e1c8dff6b556fa5283198956f4864dbca5ff6a2cb02f551a6e17c45e9efc0b540f21c36d56d6763a188459d8fb";
        bytes memory h_val = hex"bd49fe4da96732c03a350fa45cd8ea71fd30d768f08c9bfc896fb03daaf8d3fbcf6c9c08fdd65e089ae96db1b0051e9b620a9debffabf1c7f4ce663c1e9740cdb1654a9f09a83051a75cadf9869d34a25c7ccfac84f9cda891f0130eb7b98cdfba3c1e7d2efcc5c3b328d770989329537c8d56b4a16921ef56594f7406caf94d";
        _p = BigNumber.instance(p_val, false, 1024);
        _h = BigNumber.instance(h_val, false, 1024);
        n = 12;
    }
    
    function majority_dispute(bytes rr_val, uint rr_bitlen, bytes rw_val, uint rw_bitlen, bytes pf_val, uint pf_bitlen) returns (bool){
        BigNumber.instance memory rr;
        BigNumber.instance memory rw;
        BigNumber.instance memory pf;
    
        rr.val = rr_val;
        rr.bitlen = rr_bitlen;
        rr.neg = false;
        
        rw.val = rw_val;
        rw.bitlen = rw_bitlen;
        rw.neg = false;
        
        pf.val = pf_val;
        pf.bitlen = pf_bitlen;
        pf.neg = false;
        
        BigNumber.instance memory sub = rr.prepare_sub(rw);
        BigNumber.instance memory verf = _h.prepare_modexp(sub, _p);
        
        if(BigNumber.cmp(pf,verf,true)==0){
            emit Worker_Reward("This worker should be rewarded");
            return true;
        }
        
        emit Worker_Reward("Cheating worker! No reward!");
        return false;
    }
}