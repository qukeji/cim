package tidemedia.cms.util;

import java.io.IOException;
import java.sql.SQLException;

import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.HttpSolrClient;
import org.apache.solr.client.solrj.response.UpdateResponse;
import org.apache.solr.common.SolrInputDocument;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Document;

public class SolrUtil {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

	public static boolean addSolr(Document doc) throws MessageException, SQLException
	{
		return true;
		/*
		String solr_url = CmsCache.getParameterValue("solr_url");
		SolrClient solr = new HttpSolrClient.Builder(solr_url).build();
		boolean result = false;
		
		SolrInputDocument document = new SolrInputDocument();
		document.addField("id", "552199");
		document.addField("name", "Gouda cheese wheel");
		document.addField("price", "49.99");
		try {
			UpdateResponse response = solr.add(document);
			
			System.out.println(response.getElapsedTime());
			solr.commit();
		} catch (SolrServerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return result;
		*/
	}
}
