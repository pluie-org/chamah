using GLib;
using Gee;
using Pluie;

class Pluie.Crypt.Movment : Object
{
    protected uint8    generator;
    protected uint8[]  movment_def;
    protected uint8[]  combination;
    protected int      index;
    Crypt.Permutation  movment;
    
    public Movment (uint8 generator, int[] definition)
    {
        this.index       = 0;
        this.movment_def = Movment.read_definition (definition);
        this.generator   = generator;        
        this.movment     = new Crypt.Permutation (this.movment_def);
    }
    
    private static uint8[] read_definition (int[] definition)
    {
        bool has_null = false;
        uint8[] def   = new uint8[definition.length];
        for (var i = 0; i < definition.length; i++) {
            if (!has_null && (has_null = definition[i] == 0)) {
                i = 0;
            }
            def[i] = (uint8) definition[i] + (has_null ? 1 : 0);
        }
        return def;
    }

    public int move ()
    {
        if (this.index % this.movment_def.length == 0) {
            this.index = 0;
            int movment_combination = (int) Pluie.random.range (1, this.movment.count(), this.generator);
//~             stdout.printf ("movment_combination : %d\n", movment_combination);
            this.combination = this.movment.combination (movment_combination);
        }
        int move = (int) this.combination[this.index++];
        for(var j = 0; j < this.movment_def.length; j++) {
//~             stdout.printf ("0x%02x ", this.combination[j]);
        }
//~         stdout.printf ("\nmovment index %d - next movment : %d\n", this.index-1, move);
        return move;
    }
}
