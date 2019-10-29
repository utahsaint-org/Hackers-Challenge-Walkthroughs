1. Save the base64 to disk, maybe /tmp/base64.txt
2. Decode the base64 and save that result to disk:
    `$ base64 -d /tmp/base64.txt > /tmp/base64.bin`
3. Notice that the file type is a PNG
    `$ file /tmp/base64.bin`
    /tmp/base64.bin: PNG image data, 123 x 123, 1-bit colormap, non-interlaced
4. (Optional) Rename to a .png extension
5. Open the image in an image viewer, and notice it's a QR Code
6. Scan the QR code with a mobile device, or use an online decoder
