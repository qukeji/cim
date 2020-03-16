package tidemedia.cms.test;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.encoder.ByteMatrix;

public class QRCode {
	public static void main(String[] args)
	{
		String str = "泰得方舟科技中心 TideCMS";
        String path = "D:\\hwy.png";  
        BitMatrix byteMatrix;  
        try {
			byteMatrix = new MultiFormatWriter().encode(new String(str.getBytes("GBK"),"iso-8859-1"),BarcodeFormat.QR_CODE, 40, 40);
			File file = new File(path);  
	          
	        MatrixToImageWriter.writeToFile(byteMatrix, "png", file); 
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (WriterException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}  
        
        
	}
}
