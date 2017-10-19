using GLib;
using Gee;
using Pluie;

class Pluie.Crypt.Sbox : Object
{   
    public    static int[]           DEF_ROT_ORDER    = { 
        bin.BOX_MODE_LROT, bin.BOX_MODE_ILROT, bin.BOX_MODE_RLROT, bin.BOX_MODE_RILROT 
    };
    public    static int[]           DEF_INDEX_ORDER  = {1,3,5,6,7};
    protected static string          SEP              = "----------------------------------------------------------------------------------";

    protected      Crypt.KeyPermuter key_permuter;
    public         Crypt.MatrixBytes sbox_data     { get; private set; }
    public unowned uint8             generator     { get; private set; }
    public unowned uint8             mask          { get; set; }

    public Sbox (uint8 generator, uint8 mask)
    {
        this.generator    = generator;
        this.mask         = mask;
        this.key_permuter = new Crypt.KeyPermuter (this.generator);
        this.sbox_data    = new Crypt.MatrixBytes (16);
        this.generate ();
    }

    public void generate ()
    {
        uint8    v;
        int      pos;
        int      mode;
        uint8    gen = this.generator;
        uint8[]  box;
        uint8    kmask = this.mask;
        for (var r = 0; r < 32; r++) {
            pos  = this.key_permuter.next_index ();
            mode = this.key_permuter.next_rotation ();
            box  = bin.smbox (gen, mode, pos);
            for (var i = 0; i < box.length; i++) {
                v  = box[i] == kmask ? box[i] ^ gen: box[i] ^ kmask;
                this.gen_byte (ref v, ref gen, ref box, i, mode, pos);
                this.sbox_data.add (v);
            }
        }
    }

    private uint8 gen_byte (ref uint8 v, ref uint8 gen, ref uint8[] box, int i, int mode, int pos)
    {        
        uint8 c           = 0;
        int   max_attempt = 70;
        int   size        = (int) Math.pow (this.sbox_data.size, 2);
        while (true) {
            if (this.sbox_data.contains (v)) {
                if (c > max_attempt && c < size + max_attempt) {
                    if (c > size) c -= (uint8) size-1;
                    v = c++ ^ gen;
                }
                else {
                    gen  = box[i] + c++;
                    box  = bin.smbox (gen, mode, pos);
                    v    = box[i] + c;
                }
            }
            else break;
        }
        return v;
    }

    public uint8? substitute (uint8 byte, bool hide=true)
    {
        uint8 sbyte;
        int[] coord;
        if (hide) {
            coord = this.sbox_data.coord (byte);
            sbyte = coord.length == 2 ? (uint8) coord[1]*16 + coord[0] : byte;
        }
        else {
            coord = bin.byte_coord (ref byte);
            sbyte = this.get_box_data (coord[1], coord[0]);
        }
        return sbyte;
    }

    private uint8 move_index (int[] a, uint8 pos)
    {
        return pos > a.length-2 ? 0 : pos + 1;
    }

    public uint8 get_box_data (int col, int row)
    {
        return this.sbox_data.get (col, row);
    }

    public void display_sbox ()
    {
        stdout.printf ("\n    %.*s\n", 82, Sbox.SEP);
        stdout.printf ("    |");
        for (var col = 0; col < 16; col++) {
            stdout.printf ("| %02x ", (uint8) col);
        }
        stdout.printf ("|\n    %.*s\n", 82, Sbox.SEP);
        for (var row = 0; row < 16; row++) {
            for (var col = 0; col < 16; col++) {
                if (col == 0) {
                    stdout.printf (" %02x |", (uint8) row);
                }
                stdout.printf ("| %02x ", this.get_box_data(col, row));
            }
            stdout.printf ("|\n");
        }
    }
}
