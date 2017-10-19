using GLib;
using Gee;
using Pluie;

class Pluie.Crypt.MatrixBytes : Object
{
    public Io.Bytes bytes { get; private set; }
    public int size       { get; private set; }

    public MatrixBytes (int size)
    {
        this.size  = size;
        this.bytes = new Io.Bytes ((int) Math.pow (size, 2));
    }

    public bool add (uint8 byte)
    {
        return this.bytes.add (byte);
    }

    public new bool set (int col, int row, uint8 byte)
    {
        return this.bytes.set ((this.size*col)+row, byte);
    }

    public new uint8 get (int col, int row)
    {
        this.check_range (col);
        this.check_range (row);
        return this.bytes.get ((this.size*col)+row);
    }

    public uint8[] get_col (int n)
    {
        this.check_range (n);
        return this.bytes.get_range (this.size*n, this.size);
    }

    public uint8[] get_row (int n)
    {
        this.check_range (n);
        uint8[] row = new uint8[this.size];
        for (var i = 0; i < this.size; i++) {
            row[i] = this.bytes.get ((i*this.size)+n);
        }
        return row; 
    }

    public int[] coord (uint8 byte)
    {
        int[] c = new int[2];
        int i   = this.bytes.index (byte);
        if (i >= 0) {
            c[0] = (int) Math.floor (i/this.size);
            c[1] = i % this.size;
        }
        return c;
    }

    public bool contains (uint8 byte)
    {
        return this.bytes.contains (byte);
    }

    private void check_range (int n)
    {
        check_int_range (n, 0, this.size-1);
    }
}
