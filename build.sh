path=$(dirname "${BASH_SOURCE[0]}")
cd $path
valac -X -lm \
--pkg gee-0.8 \
--pkg glib-2.0 \
--pkg gio-2.0 \
Chamah.vala \
src/pluie/global.vala \
src/pluie/bin.vala \
src/pluie/crypt.Chamah.vala \
src/pluie/crypt.Sbox.vala \
src/pluie/crypt.MatrixBytes.vala \
src/pluie/crypt.Permutation.vala \
src/pluie/crypt.PseudoRandom.vala \
src/pluie/crypt.KeyPermuter.vala \
src/pluie/crypt.Movment.vala \
src/pluie/io.Bytes.vala \
src/pluie/io.InputChunkStream.vala \
-o chamah \
