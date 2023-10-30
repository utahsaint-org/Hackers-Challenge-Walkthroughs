# Minibadge challenge (p2)


once decoded, you find a zip archive that has additional archives inside of it, of different formats. when you reach the bottom of the nest, you end up with a file containing the flag. the archive formats could be identified using the file command on linux and then extracted accordingly. or, an even quicker option that nopesled demonstrated is extracting using binwalk -e -M