package bomb;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.security.GeneralSecurityException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Base64.Decoder;
import java.util.Date;
import javax.crypto.Cipher;
import javax.crypto.CipherInputStream;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class LogicBomb
{
  public LogicBomb() {}
  
  public static void main(String[] args)
  {
    String encflag = "l1SZbTGrPhEyNBFqqoS6IV1qJhaOKY8M1/lcA+BPSdE=";
    







    try
    {
      String iv = "IVIVIVIVIVIVIVIV";
      IvParameterSpec ivParameterSpec = new IvParameterSpec(iv.getBytes(), 0, 16);
      
      Date now = new Date();
      
      String timeStamp = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(now);
      
      MessageDigest digest = MessageDigest.getInstance("SHA-256");
      byte[] encodedKey = digest.digest(timeStamp.getBytes());
      
      javax.crypto.SecretKey aesKey = new SecretKeySpec(encodedKey, 0, encodedKey.length, "AES");
      
      byte[] encryptedBytes = java.util.Base64.getDecoder().decode(encflag);
      

      Cipher decryptCipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
      decryptCipher.init(2, aesKey, ivParameterSpec);
      

      ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
      ByteArrayInputStream inStream = new ByteArrayInputStream(encryptedBytes);
      CipherInputStream cipherInputStream = new CipherInputStream(inStream, decryptCipher);
      byte[] buf = new byte['Ѐ'];
      int bytesRead;
      while ((bytesRead = cipherInputStream.read(buf)) >= 0) { int bytesRead;
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
      System.out.println("Sorry, flag can only be decrypted with ephemeral key that was created and destroyed around build time... your loss");
      e.printStackTrace();
    }
    catch (InvalidAlgorithmParameterException e) {
      e.printStackTrace();
    }
  }
}
