pragma solidity ^0.4.25;


import "./Big_Number_Library.sol";

contract Dispute {
    
    using BigNumber for *;
    
    BigNumber.instance _p;    
    BigNumber.instance _g;
    
    event Decryption(string msg);
    
    constructor () public {
        bytes memory p_val = hex"da04e8c7457591a5f303377378fdf9777bc7f9bb2957458b40107605692fd8a938e34c8cc0f63486d375ffc9f17ff170c06b1d9d4d6c40d16bc34b5f145f36598c987c624d60c25335b258460f1dcaaa15df44e1c8dff6b556fa5283198956f4864dbca5ff6a2cb02f551a6e17c45e9efc0b540f21c36d56d6763a188459d8fb";
        bytes memory g_val = hex"447da3cd62f803c191a7f65e91e582a2c56002c59c6205676b561b7e43dee69d889e8a7e4e22cb6ca321f7f0ff29005d1b7aca5f0afa26f88e6bce1d2b4503c89ff55640b109eb0ceb6b304c8d1f0b3015d5f656a49df24aae9daeabf06085bf3b554dc5628fc3a4b0b1d3849ae8530a415219818afadccc05e40c0c9e19b341";
        _p = BigNumber.instance(p_val, false, 1024);
        _g = BigNumber.instance(g_val, false, 1023);
    }
    
    
    function dispute_handling (bytes c1_val, uint c1_bitlen, bytes c2_val, uint c2_bitlen, bytes k_val, uint k_bitlen) public returns (bool){
        BigNumber.instance memory c1;
        BigNumber.instance memory c2;
        BigNumber.instance memory k;
    
        c1.val = c1_val;
        c1.bitlen = c1_bitlen;
        c1.neg = false;
        
        c2.val = c2_val;
        c2.bitlen = c2_bitlen;
        c2.neg = false;
        
        k.val = k_val;
        k.bitlen = k_bitlen;
        k.neg = false;
        
        BigNumber.instance memory c2_0 = c1.prepare_modexp(k,_p);
        BigNumber.instance memory c2_1 = _g.modmul(c1.prepare_modexp(k,_p),_p);
        
        if(BigNumber.cmp(c2_0,c2,true)==0){
            emit Decryption("this is zero");
            return false;
        }
        else if(BigNumber.cmp(c2_1,c2,true)==0){
            emit Decryption("this is one");
            return false;
        }
        emit Decryption("neither zero nor one");
        return true;
    }
    
    /*
    function dispute_handling (uint index) public returns (bool){
        BigNumber.instance memory c1;
        BigNumber.instance memory c2;
    
        c1.val = answers_map[index].c1.val;
        c1.bitlen = answers_map[index].c1.bitlen;
        c1.neg = false;
        
        c2.val = answers_map[index].c2.val;
        c2.bitlen = answers_map[index].c2.bitlen;
        c2.neg = false;
        
        BigNumber.instance memory c2_0 = c1.prepare_modexp(k,p);
        BigNumber.instance memory c2_1 = g.modmul(c1.prepare_modexp(k,p),p);
        
        if(BigNumber.cmp(c2_0,c2,true)==0){
            emit Decryption("this is zero");
            return false;
        }
        else if(BigNumber.cmp(c2_1,c2,true)==0){
            emit Decryption("this is one");
            return false;
        }
        emit Decryption("neither zero nor one");
        return true;
    }
    
    function test_g() public returns (bool){
        bytes memory g1v = hex"447da3cd62f803c191a7f65e91e582a2c56002c59c6205676b561b7e43dee69d889e8a7e4e22cb6ca321f7f0ff29005d1b7aca5f0afa26f88e6bce1d2b4503c89ff55640b109eb0ceb6b304c8d1f0b3015d5f656a49df24aae9daeabf06085bf3b554dc5628fc3a4b0b1d3849ae8530a415219818afadccc05e40c0c9e19b341";
        BigNumber.instance memory g1; 
        g1.val = g1v;
        g1.neg = false;
        g1.bitlen = 1023;
        BigNumber.instance memory g2;
        (g2.val, g2.neg, g2.bitlen) = ip.get_g();
        if(BigNumber.cmp(g1,g2, true)==0){
            emit Test("True");
            return true;
        }
        else{
            emit Test("False");
            return false;
        }
    }
    
    function dispute_binary_values() payable{
        
    }
    
    function dispute_majority_values() payable{
        
    }
    
    
    function collection_phase(bytes[] c1_val, uint[] c1_bitlen, bytes[] c2_val, uint[] c2_bitlen){
        uint index = 0;
        if(index < num_workers){
            set_workers(index, c1_val[index], c1_bitlen[index], c2_val[index], c1_bitlen[index]);
        }
        else{
            state = Protocol_State.Collected;
        }
    }*/
    
    //BigNumber.instance memory rhs_l = cb1.prepare_modexp(z,p);
    //BigNumber.instance memory rhs_r = ca2.prepare_modexp(c,p);
    
    //BigNumber.instance memory lhs_l = cb2.prepare_modexp(c,p);
    //BigNumber.instance memory lhs_r = ca1.prepare_modexp(z,p);
    
    //if((BigNumber.cmp(lhs, rhs, true) == 0) && (dispute_handling(index))){
    //if(BigNumber.cmp(lhs, rhs, true) == 0){
        
    /*
    function get_state() public returns (string){
        return state;
    }*/
    
    //import "./init_contract.sol";
    
    //Init_Parameters ip;
    
    //answers
    
    /*
    bytes zero_val = hex"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    bool zero_neg = false;
    uint zero_bitlen = 1;*/
    
    //BigNumber.instance zero=BigNumber.instance(zero_val,zero_neg,zero_bitlen);
    //BigNumber.instance one = g.prepare_modexp(zero, p);
    
    //ip = Init_Parameters(init_par);
    
    /*address init_par*/
    
}