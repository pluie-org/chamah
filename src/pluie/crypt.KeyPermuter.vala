using GLib;
using Gee;
using Pluie;

class Pluie.Crypt.KeyPermuter : Object
{
    protected uint8         generator;
    protected Crypt.Movment mvt_index;
    protected Crypt.Movment mvt_rotation;
    
    public KeyPermuter (uint8 generator)
    {
        this.generator    = generator;        
        this.mvt_rotation = new Crypt.Movment (generator, Pluie.Crypt.Sbox.DEF_ROT_ORDER);
        this.mvt_index    = new Crypt.Movment (generator, Pluie.Crypt.Sbox.DEF_INDEX_ORDER);
    }
    
    public int next_rotation ()
    {
        return this.mvt_rotation.move ();
    }

    public int next_index ()
    {
        return this.mvt_index.move ();
    }
}
