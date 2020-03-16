<%
for(int i = 0;i<100000;i++)
{
int random = new java.util.Random().nextInt(999)+1;
if(random<=0) System.out.println(random);
}
%>