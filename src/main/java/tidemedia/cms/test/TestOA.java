package tidemedia.cms.test;

import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.rmi.RemoteException;

import javax.xml.rpc.ServiceException;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;

import tidemedia.cms.util.Util;

public class TestOA {
	public static void main(String[] args) throws Exception
	{
		System.out.println("o");
        MCrypt m = new MCrypt();
        //System.out.println(m.encrypt("a"));
        System.out.println((m.decrypt("78c1f0fd6c21f221c872c2bc21acac4907188038d749c7b79871e2f1c06bcf9ac3b215d8d4c01407ba2394c21287046c"))+"|");        
	}
}
