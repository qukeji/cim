package tidemedia.cms.test;

import org.im4java.core.ConvertCmd;
import org.im4java.core.IMOperation;

public class ImgVideo {
	public static void main(String[] args) throws Exception
	{
		 
 
        for(int i = 0;i<100000;i++)
        {
        	IMOperation op = new IMOperation(); 
    		ConvertCmd convert = new ConvertCmd();
            convert.setSearchPath("E:/Program Files/ImageMagick-6.3.9-Q16");
        	
            op.gravity("SouthWest").pointsize(40).fill("red").draw("text 30,30 '"+i+"'");  
            op.addImage();
            op.addImage();
            
        	String s = i+"";
        	        	
        	if(i<10000) s = "0" + i;
        	if(i<1000) s = "00" + i;
        	if(i<100) s = "000" + i;
        	if(i<10) s = "0000" + i;
        	
        	String d = "e:/video/photo4/d_"+s+".jpg";
        	convert.run(op, "e:/video/a.jpg",d);
        	System.out.println(d);
        }
        
        System.out.println("end");
	}
}
