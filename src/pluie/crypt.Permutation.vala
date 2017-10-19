using GLib;

class Pluie.Crypt.Permutation : Object
{
    private string[] all;
    private uint8[]  items;

    public Permutation (uint8[] items)
    {
        this.items = items;
        this.all   = new string[0];
        permute (ref this.items, this.items.length);
    }

    public int count ()
    {
        return this.all.length;
    }

    public uint8[] combination (int index)
    {
        check_int_range (index, 0, this.count ()-1, "invalid combination int value");
        uint8[] combination = this.all[index].data;
        combination.resize (this.items.length);
        return combination;
    }

    public void print ()
    {
        stdout.printf ("\nPermutation : ");
        for (var i = 0; i < this.items.length; i++) {
            stdout.printf ("0x%02x ", this.items[i]);
        }
        stdout.printf ("'\n%i combinations\n\n", this.count ());
        for(var i =0; i < this.count (); i++) {
            stdout.printf ("%d : ", i+1);
            for (var j = 0; j < this.items.length; j++) {
                stdout.printf ("0x%02x ", all[i].data[j]);
            }
            stdout.printf ("\n");
        }
    }
    
    private static void swap (ref uint8[] data, int right, int left)
    {
        uint8 tmp   = data[right];
        data[right] = data[left];
        data[left]  = tmp;
    }

    private void permute (ref uint8[] data, int pos)
    {
        if (pos == 1) {
            this.all += ((string) data);
        }
        else {
            for (int i = 0; i < pos; i++) {
                permute (ref data, pos - 1);
                swap (ref data, pos % 2 == 1 ? 0 : i, pos - 1);
            }
        }
    }
}
