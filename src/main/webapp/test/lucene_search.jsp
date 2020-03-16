<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				org.apache.lucene.search.*,
				org.apache.lucene.store.*,
				org.apache.lucene.util.*,
				org.apache.lucene.analysis.standard.*,
				org.apache.lucene.queryParser.*,
				org.apache.lucene.index.*,
				java.io.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
IndexReader reader = LuceneUtil.getWriter().getReader();
Searcher searcher = new IndexSearcher(reader);
Query query1 =   NumericRangeQuery.newIntRange("IsContent",1,1,true,true);
Query query4 = new TermQuery(new Term("Keyword","湖北"));
//Query query2 = parser.parse("ChannelCode:(4019_4020* 3625_4112* 4137_4138* 4143_4147* 4144_4152* 4145_4156* 4146_4161* 4182_4269* 4379_4380*)");
//Query query3 = NumericRangeQuery.newIntRange("GlobalID",0,null,true,true);
//Query query4 = NumericRangeQuery.newIntRange("Status",1,1,true,true);
//Query query4 = new TermQuery(new Term("Status","1"));
BooleanQuery keyword_query = new BooleanQuery();
keyword_query.add(new TermQuery(new Term("Keyword","湖北")),BooleanClause.Occur.SHOULD);
keyword_query.add(new TermQuery(new Term("Keyword","武汉市")),BooleanClause.Occur.SHOULD);
BooleanQuery query = new BooleanQuery();
//query.add(query3, BooleanClause.Occur.MUST);
query.add(query1, BooleanClause.Occur.MUST);
//query.add(query2, BooleanClause.Occur.MUST);
//query.add(query4, BooleanClause.Occur.MUST);
Sort sort = new Sort() ;
//sort.setSort(new SortField("OrderNumber", SortField.INT ,true)) ;
sort.setSort(new SortField("OrderNumber", SortField.INT ,true)) ;
long begin_time = System.currentTimeMillis();
TopDocs t = searcher.search(keyword_query,30);
ScoreDoc[] hits = t.scoreDocs;
out.println(t.totalHits);
    // Iterate through the results:
    for (int i = 0; i < hits.length; i++) {
		org.apache.lucene.document.Document doc = searcher.doc(hits[i].doc);
      out.println("<br>"+doc.get("Title")+","+doc.get("ChannelCode")+","+doc.get("GlobalID")+",ordernumber:"+doc.get("OrderNumber")+",status:"+doc.get("Status"));
    }
%>
<br><%=(System.currentTimeMillis()-begin_time)%>ms