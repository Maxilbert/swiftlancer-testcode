from Crypto.Random import get_random_bytes
from ethereum.utils import (
    int_to_bytes, sha3
)

'''

inv (c, p) = pow(c1, p-2, p)

'''

def egcd(a, b):
    if a == 0:
        return (b, 0, 1)
    g, y, x = egcd(b%a,a)
    return (g, x - (b//a) * y, y)

def modinv(a, m):
    g, x, y = egcd(a, m)
    if g != 1:
        raise Exception('No modular inverse')
    return x%m

def minv(m, p):
    return pow(m, p-2, p)


def enc(m, r):
    c_1 = pow(g, r, p)
    c_2 = pow(h, r, p) * pow(g, m, p) % p
    return c_1, c_2


if __name__ == '__main__':


    p = 153098272504387072266936256155440771844922582242861823323292219309209807318109992190455717597749270325963123403359939192028947724926144342818770586136136126337375436706876614423863264051678326206739626203872223116203206738831155125839612432933059096643057013804321361170650382385182136069811475540151279147259
    g = 48095861804730928538428071688224004229592704416264787635743716356958582448226167154685924895443220005707859651277553435409220536317215422963672871914841517783042349761227906722244783116777179995820326154186287286353935949308174273056377987690394866714089833749644657555907806410435558837920979345110898160449
    k = 10022446701738583271276071804010446073913280425189472942303437612418862851223244723245226017322005926246813100742541609377103046893136104044015161562561526985453585647020566093167977121428923628169372925889701872928538625011078052920813557913682354018653924330859466163743103828247525446549945542160664745508


    h = pow(g, k, p)

    r = 62555713279948745690349351610356531327032351353192320967421937635293378693946211592624820108119998277825391232074589514501649650827908709815124457628347900961038658650480217718807650468597580969342931489490635246791126151937259525476850522897096329798193623331012272552762850181502944812071200771862243846107




    m1 = 11
    m2 = 5

    rand_bytes = get_random_bytes(32)
    r1 = int.from_bytes(rand_bytes, byteorder='big')

    ca1, ca2 = enc(m1, r1)

    print("CA : ")
    print("ca1: ", ca1)
    print("ca2: ", ca2)

    rand_bytes = get_random_bytes(32)
    r2 = int.from_bytes(rand_bytes, byteorder='big')

    cb1, cb2 = enc(m2, r2)

    print("CB : ")
    print("cb1: ", cb1)
    print("cb2: ", cb2)

    rand_bytes = get_random_bytes(32)
    r = int.from_bytes(rand_bytes, byteorder='big')

    A = (ca1 * cb1) % p

    print("A: ", A)

    B = (ca2 * cb2) % p

    print("B: ", B)

    a = pow(A, r, p)

    print("a: ", a)

    c_val = sha3(int_to_bytes(a) + int_to_bytes(g) + int_to_bytes(h))

    c = int.from_bytes(c_val, byteorder='big')

    print("c: ", c)

    z = r + c * k

    print("z: ", z)

    lhs = (pow(g, c, p) * pow(A, z, p)) % p

    rhs = (a * pow(B, c, p)) % p

    print("lhs: ", lhs)
    print("rhs: ", rhs)

    if(lhs==rhs):
        print("True")
    else:
        print("False")