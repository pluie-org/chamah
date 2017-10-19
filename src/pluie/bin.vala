using GLib;

namespace Pluie.bin
{
    // left rotation
    const int BOX_MODE_LROT   = 0x01;
    // inverse left rotation
    const int BOX_MODE_ILROT  = 0x02;
    // reverse left rotation
    const int BOX_MODE_RLROT  = 0x04;
    // reverse inverse left rotation
    const int BOX_MODE_RILROT = 0x08;

    private void check_nbit (int v)
    {
//~         check_int_range (v, 1, 8, "invalid bit value");
    }

    public uint8 set (uint8 d, int bit=1)
    {
        check_nbit (bit);
        return d | (1 << --bit);
    }

    public uint8 unset (uint8 d, int bit=1)
    {
        check_nbit (bit);
        return d & ~(1 << --bit);
    }

    public bool isset (uint8 d, int bit=1)
    {
        check_nbit (bit);
        return (d & (0x01 << --bit)) != 0;
    }

    public int[] byte_coord (ref uint8 byte)
    {
        int[] coord = new int[2];
        coord[1] = ((int) byte) % 16;
        coord[0] = ((int) byte / 16) % 16;
        return coord;
    }

    public uint8 reverse (uint8 d)
    {
        uint8 r   = 0x00;
        int   lim = 9;
        for(var i = 1; i < lim; i++) 
            if (isset (d, i))
                r = bin.set (r, lim-i);
        return r;
    }

    public uint8 rrot (uint8 d, int nbit = 1)
    {
        check_nbit (nbit);
        uint8 k = (uint8) nbit;
        return ((d >> k) | (d << (8-k))) & ((1 << 8)-1);
    }

    public uint8 lrot (uint8 d, int nbit = 1)
    {
        check_nbit (nbit);
        uint8 k = (uint8) nbit;
        return ((d << k) | (d >> (8-k))) & ((1 << 8)-1);
    }

    public uint8 sbin_dec (string sbin)
    {
        uint8 v = 0;
        for (var i=0; i < sbin.length; i++) {
            v += ((uint8) int.parse (sbin[i].to_string ()))*((uint8) Math.pow (2, sbin.length-1-i));
        }
        return v;
    }

    public string dec_sbin (uint8 n, int bit=8)
    {
        string d = "";
        _dec_sbin (n, ref d);
        return (@"%0$bit"+"d").printf (int.parse (d));
    }

    private void _dec_sbin (uint8 n, ref string s)
    {
        if (n >= 1) _dec_sbin (n/2, ref s);
        s += "%u".printf (n%2);
    }

    public string dec_str (uint8 n)
    {
        uint8[] f = {n};
        f += (uint8) '\0';
        return (string) f;
    }

    public uint8[] mask (uint8[] raw, string mask)
    {
        uint8[] masked   = new uint8[raw.length];
        for (var i = 0; i < raw.length; i++) {
            masked[i] = (uint8) (raw[i] ^ mask.data[i%mask.data.length]);
        }
        return masked;
    }

    public uint8[] smbox (uint8 generator, int mode, int start=0)
    {
        uint8[] box = new uint8[8];
        switch (mode) {
            case BOX_MODE_LROT  :
                box[start] = generator;
                break;
            case BOX_MODE_ILROT :
                box[start] = ~generator;
                break;
            case BOX_MODE_RLROT :
                box[start] = reverse (generator);
                break;
            case BOX_MODE_RILROT :
                box[start] = ~reverse (generator);
                break;
        }
        int j = start;
        for (var i = 1; i < 8; i++) {
            if (++j > 7) j = 0;
            box[j] = lrot (box[start], 1);
            start  = j;
        }
        return box;
    }
}
