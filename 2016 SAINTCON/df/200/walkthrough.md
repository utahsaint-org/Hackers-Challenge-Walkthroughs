1. Open the image.img with photorec, extract all the files it can find.
2. Extract until you find a .gif file:
    ~~~~
    gzip -d f0000853_file.09.gz
    mv f0000853_file.09 extract.gz ;gzip -d extract.gz
    unzip extract
    tar -xvf fun.tar.gz
    cd thisisfun/
    mv xju9oue2 xju9oue2.gz ; gzip -d xju9oue2.gz
    ~~~~

3. Extract each frame of the gif: 
    `convert xju9oue2 frame.png`

4. Run each frame through a decoder to get it's QRCode text. 
    zbarimg can't read the small image sizes, so you need to make them larger. 

5. Write it all out to a file:
    `for i in {0..67}; do convert frame-$i.png -scale 300% :- | zbarimg --raw -q :- >> out.base64; done`

5. Decode the base64 to a file:
    `base64 -d out.base64 > finished.png`

6. Get the flag:  
    View the .png
