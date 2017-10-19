using GLib;
using Gee;
using Pluie;

class Pluie.Crypt.Chamah : Object
{
    protected bool                DEBUG = true;
    protected Io.InputChunkStream ics;
    protected uint8               chunk_size = 12;
    protected uint8[]             key;
    protected uint8[]             mask;
    protected Crypt.Sbox[]        allbox;

    public Chamah (string? path = null)
    {
        if (path != null) {
            this.ics = new Io.InputChunkStream (path, this.chunk_size);
        }
        this.init ();
    }

    public void init ()
    {
        this.key    = { 0xe5, 0x03, 0x07, 0xc3, 0x9f, 0xd2, 0xfe, 0x00, 0xa5, 0x4b, 0xc7, 0x28, 0xb4, 0x63, 0x12, 0x99 };
        this.mask   = { 0xc7, 0x4e, 0xd4, 0x00, 0xa0, 0x1d, 0x6a, 0xb1, 0x55, 0x3e, 0xa5, 0xf0, 0x06, 0xd7, 0xe3, 0x5b };
        this.allbox = new Crypt.Sbox[this.key.length];
        for (var i = 0; i < this.key.length; i++) {
            this.allbox[i] = new Crypt.Sbox (this.key[i], this.mask[i]);
            if (DEBUG) this.allbox[i].display_sbox();
        }
    }

    public int8[] round_byte_def (int8 round)
    {
        int8[] def   = new int8[this.chunk_size];
        for (var i = 0; i < 4; i++) {
            def[(round + i + (round % 2 != 0 ? 3 : 0)) % this.chunk_size] = 1;
        }
        return def;
    }

    public uint8[] encode ()
    {
        uint8[] udata = new uint8[0]; 
        int      size = 0;
        if (this.ics != null) {
            int chunk_num = 0;
            while (this.ics.read () != null) {
                udata.resize ((int) udata.length + ics.get_buffer_size ());
                for (var i = 0; i < this.ics.get_buffer_size (); i++) {
                    udata[size++] = this.cypher (ref i, chunk_num);
                }
                chunk_num++;
            }
        }
//~         udata += (uint8) '\0';
        udata.resize (size);
        stdout.printf ("\nlen %i - data :\n%s\n", udata.length, (string) udata);
        return udata;
    }

    private uint8 cypher (ref int i, int chunk_num)
    {
        uint8 byte = this.ics.get_buffer ()[i];
        int   k;
        if (DEBUG) stdout.printf("== %02x ===============\n", byte);
        for (var round = 0; round < this.chunk_size; round++) {
            k    = i % 2 == 0 ? round : this.key.length-1-round;
            byte = this.allbox[k].substitute (byte);
            if (DEBUG) stdout.printf ("r : %02d - i : %02d - l : %02d - k : %02d - b : %02x", round, i, chunk_num, k, byte);
            if (this.round_byte_def (round)[i] == 1) {
                k    = (round % 2 == 0 ? this.key.length - round + chunk_num : round + chunk_num ) % this.key.length;
                byte = this.allbox[k].substitute (byte);
                if (DEBUG) stdout.printf (" - k : %02d - b : %02x", k, byte);
            }
            if (DEBUG) stdout.printf ("\n");
        }
        return byte;
    }

    public string decode (string path)
    {
        this.ics = new Io.InputChunkStream (path, this.chunk_size);
        uint8[] udata = new uint8[0]; 
        int      size = 0;
        if (this.ics != null) {
            int chunk_num = 0;
            while (this.ics.read () != null) {
                udata.resize((int) udata.length + ics.get_buffer_size());
                for (var i = 0; i < this.ics.get_buffer_size (); i++) {
                    udata[size++] = this.decypher (ref i, chunk_num);
                }
                chunk_num++;
            }
        }
        udata += (uint8) '\0';
        udata.resize (size);
        stdout.printf ("\nlen %i - data :\n%s\n", udata.length, (string) udata);
        return (string) udata;
    }

    private uint8 decypher (ref int i, int chunk_num)
    {
        uint8 byte = this.ics.get_buffer ()[i];
        int   k;
        for (var round = this.chunk_size-1; round >= 0; round--) {
            if (this.round_byte_def (round)[i] == 1) {
                k    = (round % 2 == 0 ? this.key.length - round + chunk_num : round + chunk_num ) % this.key.length;
                byte = this.allbox[k].substitute (byte, false);
            }
            k    = i % 2 == 0 ? round : this.key.length-1-round;            
            byte = this.allbox[k].substitute (byte, false);
        }
        return byte;
    }

}
