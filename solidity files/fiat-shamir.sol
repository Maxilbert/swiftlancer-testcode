pragma solidity ^0.4.25;

import "./Big_Number_Library.sol";

contract FiatShamir{
    
    event FS(string a);
    
    bytes g_val = hex"447da3cd62f803c191a7f65e91e582a2c56002c59c6205676b561b7e43dee69d889e8a7e4e22cb6ca321f7f0ff29005d1b7aca5f0afa26f88e6bce1d2b4503c89ff55640b109eb0ceb6b304c8d1f0b3015d5f656a49df24aae9daeabf06085bf3b554dc5628fc3a4b0b1d3849ae8530a415219818afadccc05e40c0c9e19b341";
    bool g_neg = false;
    uint g_bitlen = 1023;
    
    bytes h_val = hex"bd49fe4da96732c03a350fa45cd8ea71fd30d768f08c9bfc896fb03daaf8d3fbcf6c9c08fdd65e089ae96db1b0051e9b620a9debffabf1c7f4ce663c1e9740cdb1654a9f09a83051a75cadf9869d34a25c7ccfac84f9cda891f0130eb7b98cdfba3c1e7d2efcc5c3b328d770989329537c8d56b4a16921ef56594f7406caf94d";
    bool h_neg = false;
    uint h_bitlen = 1024;
    
    bytes p_val = hex"da04e8c7457591a5f303377378fdf9777bc7f9bb2957458b40107605692fd8a938e34c8cc0f63486d375ffc9f17ff170c06b1d9d4d6c40d16bc34b5f145f36598c987c624d60c25335b258460f1dcaaa15df44e1c8dff6b556fa5283198956f4864dbca5ff6a2cb02f551a6e17c45e9efc0b540f21c36d56d6763a188459d8fb";
    bool p_neg = false;
    uint p_bitlen = 1024;
    
    BigNumber.instance g=BigNumber.instance(g_val,g_neg,g_bitlen);
    BigNumber.instance h=BigNumber.instance(h_val,h_neg,h_bitlen);
    BigNumber.instance p=BigNumber.instance(p_val,p_neg,p_bitlen);
    
    function hash_equal(bytes cp_val, uint cp_bitlen) returns (bool, bytes){
        
        BigNumber.instance memory c;
        BigNumber.instance memory cp;
        c.val = toBytes(sha3(p_val, g_val, h_val));
        c.neg = false;
        c.bitlen = cp_bitlen;
        
        cp.val = cp_val;
        cp.neg = false;
        cp.bitlen = cp_bitlen;
        
        if(BigNumber.cmp(c, cp, true) == 0){
            emit FS("Equal!");
            return (true, c.val);
        }
        emit FS("Not Equal!");
        return (false, c.val);
    }
    
    function toBytes(bytes32 _data) public pure returns (bytes) {
        return abi.encodePacked(_data);
    }
}