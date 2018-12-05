pragma solidity ^0.4.16;

contract Elgamal{ 
     
     uint y; 
     uint p; //prime
     uint g; //generator
     uint e; //exponentiation
     function Sticker (uint x){
         y = x;
     }  
     function set(uint x) {
         y = x;
     }  
     function get() constant returns (uint) {
         return y;
    }
    // prime p <= 2048
    // generator g <= 10
    // exponentiation e 
    
    function isEqual(uint[] x, uint[] y, uint len) returns (bool){
        for(uint i=0; i<len;i++){
            if(x[i] != y[i]){
                return false;
            }
        }
        return true;
    }
        

    // computes g^x (mod p) x<=32 g<=255
    function exp(uint g, uint p, uint x) returns (uint){
        uint e = g;
        uint f = 1;
        for(uint j=0; j<x; j++){
            f = (g * e)%p;
            e = f; 
        }
        return e;
    }
    /*
    function expsol(uint g, uint[] p, uint[] x) returns (uint[]){
        
    }
    */
    function dispute(uint sk, uint g, uint h, uint p, uint c1, uint c2)returns (uint){
        uint dispVal = 1000;
        if((g ** k)%p == h){
            if(((c1 ** k)%p != c2) && ((g*c1 ** k)%p != c2)){
                return dispVal; // message is not 0 or 1
            }
            else{
                return 1; // false dispute raised
            }
        }
        
    }

}