pragma solidity ^0.4.25;

import "./Big_Number_Library.sol";


contract SwiftLancer{
    
    enum Protocol_State{Task_Publish, Collecting_Answers, Collected}
    Protocol_State state;
    using BigNumber for *;
    address owner;
    uint public current_worker_num;
    uint public num_workers;
    event Test(string a);
    
    event Collection(string a);
    
    event Answers_Test(string b);
    
    event Same_PlainText(string a);
    
    event Out_Of_Range(string b);
    
    event Zero_And_One(string a);
    
    struct answers{  
        BigNumber.instance c1;
        BigNumber.instance c2;
    }
    
    
    bytes g_val = hex"447da3cd62f803c191a7f65e91e582a2c56002c59c6205676b561b7e43dee69d889e8a7e4e22cb6ca321f7f0ff29005d1b7aca5f0afa26f88e6bce1d2b4503c89ff55640b109eb0ceb6b304c8d1f0b3015d5f656a49df24aae9daeabf06085bf3b554dc5628fc3a4b0b1d3849ae8530a415219818afadccc05e40c0c9e19b341";
    bool g_neg = false;
    uint g_bitlen = 1023;
    
    bytes h_val = hex"bd49fe4da96732c03a350fa45cd8ea71fd30d768f08c9bfc896fb03daaf8d3fbcf6c9c08fdd65e089ae96db1b0051e9b620a9debffabf1c7f4ce663c1e9740cdb1654a9f09a83051a75cadf9869d34a25c7ccfac84f9cda891f0130eb7b98cdfba3c1e7d2efcc5c3b328d770989329537c8d56b4a16921ef56594f7406caf94d";
    bool h_neg = false;
    uint h_bitlen = 1024;
    
    bytes p_val = hex"da04e8c7457591a5f303377378fdf9777bc7f9bb2957458b40107605692fd8a938e34c8cc0f63486d375ffc9f17ff170c06b1d9d4d6c40d16bc34b5f145f36598c987c624d60c25335b258460f1dcaaa15df44e1c8dff6b556fa5283198956f4864dbca5ff6a2cb02f551a6e17c45e9efc0b540f21c36d56d6763a188459d8fb";
    bool p_neg = false;
    uint p_bitlen = 1024;
    
    bytes one_val = hex"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001";
    bool one_neg = false;
    uint one_bitlen = 1;
    
    
    
    BigNumber.instance g=BigNumber.instance(g_val,g_neg,g_bitlen);
    BigNumber.instance h=BigNumber.instance(h_val,h_neg,h_bitlen);
    BigNumber.instance p=BigNumber.instance(p_val,p_neg,p_bitlen);
    BigNumber.instance one=BigNumber.instance(one_val,one_neg,one_bitlen);
    
    mapping(uint => answers) public answers_map;
    
    uint[] workers_accts;
    
    constructor () public{
        state = Protocol_State.Collecting_Answers;
        
        owner = msg.sender;
        current_worker_num = 1;
        num_workers = 15;
    }
    
    function collect_answers(uint i) public returns (bytes,bool,uint,bytes,bool,uint){
        emit Collection("Answer collected!");
        return (answers_map[i].c1.val, answers_map[i].c1.neg, answers_map[i].c1.bitlen, answers_map[i].c2.val, answers_map[i].c2.neg, answers_map[i].c2.bitlen);
    }

    function get_current_worker() public returns (uint){
        return current_worker_num;
    } 
    
    
    function submit_answers(bytes c1_val, uint c1_bitlen, bytes c2_val, uint c2_bitlen) {
        
        if((state == Protocol_State.Collecting_Answers) || (current_worker_num < num_workers)){
            var answeri = answers_map[current_worker_num];
            
            answeri.c1.val = c1_val;
            answeri.c1.neg = false;
            answeri.c1.bitlen = c1_bitlen;
            
            answeri.c2.val = c2_val;
            answeri.c2.neg = false;
            answeri.c2.bitlen = c2_bitlen;
            
            workers_accts.push(current_worker_num) -1;
            current_worker_num = current_worker_num + 1;
            
            emit Answers_Test("Answer submitted!");
        
            if(current_worker_num == num_workers){
                state = Protocol_State.Collected;
                emit Answers_Test("Last Answer submitted! Collection Phase Over!");
            }
        }
        else{
            emit Answers_Test("Collection Phase Over! Answers cannot be submitted in Collected Phase!");
        }
    }
    
    function verify_zero_and_one_proof(uint index1, uint index2, bytes a_val, uint a_bitlen, bytes z_val, uint z_bitlen, uint hash_length) returns (bool){
        BigNumber.instance memory lhs;
        (lhs.val, lhs.bitlen) = zero_and_one_lhs(index1, index2, a_val, z_val, z_bitlen, hash_length);
        
        lhs.neg = false;
        
        BigNumber.instance memory rhs_r;
        (rhs_r.val, rhs_r.bitlen) = zero_and_one_rhs(index1, index2, a_val, z_val, z_bitlen, hash_length);
        
        rhs_r.neg = false;
        
        BigNumber.instance memory a;
        a.val = a_val;
        a.neg = false;
        a.bitlen = a_bitlen;
        
        BigNumber.instance memory rhs = a.modmul(rhs_r,p);
        
        if(BigNumber.cmp(lhs, rhs, true)==0){
            emit Zero_And_One("0 and 1 Proof Accepted! Plaintexts are Zero and One!");
            return true;
        }
        emit Zero_And_One("0 and 1 Proof Rejected! Plaintexts are Not Zero and One!");
        return false;
    }
    
    function zero_and_one_lhs(uint index1, uint index2, bytes a_val, bytes z_val, uint z_bitlen, uint hash_length) returns (bytes, uint){
    
        BigNumber.instance memory c;
        BigNumber.instance memory z;
        
        c.val = toBytes(sha3(a_val, g_val, h_val));
        c.neg = false;
        c.bitlen = hash_length;
        
        BigNumber.instance memory ca1;
        BigNumber.instance memory cb1;
        
        
        z.val = z_val;
        z. neg = false;
        z.bitlen = z_bitlen;
        
        ca1.val = answers_map[index1].c1.val;
        ca1.neg = false;
        ca1.bitlen = answers_map[index1].c1.bitlen;
        
        cb1.val = answers_map[index2].c1.val;
        cb1.neg = false;
        cb1.bitlen = answers_map[index2].c1.bitlen;
        
        BigNumber.instance memory lhs = (g.prepare_modexp(c,p)).modmul((ca1.modmul(cb1,p)).prepare_modexp(z,p), p);
        return (lhs.val, lhs.bitlen);
        
    }
    
    function zero_and_one_rhs(uint index1, uint index2, bytes a_val, bytes z_val, uint z_bitlen, uint hash_length) returns (bytes, uint){
    
        BigNumber.instance memory c;
        BigNumber.instance memory z;
        
        c.val = toBytes(sha3(a_val, g_val, h_val));
        c.neg = false;
        c.bitlen = hash_length;
        
        BigNumber.instance memory ca2;
        BigNumber.instance memory cb2;
        
        
        z.val = z_val;
        z. neg = false;
        z.bitlen = z_bitlen;
        
        ca2.val = answers_map[index1].c2.val;
        ca2.neg = false;
        ca2.bitlen = answers_map[index1].c2.bitlen;
        
        cb2.val = answers_map[index2].c2.val;
        cb2.neg = false;
        cb2.bitlen = answers_map[index2].c2.bitlen;
        
        BigNumber.instance memory rhs = ((ca2.modmul(cb2,p)).prepare_modexp(c,p));
        return (rhs.val, rhs.bitlen);
        
    }
    
    
    function verify_out_of_range_proof(uint index, bytes a_val, uint a_bitlen, bytes z_val, uint z_bitlen, bytes m_val, uint m_bitlen, uint hash_length) returns (bool){
        
        BigNumber.instance memory lhs;
        (lhs.val, lhs.bitlen) = compute_range_proof_lhs(index, a_val, z_val, z_bitlen, m_val, m_bitlen, hash_length);
        
        lhs.neg = false;
        
        BigNumber.instance memory rhs;
        (rhs.val, rhs.bitlen) = compute_range_proof_rhs(index, a_val, a_bitlen, z_val, z_bitlen, hash_length);
        
        rhs.neg = false;
        
        BigNumber.instance memory m;
        
        m.val = m_val;
        m.neg = false;
        m.bitlen = m_bitlen;
        
        if((BigNumber.cmp(lhs, rhs, true) == 0) && (BigNumber.cmp(m, g, true) != 0) && (BigNumber.cmp(m, one, true) != 0)){
        
            emit Out_Of_Range("Plaintext is out of range!");
            return true;
        }
        emit Out_Of_Range("Plaintext is within range!");
        return false;
        
    }
    
    
    function compute_range_proof_lhs(uint index, bytes a_val, bytes z_val, uint z_bitlen, bytes m_val, uint m_bitlen, uint hash_length) returns (bytes, uint){
        BigNumber.instance memory c;
        BigNumber.instance memory c1;
        
        BigNumber.instance memory m;
        BigNumber.instance memory z;
        
        c.val = toBytes(sha3(a_val, g_val, h_val));
        c.neg = false;
        c.bitlen = hash_length;
        
        m.val = m_val;
        m.neg = false;
        m.bitlen = m_bitlen;
        
        z.val = z_val;
        z. neg = false;
        z.bitlen = z_bitlen;
        
        c1.val = answers_map[index].c1.val;
        c1.neg = false;
        c1.bitlen = answers_map[index].c1.bitlen;
        
        BigNumber.instance memory lhs = (m.prepare_modexp(c,p)).modmul(c1.prepare_modexp(z,p),p);
    
        return (lhs.val, lhs.bitlen);
    }
    
    function compute_range_proof_rhs(uint index, bytes a_val, uint a_bitlen, bytes z_val, uint z_bitlen, uint hash_length) returns (bytes, uint){
    
        BigNumber.instance memory c2;
        BigNumber.instance memory c;
        BigNumber.instance memory a;
        
        c2.val = answers_map[index].c2.val;
        c2.neg = false;
        c2.bitlen = answers_map[index].c2.bitlen;
        
        c.val = toBytes(sha3(a_val, g_val, h_val));
        c.neg = false;
        c.bitlen = hash_length;
        
        a.val = a_val;
        a.neg = false;
        a.bitlen = a_bitlen;
        
        BigNumber.instance memory rhs = a.modmul(c2.prepare_modexp(c,p),p); 
        return (rhs.val, rhs.bitlen);
    }
    
    function verify_same_plaintext_proof(uint index1, uint index2, bytes a_val, uint a_bitlen, bytes z_val, uint z_bitlen, uint hash_length) returns (bool){
    
        BigNumber.instance memory a;
        a.val = a_val;
        a.neg = false;
        a.bitlen = a_bitlen;
        
        BigNumber.instance memory lhs; 
        (lhs.val, lhs. bitlen) = compute_plaintext_proof_lhs(index1, index2, a_val, a_bitlen, z_val, z_bitlen, hash_length);
        
        lhs.neg = false;
        
        BigNumber.instance memory rhs_r; 
        (rhs_r.val, rhs_r. bitlen) = compute_plaintext_proof_rhs(index1, index2, a_val, a_bitlen, z_val, z_bitlen, hash_length);
    
        rhs.neg = false;
        
        BigNumber.instance memory rhs = a.modmul(rhs_r, p);
        
        if(BigNumber.cmp(lhs, rhs, true) == 0){
            emit Same_PlainText("Same Plaintext Proof Accepted! Plaintexts are same!");
            return true;
        }
        emit Same_PlainText("Same Plaintext Proof Rejected! Plaintexts are different!");
        return false;
    }
    
    function compute_plaintext_proof_lhs(uint index1, uint index2, bytes a_val, uint a_bitlen, bytes z_val, uint z_bitlen, uint hash_length) returns (bytes, uint){
        
        BigNumber.instance memory ca1;
        BigNumber.instance memory cb2;
        
        BigNumber.instance memory z;
        BigNumber.instance memory c;
        
        c.val = toBytes(sha3(a_val, g_val, h_val));
        c.neg = false;
        c.bitlen = hash_length;
        
        ca1.val = answers_map[index1].c1.val;
        ca1.neg = false;
        ca1.bitlen = answers_map[index1].c1.bitlen;
        
        cb2.val = answers_map[index2].c2.val;
        cb2.neg = false;
        cb2.bitlen = answers_map[index2].c2.bitlen;
        
        z.val = z_val;
        z. neg = false;
        z.bitlen = z_bitlen;
        
        BigNumber.instance memory lhs = (cb2.prepare_modexp(c,p)).modmul(ca1.prepare_modexp(z,p),p);
       
        return (lhs.val, lhs.bitlen);
    }
    
    function compute_plaintext_proof_rhs(uint index1, uint index2, bytes a_val, uint a_bitlen, bytes z_val, uint z_bitlen, uint hash_length) returns (bytes, uint){
        
        BigNumber.instance memory ca2;
        BigNumber.instance memory cb1;
    
        ca2.val = answers_map[index1].c2.val;
        ca2.neg = false;
        ca2.bitlen = answers_map[index1].c2.bitlen;
        
        cb1.val = answers_map[index2].c1.val;
        cb1.neg = false;
        cb1.bitlen = answers_map[index2].c1.bitlen;
        
        BigNumber.instance memory z;
        BigNumber.instance memory c;
        
        c.val = toBytes(sha3(a_val, g_val, h_val));
        c.neg = false;
        c.bitlen = hash_length;
        
        z.val = z_val;
        z. neg = false;
        z.bitlen = z_bitlen;
        
        
        BigNumber.instance memory rhs = (ca2.prepare_modexp(c,p)).modmul(cb1.prepare_modexp(z,p),p);
        return (rhs.val, rhs.bitlen);
    }
    
    function toBytes(bytes32 _data) public pure returns (bytes) {
        return abi.encodePacked(_data);
    }
    
}