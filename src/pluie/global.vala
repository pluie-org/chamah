using Pluie;

namespace Pluie {

    Crypt.PseudoRandom random;

    public void init ()
    {
        random = new Pluie.Crypt.PseudoRandom (0x4f1b6a57);
    }

    public errordomain RangeError
    {
        OUT_OF_BOUND
    }

    public void range_thrower (int d, int min, int max, string msg) throws RangeError
    {
        throw new RangeError.OUT_OF_BOUND ("RangeError "+msg+" : %d must be set between %d and %d".printf (d, min, max));
    }

    public void check_int_range (int v, int min, int max, string msg = "invalid int value")
    {
        if (!(v >= min && v <= max)) {
            message (msg+@" : $v");
            range_thrower (v, min, max, msg);
        }
    }
    
}
