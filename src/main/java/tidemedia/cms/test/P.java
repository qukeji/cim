package tidemedia.cms.test;

class P implements Comparable<P> {
	  int docid;
	  Integer ordernumber;

	  P(int a,int b) {
	    docid = a;ordernumber = b;
	  }

	  public int compareTo(P msg2) {
	    return ordernumber.compareTo(msg2.ordernumber);
	  }
	}
