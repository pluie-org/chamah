using GLib;

class Pluie.Io.InputChunkStream : Object
{
    protected ulong      chunk_index;
    protected uint8      chunk_size;
    protected uint8      buffer_size;
    protected uint8[]    buffer;
    protected FileStream fs;
  
    public InputChunkStream (string path, uint8 chunk_size)
    {
        this.chunk_size  = chunk_size;
        this.buffer      = new uint8[this.chunk_size];
        this.fs          = FileStream.open (path, "r");
        this.chunk_index = 0;
    }

    public bool eof ()
    {
        bool stop = this.fs.eof ();
        if (stop) {
            this.buffer = null;
        }
        return stop;
    }

    public unowned uint8[] read ()
    {
        if (!this.eof ()) {
            this.buffer_size = (uint8) this.fs.read (this.buffer);
            this.chunk_index++;
        }
        return this.buffer;
    }

    public unowned uint8 get_buffer_size ()
    {
        return this.buffer_size;
    }

    public unowned uint8[] get_buffer ()
    {
        return this.buffer;
    }

    public ulong get_chunk_index ()
    {
        return this.chunk_index-1;
    }

    public uint8 get_chunk_size ()
    {
        return this.chunk_size;
    }
}
