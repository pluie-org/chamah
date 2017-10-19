using GLib;
using Pluie;

uint8 gmul (uint8 a, uint8 b) {
	uint8 p = 0;
	uint8 counter;
	uint8 hi_bit_set;
	for (counter = 0; counter < 8; counter++) {
		if ((b & 1) == 1) 
			p ^= a;
		hi_bit_set = (a & 0x80);
		a <<= 1;
		if (hi_bit_set == 0x80) 
			a ^= 0x1b;
		b >>= 1;
	}
	return p;
}

int main (string[] argv)
{
    Pluie.init ();
//~     Pluie.random = new Crypt.PseudoRandom (0x4f1b6a28);
    var path = "out.txt";
    uint8[] rawdata = new uint8[0];
    int siz = 0;
    uint8 CHUNK_SIZE = 12;
    stdout.printf ("\n== file : %s ==============\n", path);
    var ics  = new Io.InputChunkStream (path, CHUNK_SIZE);
    while (ics.read () != null) {
        stdout.printf ("%06lu [%02u:%02u]\t", ics.get_chunk_index (), ics.get_buffer_size (), ics.get_chunk_size ());
        for (var i = 0; i < ics.get_buffer_size (); i++) {
            rawdata += ics.get_buffer ()[i]; siz++;
            stdout.printf ("%02x ", ics.get_buffer ()[i]);
        }
        stdout.printf ("\n");
    }
    stdout.printf ("\n");
    rawdata += (uint8) '\0';
    rawdata.resize (siz);
    stdout.printf ("len %i - data :\n%s\n", rawdata.length, (string) rawdata);
    
//~     stdout.printf ("\nlength : %u\n", data.length);
    var chamah = new Crypt.Chamah (path);
    var data   = chamah.encode ();
    var file   = File.new_for_path ("out2.txt");
    // delete if file already exists
    if (file.query_exists ()) {
        file.delete ();
    }
    var dos      = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
    ulong written = 0;
    while (written < data.length) { 
        // sum of the bytes of 'text' that already have been written to the stream
        written += dos.write (data[written:data.length]);
        stdout.printf ("written %lu", written);
    }
    stdout.printf ("\n");
    path = "out2.txt";
    stdout.printf ("\n== file : %s ==============\n", path);
    ics  = new Io.InputChunkStream (path, CHUNK_SIZE);
    while(ics.read () != null) {
        stdout.printf ("%06lu [%02u:%02u]\t", ics.get_chunk_index (), ics.get_buffer_size (), ics.get_chunk_size ());
        for (var i = 0; i < ics.get_buffer_size (); i++) {
            stdout.printf ("%02x ", ics.get_buffer ()[i]);
        }
        stdout.printf ("\n");
    }
    stdout.printf ("\n");

    var mdata = chamah.decode (path);

    uint8[] skey    = { 0xe5, 0x03, 0x07, 0xc3, 0x9f, 0xd2, 0xfe, 0x00, 0xa5, 0x4b, 0xc7, 0x28, 0xb4, 0x63, 0x12, 0x99 };
    uint8[] smask   = { 0xc7, 0x4e, 0xd4, 0x00, 0xa0, 0x1d, 0x6a, 0xb1, 0x55, 0x3e, 0xa5, 0xf0, 0x06, 0xd7, 0xe3, 0x5b };

    string hb = Hmac.compute_for_data (ChecksumType.SHA256, skey, mdata.data);
    stdout.printf ("hmac-sha256 :\n%s\n", hb);

    Checksum checksum = new Checksum (ChecksumType.SHA256);
    checksum.update (mdata.data, (size_t) mdata.data.length);
    unowned string digest = checksum.get_string ();
    stdout.printf ("sha256 :\n%s\n", digest);

    return 0;
}
