pragma solidity ^0.4.25;

import "./Big_Number_Library.sol";
import "./BigTest.sol";

contract crypto_test{
    
    using BigNumber for *;
    
    event Case(string a);
    
    bytes g_val = hex"447da3cd62f803c191a7f65e91e582a2c56002c59c6205676b561b7e43dee69d889e8a7e4e22cb6ca321f7f0ff29005d1b7aca5f0afa26f88e6bce1d2b4503c89ff55640b109eb0ceb6b304c8d1f0b3015d5f656a49df24aae9daeabf06085bf3b554dc5628fc3a4b0b1d3849ae8530a415219818afadccc05e40c0c9e19b341";
    bool g_neg = false;
    uint g_bitlen = 1024;
    
    bytes h_val = hex"bd49fe4da96732c03a350fa45cd8ea71fd30d768f08c9bfc896fb03daaf8d3fbcf6c9c08fdd65e089ae96db1b0051e9b620a9debffabf1c7f4ce663c1e9740cdb1654a9f09a83051a75cadf9869d34a25c7ccfac84f9cda891f0130eb7b98cdfba3c1e7d2efcc5c3b328d770989329537c8d56b4a16921ef56594f7406caf94d";
    bool h_neg = false;
    uint h_bitlen = 1024;
    
    bytes p_val = hex"da04e8c7457591a5f303377378fdf9777bc7f9bb2957458b40107605692fd8a938e34c8cc0f63486d375ffc9f17ff170c06b1d9d4d6c40d16bc34b5f145f36598c987c624d60c25335b258460f1dcaaa15df44e1c8dff6b556fa5283198956f4864dbca5ff6a2cb02f551a6e17c45e9efc0b540f21c36d56d6763a188459d8fb";
    bool p_neg = false;
    uint p_bitlen = 1024;
    
    
    BigNumber.instance g=BigNumber.instance(g_val,g_neg,g_bitlen);
    BigNumber.instance h=BigNumber.instance(h_val,h_neg,h_bitlen);
    BigNumber.instance p=BigNumber.instance(p_val,p_neg,p_bitlen);
    
    // encode bitlen/neg in a bytes array and decode
    function prepare_pedersen_commitment(bytes m_val, bytes m_extra, bytes r_val, bytes r_extra) returns (bytes, bool, uint){
        //require(m.neg==false);
        //require(r.neg==false);
        BigNumber.instance memory m;
        BigNumber.instance memory r;
    
        uint neg;
        uint bitlen;
      
        assembly {
            neg := mload(add(m_extra,0x20))
            bitlen := mload(add(m_extra,0x40))
        }
      
        m.val = m_val;
        m.bitlen = bitlen;
        m.neg = (neg==1) ? true : false;
      
        assembly {
            neg := mload(add(r_extra,0x20))
            bitlen := mload(add(r_extra,0x40))
        }
      
        r.val = r_val;
        r.bitlen = bitlen;
        r.neg = (neg==1) ? true : false;
        
        BigNumber.instance memory res1 = g.prepare_modexp(m,p);
        BigNumber.instance memory res2 = h.prepare_modexp(r,p);
        BigNumber.instance memory res3 = res1.modmul(res2,p);
        
        return (res3.val, res3.neg, res3.bitlen);
    }

    function elgamal_enc(bytes m_val, bytes m_extra, bytes r_val, bytes r_extra, bytes k_val, bytes k_extra) public returns (bytes, bool, uint, bytes, bool, uint){
        BigNumber.instance memory c1; 
        (c1.val, c1.neg, c1.bitlen) = elgamal_enc_c1(r_val, r_extra);
        BigNumber.instance memory c2; 
        (c2.val, c2.neg, c2.bitlen) = elgamal_enc_c2(m_val, m_extra, r_val, r_extra, k_val, k_extra);
        return (c1.val, c1.neg, c1.bitlen, c2.val, c2.neg, c2.bitlen);
    }
    
    function elgamal_enc_c1(bytes r_val, bytes r_extra) public returns (bytes, bool, uint){
        BigNumber.instance memory m;
        BigNumber.instance memory r;
        BigNumber.instance memory k;
        
        uint neg;
        uint bitlen;
      
        assembly {
            neg := mload(add(r_extra,0x20))
            bitlen := mload(add(r_extra,0x40))
        }
      
        r.val = r_val;
        r.bitlen = bitlen;
        r.neg = (neg==1) ? true : false;
        
        BigNumber.instance memory c1 = g.prepare_modexp(r,p);
        
        return (c1.val, c1.neg, c1.bitlen);
    }
    
    function elgamal_enc_c2(bytes m_val, bytes m_extra, bytes r_val, bytes r_extra, bytes k_val, bytes k_extra) public returns (bytes, bool, uint){
        BigNumber.instance memory m;
        BigNumber.instance memory r;
        BigNumber.instance memory k;
        
        uint neg;
        uint bitlen;
      
        assembly {
            neg := mload(add(m_extra,0x20))
            bitlen := mload(add(m_extra,0x40))
        }
      
        m.val = m_val;
        m.bitlen = bitlen;
        m.neg = (neg==1) ? true : false;
      
        assembly {
            neg := mload(add(r_extra,0x20))
            bitlen := mload(add(r_extra,0x40))
        }
      
        r.val = r_val;
        r.bitlen = bitlen;
        r.neg = (neg==1) ? true : false;
        
        assembly {
            neg := mload(add(k_extra,0x20))
            bitlen := mload(add(k_extra,0x40))
        }
      
        k.val = k_val;
        k.bitlen = bitlen;
        k.neg = (neg==1) ? true : false;
        
        BigNumber.instance memory temp = h.prepare_modexp(r,p);
        BigNumber.instance memory c2 = (g.prepare_modexp(m,p)).modmul(temp,p);
        
        return (c2.val, c2. neg, c2.bitlen);
    }
    
    function dispute() public returns (bool){
        BigNumber.instance memory c1;
        BigNumber.instance memory c2;
        BigNumber.instance memory k;
        
        bytes memory c1_val=hex"4c110087c153728fb76543d5415a65c4715764920de9f3b0d7e7fac77cf4af30aeb2790775c2306944191ebd8095944e1f4f30b1414f7689f77a56a90a2ce81a9bc70345310655d4676f96b6964f0b38fae9c729dc5b968c1298206284634a41700fa2e0a5cc31d9661fcbd8aaedb85294c843805a3d3aebc8d35a512dba92bb";
        //bytes c1_extra;
        bytes memory c2_val=hex"9fa8427a7e872eca709a2041fd7e9b1ae1fa5bd0813bb6ef276eae9c08bca334b3887e377570e12edf32639a74f256e9311e1b223dbcc3f5ec4bf53f9fb94755170ce87b576f507abdc01afd914e30f969bed91bf7da1c2b30ee304e71e56a24895a89cade404c558342c5ef4977ed0cc2ffc9fde00b4aa81f0fa73a6a991369";
        //bytes c2_extra;
        bytes memory k1_val= hex"0e45be7ccd9676f45d61451952980fdaf6feef13531f92e8f1225cf6ea09427f96c8ebe49ce3571f4219001a8b9bcae5eab9fc635a3f7483e4f61f5505bee49c617739802fdc0224475804541fae10adad0e12ab31887fd41c4996227302a991840fc9e212ba44f3204f096c09930e85a81f2b03bc0fc07fb0e18f49b7c7d624";
        //bytes k_extra;
        
        uint neg;
        uint bitlen;
      /*
        assembly {
            neg := mload(add(c1_extra,0x20))
            bitlen := mload(add(c1_extra,0x40))
        }
      */
        c1.val = c1_val;
        c1.bitlen = 1024;
        c1.neg = false;
        /*
        assembly {
            neg := mload(add(k_extra,0x20))
            bitlen := mload(add(k_extra,0x40))
        }
        */
        k.val = k1_val;
        k.bitlen = 1024;
        k.neg = false;
        /*
        assembly {
            neg := mload(add(c2_extra,0x20))
            bitlen := mload(add(c2_extra,0x40))
        }*/
      
        c2.val = c2_val;
        c2.bitlen = 1024;
        c2.neg = false;
        
        BigNumber.instance memory d0 = c1.prepare_modexp(k,p);
        BigNumber.instance memory d1 = g.modmul(c1.prepare_modexp(k,p),p);
        if(BigNumber.cmp(d0,c2,true)==0){
            
            emit Case("Ciphertext 0");
            return false;
        }
        else if(BigNumber.cmp(d1,c2,true)==0){
            
            emit Case("Ciphertext 1");
            return false;
        }
        emit Case("Dispute");
        return true;
        
    }
    /*
    function dispute(bytes c1_val, bytes c1_extra, bytes c2_val, bytes c2_extra, bytes k_val, bytes k_extra) public returns (bool){
        BigNumber.instance memory c1;
        BigNumber.instance memory c2;
        BigNumber.instance memory k;
        
        uint neg;
        uint bitlen;
      
        assembly {
            neg := mload(add(c1_extra,0x20))
            bitlen := mload(add(c1_extra,0x40))
        }
      
        c1.val = c1_val;
        c1.bitlen = bitlen;
        c1.neg = (neg==1) ? true : false;
        
        assembly {
            neg := mload(add(k_extra,0x20))
            bitlen := mload(add(k_extra,0x40))
        }
      
        k.val = k_val;
        k.bitlen = bitlen;
        k.neg = (neg==1) ? true : false;
        
        assembly {
            neg := mload(add(c2_extra,0x20))
            bitlen := mload(add(c2_extra,0x40))
        }
      
        c2.val = c2_val;
        c2.bitlen = bitlen;
        c2.neg = (neg==1) ? true : false;
        
        BigNumber.instance memory d0 = c1.prepare_modexp(k,p);
        BigNumber.instance memory d1 = g.modmul(c1.prepare_modexp(k,p),p);
        if(BigNumber.cmp(d0,c2,true)==0){
            return false;
            emit Case("Ciphertext 0");
        }
        else if(BigNumber.cmp(d1,c2,true)==0){
            return false;
            emit Case("Ciphertext 1");
        }
        return true;
    }*/
}