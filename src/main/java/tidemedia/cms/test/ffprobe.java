package tidemedia.cms.test;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class ffprobe {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String duration = "";
		List<String> c=new java.util.ArrayList<String>();
		long begin = System.currentTimeMillis();
		ProcessBuilder builder = new ProcessBuilder();
		String videofile = "e\\\\:/5ed3ee98fa73f3b24f574b652dbbe556/1833.mp4"; 
		c.add("e:/video/ffprobe");
		//c.add("E:/video/ffprobe");
		c.add("-show_frames");
		c.add("-f");
		c.add("lavfi");
		c.add("\"movie="+videofile+",select=gt(scene\\,0.3)\"");
		c.add("-show_frames");
		c.add("-print_format");
		c.add("json=c=1");
		//c.add(videofile);

		builder.command(c);
		builder.redirectErrorStream(true);
		String bufs = "";
		String commend_desc = c.toString().replace(", ", " ");
		System.out.println(commend_desc);
		ArrayList<Integer> keyframes = new ArrayList<Integer>();
		try{
		Process process1 = builder.start();
		InputStream is2 = process1.getInputStream(); 
		BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
		StringBuilder buf2 = new StringBuilder();
		String line2 = null;
		
		String s = "pkt_dts_time\": \"";
		while((line2 = br2.readLine()) != null)
		{System.out.println(line2);

		}
		
		bufs = buf2.toString();
		

		}catch(Exception e){
			System.out.println(e.getMessage());
			e.printStackTrace(System.out);

		}
	}

}
