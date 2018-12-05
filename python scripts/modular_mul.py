from ethereum.utils import (
    int_to_bytes, sha3
)

def count_bitlen(x):
    x_str = str(hex(x)).replace('0x', '')
    charlen = len(x_str)
    bitlen = charlen * 4
    if x_str[0] in ['1']:
        bitlen -= 3
    elif x_str[0] in ['2', '3']:
        bitlen -= 2
    elif x_str[0] in ['4', '5', '6', '7']:
        bitlen -= 1
    return bitlen

def modulo_multiplicative_inverse(A, M):
    """
    Assumes that A and M are co-prime
    Returns multiplicative modulo inverse of A under M
    """
    # Find gcd using Extended Euclid's Algorithm
    gcd, x, y = extended_euclid_gcd(A, M)

    # In case x is negative, we handle it by adding extra M
    # Because we know that multiplicative inverse of A in range M lies
    # in the range [0, M-1]
    if x < 0:
        x += M

    return x

def extended_euclid_gcd(a, b):
    """
    Returns a list `result` of size 3 where:
    Referring to the equation ax + by = gcd(a, b)
        result[0] is gcd(a, b)
        result[1] is x
        result[2] is y
    """
    s = 0; old_s = 1
    t = 1; old_t = 0
    r = b; old_r = a

    while r != 0:
        quotient = old_r/r
        # This is a pythonic way to swap numbers
        # See the same part in C++ implementation below to know more
        old_r, r = r, old_r - quotient*r
        old_s, s = s, old_s - quotient*s
        old_t, t = t, old_t - quotient*t
    return [old_r, old_s, old_t]


if __name__ == '__main__':


    p = 153098272504387072266936256155440771844922582242861823323292219309209807318109992190455717597749270325963123403359939192028947724926144342818770586136136126337375436706876614423863264051678326206739626203872223116203206738831155125839612432933059096643057013804321361170650382385182136069811475540151279147259
    g = 48095861804730928538428071688224004229592704416264787635743716356958582448226167154685924895443220005707859651277553435409220536317215422963672871914841517783042349761227906722244783116777179995820326154186287286353935949308174273056377987690394866714089833749644657555907806410435558837920979345110898160449
    k = 10022446701738583271276071804010446073913280425189472942303437612418862851223244723245226017322005926246813100742541609377103046893136104044015161562561526985453585647020566093167977121428923628169372925889701872928538625011078052920813557913682354018653924330859466163743103828247525446549945542160664745508


    h = pow(g, k, p)

    r = 62555713279948745690349351610356531327032351353192320967421937635293378693946211592624820108119998277825391232074589514501649650827908709815124457628347900961038658650480217718807650468597580969342931489490635246791126151937259525476850522897096329798193623331012272552762850181502944812071200771862243846107

    x = pow(g, r, p)
    print("x:", count_bitlen(x), ":", x)
    inv = modulo_multiplicative_inverse(x, p)
    print("inv:", count_bitlen(int(inv)), ":", inv)
    m = (h*inv)%p
    print("m:", count_bitlen(int(m)), ":", m)