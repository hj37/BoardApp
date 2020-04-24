<%@page import="java.sql.Timestamp"%>

<%@page import="com.bean.board.BoardDto"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<html>
<head><title>JSPBoard</title>
<link href="style.css" rel="stylesheet" type="text/css">


	<script type="text/javascript">
	
	//목록 링크를 클릭했을때..List.jsp페이지를 재요청해 이전에 검색했던 검색어와 검색기준값을 전달함.
	function fnList(){
		
		document.list.submit();
		
	
		
	}
	</script>

</head>

<%
	//List.jsp페이지에서 글제목을 눌렀을떄..
	//글번호, 검색기준값, 검색어값을 입력했을때..
	request.setCharacterEncoding("UTF-8");
	out.println(request.getParameter("num") + "," + request.getParameter("keyField") + ","
			+ request.getParameter("keyWord"));	
	

%>
	<%--1. 수정할 글번호를 이용해 글번호에 해당하는 글을 검색하는 DB작업을 위해 BoardDaoImpl객체 생성 --%>
	<jsp:useBean id="dao" class="com.bean.board.BoardDaoImpl"></jsp:useBean>
<%
	//2. List.jsp에서 글제목을 눌렀을때 전달받은 3개의 값을 저장
	int num = Integer.parseInt(request.getParameter("num"));	//글번호
	String keyField = request.getParameter("keyField");	//검색했던 글에 대한 검색기준값 얻기
	String keyWord = request.getParameter("keyWord");	//검색했던 글에 대한 검색어값 얻기
	
	//3. 수정할 글번호를 이용해 글번호에 해당되는 글을 검색하기 위해 BoardDaoImpl객체의 getBoard()메소드 호출시
	// 글 번호를 전달하여 검색해옴
	
	 BoardDto dto= dao.getBoard(num);
	
	//4. getBoard메소드로부터 반환받은 BoardDto객체의 getter메소드들을 호출하여 검색한 글의 정보를 얻어
	//  아래의 디자인 영역에 출력
	String name = dto.getName();	//검색한 글의 정보 중 글쓴이
	String email = dto.getEmail();	//검색한 글의 정보 중 이메일 주소 
	String homePage = dto.getHomepage(); //검색한 글의 정보 중 글쓴이의 홈페이지 주소 
	String subject = dto.getSubject(); //검색한 글의 정보 중 글제목
	Timestamp regdate = dto.getRegdate();	//검색한 글의 정보 중 글쓴날짜
	String content = dto.getContent().replace("\n","<br>");//화면에 입력한 엔터키값은 <br>로 처리하겠다는 뜻
	String ip = dto.getIp(); //검색한 글의 정보 중 글쓴이의 아이피주소
	int count = dto.getCount();
	

%>




<body>
<br><br>
<table align=center width=70% border=0 cellspacing=3 cellpadding=0>
 <tr>
  <td bgcolor=9CA2EE height=25 align=center class=m>글읽기</td>
 </tr>
 <tr>
  <td colspan=2>
   <table border=0 cellpadding=3 cellspacing=0 width=100%> 
    <tr> 
	 <td align=center bgcolor=#dddddd width=10%> 이 름 </td>
	 <td bgcolor=#ffffe8><%=name %></td>
	 <td align=center bgcolor=#dddddd width=10%> 등록날짜 </td>
	 <td bgcolor=#ffffe8><%=regdate %></td>
	</tr>
    <tr>
	 <td align=center bgcolor=#dddddd width=10%> 메 일 </td>
	 <td bgcolor=#ffffe8 ><%=email %></td> 
	 <td align=center bgcolor=#dddddd width=10%> 홈페이지 </td>
	 <td bgcolor=#ffffe8 ><a href="http://<%=homePage%>" target="_new">
	 						http://<%=homePage%>
	 					  </a>
	</td> 
	</tr>
    <tr> 
     <td align=center bgcolor=#dddddd> 제 목</td>
     <td bgcolor=#ffffe8 colspan=3><%=subject%></td>
   </tr>
   <tr> 
    <td colspan=4><%=content%></td>
   </tr>
   <tr>
    <td colspan=4 align=right>
     	<%=ip %>로 부터 글을 남기셨습니다./  조회수 : <%=count%> 
    </td>
   </tr>
   </table>
  </td>
 </tr>
 <tr>
  <td align=center colspan=2> 
	<hr size=1>
	[ <a href="javascript:fnList()">목 록</a> | 
	<a href="Update.jsp?num=<%=num%>">수 정</a> |
	
	<a href="Delete.jsp?num=<%=num%>">삭 제</a> ]<br>
  </td>
 </tr>
</table>
	
		<form name="list" action="List.jsp" method="post">
			
			<input type="hidden" name="keyField" value="<%=keyField%>">
			<input type="hidden" name="keyWord" value="<%=keyWord%>">
		</form>

</body>
</html>
