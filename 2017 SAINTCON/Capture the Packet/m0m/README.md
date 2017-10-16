# DESCRIPTION: #
Goal: Discover the key.

Your mom got educated @ The Labs in SDR.  It's a shame your Leet hackerself can't do the same as the SDR lab doesn't exist.  Maybe you can commandeer some of the equipment your mom loved.  Find something interesting.


Gamemaster Note:
Make sure that equipment doesn't go missing.  Be courteous to the Labs folks.

## Hint ##
Ask TheVoid or BashNinja for a frequency range.



# WALKTHROUGH: #
Unfortunately, this is one of the challenges that you can't solve at home, since you must be near the transmitter which isn't running anymore.

The only equipment needed for this challenge is an SDR (Software Defined Radio). I used one of the $20 DVB-T TV Tuners which uses the RTL2832U chipset.

The software I used is called gqrx. It works on Linux and MacOS. I used the MacOS version. NOTE: I was not able to get it to work with version 2.5. Version 2.6 worked fine.

Once you've got the software running with your SDR, you need to figure out which frequency you're looking for. There are hints in the description, as well as the hint to ask someone for the frequency range. The range was 100-200 MHz. The hint in the description is about being leet. The frequency you're looking for is 133.7 MHz. 

Now that you know where to look, you need to fiddle with the settings until you can see the key. It will show up as an image in the waterfall display. The settings to change are Pandapter, Pand. dB, and Wf. dB. It took a lot of fiddling to get a somewhat usable image.

There was a problem with the transmitting hardware during the con, so getting the image was very difficult. The original image was a QR code, however the image wasn't usable, so the image was changed to just display the key.

The key was: ur m0m w3n7 70 coll3ge
