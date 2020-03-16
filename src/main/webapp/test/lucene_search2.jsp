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
//显示全部列表
IndexReader reader = LuceneUtil.getWriter().getReader();
Searcher searcher = new IndexSearcher(reader);
Query query1 = new MatchAllDocsQuery("Title");
//Query query4 = new TermQuery(new Term("Keyword","姚明"));
//Query query2 = parser.parse("ChannelCode:(4019_4020* 3625_4112* 4137_4138* 4143_4147* 4144_4152* 4145_4156* 4146_4161* 4182_4269* 4379_4380*)");
//Query query3 = NumericRangeQuery.newIntRange("GlobalID",0,null,true,true);
Query query4 = NumericRangeQuery.newIntRange("IsContent",1,1,true,true);
//Query query4 = new TermQuery(new Term("IsContent","0"));
BooleanQuery keyword_query = new BooleanQuery();
keyword_query.add(new TermQuery(new Term("Keyword","黑砖窑")),BooleanClause.Occur.SHOULD);
keyword_query.add(new TermQuery(new Term("Keyword","姚明")),BooleanClause.Occur.SHOULD);
BooleanQuery query = new BooleanQuery();
query.add(keyword_query, BooleanClause.Occur.MUST);
query.add(query4, BooleanClause.Occur.MUST);
//query.add(query2, BooleanClause.Occur.MUST);
//query.add(query4, BooleanClause.Occur.MUST);
Sort sort = new Sort() ;
//sort.setSort(new SortField("OrderNumber", SortField.INT ,true)) ;
sort.setSort(new SortField("OrderNumber", SortField.INT ,true)) ;

TopDocs t = searcher.search(query1,30);

out.println("总数："+t.totalHits);
long begin_time = System.currentTimeMillis();
t = searcher.search(query,30,sort);
out.println("查询数量："+t.totalHits+",用时："+(System.currentTimeMillis()-begin_time)+"ms");
ScoreDoc[] hits = t.scoreDocs;
    for (int i = 0; i < hits.length; i++) {
	  org.apache.lucene.document.Document doc = searcher.doc(hits[i].doc);
      //out.println("<br>"+doc.get("Title")+","+doc.get("ChannelCode")+","+doc.get("GlobalID")+",ordernumber:"+doc.get("OrderNumber")+",status:"+doc.get("Status"));
	  tidemedia.cms.system.Document dd = new tidemedia.cms.system.Document(Util.parseInt(doc.get("GlobalID")));
	  out.println("<br>"+dd.getTitle()+",keyword:"+dd.getKeyword()+",ordernumber:"+dd.getOrderNumber()+",status:"+dd.getStatus()+",iscontent:"+dd.getChannel().getParentChannelPath());
    }
%>
<br><%=(System.currentTimeMillis()-begin_time)%>ms