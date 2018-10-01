import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.crypto.Cipher;
import javax.crypto.CipherInputStream;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class LogicBomb {

	public static void doit(int x) throws IOException {
	    String encflag = "l1SZbTGrPhEyNBFqqoS6IV1qJhaOKY8M1/lcA+BPSdE=";

	    try
	    {
	      String iv = "IVIVIVIVIVIVIVIV";
	      IvParameterSpec ivParameterSpec = new IvParameterSpec(iv.getBytes(), 0, 16);
	      
//	      Date now = new Date();
//	      System.out.println(new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(now));
	      //String timeStamp = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(now);
	      //
	      //2018-07-04 11:13:12.000000000 -0600
	      //Date now = new Date(2018,);
	      
	      
	      String timeStamp = "2018.07.04" + String.format(".%02d",  x / 3600);
	      x = x % 3600;
	      timeStamp = timeStamp + String.format(".%02d",  x / 60);
	      x = x % 60;
	      timeStamp = timeStamp + String.format(".%02d",  x);
	      
	      //new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(now);
	      MessageDigest digest = MessageDigest.getInstance("SHA-256");
	      byte[] encodedKey = digest.digest(timeStamp.getBytes());
	      
	      javax.crypto.SecretKey aesKey = new SecretKeySpec(encodedKey, 0, encodedKey.length, "AES");
	      
	      byte[] encryptedBytes = java.util.Base64.getDecoder().decode(encflag);
	      

	      Cipher decryptCipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
	      decryptCipher.init(2, aesKey, ivParameterSpec);
	      

	      ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
	      ByteArrayInputStream inStream = new ByteArrayInputStream(encryptedBytes);
	      CipherInputStream cipherInputStream = new CipherInputStream(inStream, decryptCipher);
	      byte[] buf = new byte[1024];
	      int bytesRead;
	      while ((bytesRead = cipherInputStream.read(buf)) >= 0) {
	        outputStream.write(buf, 0, bytesRead);
	      }
	      System.out.println("Result: " + new String(outputStream.toByteArray()));
	    }
	    catch (NoSuchAlgorithmException|javax.crypto.NoSuchPaddingException e) {
	      e.printStackTrace();
	    }
	    catch (InvalidKeyException e) {
	      e.printStackTrace();
	    } catch (IOException e) {
	      //System.out.println("Sorry, flag can only be decrypted with ephemeral key that was created and destroyed around build time... your loss");
	      //e.printStackTrace();
	      throw e;
	    }
	    catch (InvalidAlgorithmParameterException e) {
	      e.printStackTrace();
	    }
		// TODO Auto-generated method stub


	}
	public static void main(String[] args) {
		for (int i = 0; i < 86400; i++) {
			boolean success = true;
			try {
				doit(i);
			}
			catch (IOException e) {
				success = false;
			}
			if (success)
				System.out.println("" + i);
		}
	}

}
