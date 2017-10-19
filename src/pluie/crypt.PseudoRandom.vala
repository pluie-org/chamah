using GLib;

class Pluie.Crypt.PseudoRandom : Object
{
    uint32  seed;
    int     index;
    int8    round = 7;

    public PseudoRandom (uint32 seed)
    {
        this.seed = seed;
        
    }

    private void swap (uint *a, uint *b)
    {
        uint temp = *a;
        *a = *b;
        *b = temp;
    }

    private void randomiz (ref uint[] arr, int no, uint8 generator)
    {
        for (int i = arr.length-1; i >= 0; i--) {
            // Pick a random index from 0 to i
            int j = (int) this.random (generator) % (i+1);
            // Swap arr[i] with the element at random index
            this.swap (&arr[i], &arr[j]);
        }
    }

    public uint range (int min, int max, uint8 generator)
    {
        var arr = new uint[max-min+1];
        for (int i = 0; i < max-min; i++) {
            arr[i] = min+i;
        }
        arr.resize (max-min+1);
        this.randomiz (ref arr, max-min+1, generator);
        if (this.index > arr.length) {
            this.index = 0;
        }
        return arr[this.index++];
    }

    private uint random (uint8 generator)
    {
        uint   badseed = seed + generator;
        uint   a       = (int) (badseed < 22 ? badseed ^ 0x80 : badseed) + 7;
        string v;
        int    i;
        for (var c = 0; c < this.round; c++) {
            v = "%d".printf ((int) Math.pow ((a), 2));
            i = v.length > 9 ? 3 : (v.length > 6 ? 2 : 1);
            a += (uint) int.parse (v[i:-i]) + 1 + c;
        }
        return a;
    }
}
