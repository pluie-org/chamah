using GLib;
using Gee;
using Pluie;

class Pluie.Io.Bytes : Object
{
    public bool    duplicate { get; private set; default = true; }
    public int     size      { get; private set; }
    public int     len       { get; private set; default = 0; }
    public uint8[] data      { get; private set; }
    
    public Bytes (int size, bool duplicate = true)
    {
        this.duplicate = duplicate;
        this.size      = size;
        this.data      = new uint8[size];
        this.len       = 0;
    }

    public bool add (uint8 byte)
    {
        return this.set (this.len, byte);
    }

    public new uint8? get (int index)
    {
        if (this.check_index (index)) {
            return this.data[index];
        }
        else return null;
    }

    public int index (uint8 byte)
    {
        int index = -1;
        for (var i =0; i < this.len; i++) {
            if (this.data[i] == byte) {
                index = i;
                break;
            }
        }
        return index;
    }

    public uint8[] get_range (int index, int length)
    {
        bool done    = false;
        uint8[] list = {0};
        if (index < 0) {
            index = this.len - index.abs();
        }
        if (length != 0 && this.check_index (this.len - index - length.abs ())) {
            int s = length < 0 ? index+length : index;
            int e = length < 0 ? index : index+length;
            if ((done = !(s < 0 && s < e))) {
                list = (uint8[]) this.data[s:e];
                list.resize (length.abs());
            }
        }
        if (!done) {
            message ("Pluie.bin.RangeError.OUT_OF_BOUND in Pluie.Bytes.get_range(%d, %d) caller".printf (index, length));
        }
        return list;
    }

    public new bool set (int index, uint8 byte)
    {
        bool done = !this.full () && this.check_index (index) && (!this.duplicate || !this.contains (byte));
        if (done) {
            this.data[index] = byte;
            if (index >= this.len) {
                this.len = index+1;
            }
            done = true;
        }
        return done;
    }

    public bool full ()
    {
        return this.len == this.size;
    }

    protected bool check_index (int index, bool on_length = false)
    {
        int max = !on_length ? this.size : this.len;
        return index >= 0 && index < max;
    }

    public bool contains (uint8 byte)
    {
        return this.index (byte) > -1;
    }
}
