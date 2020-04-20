<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.bean.board.BoardDto"%>
<%@page import="java.util.Vector"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<HTML>
<link href="style.css" rel="stylesheet" type="text/css">
<script>
	function check(){
		//검색어를 입력 하지 않았다면
		if(document.search.keyWord.value == ""){
			//경고메세지
			alert("검색어를 입력하세요.");
			//검색어 입력 공간에 포커스를 주어 검색어를 입력하도록 유도함.
			document.search.keyWord.focus();
			return;
		}
		//검색어를 입력했다면...<form action="List.jsp" name="search">로 요청이 일어남 
		//입력한 검색어, 검색기준값을 request내장객체 영역에 저장 후 요청이 일어남
		document.search.submit();
	}
</script>
<BODY>
<center><br>
<h2>JSP Board</h2>

<%-- 순서1. DB작업을 하기 위해 BoardDaoImpl객체 생성 --%>
<jsp:useBean id="dao" class="com.bean.board.BoardDaoImpl"/>

<%-- 순서2. 검색기준값과 검색어를 저장하기 위한 변수 선언 --%>
<%!
	String keyWord="",keyField = "";
%>
<%--순서3. List.jsp현재 화면에서 검색기준값을 선택하고 검색어를 입력하여 전달받기 --%>
<%
	//입력한 검색어가 한글이라면 한글처리 
	request.setCharacterEncoding("UTF-8");

	//만약~ 검색어가 입력 되었다면 
	if(request.getParameter("keyWord") != null){
		//선택한 검색기준값
		keyField = request.getParameter("keyField");
		//입력한 검색어 얻기 
		keyWord = request.getParameter("keyWord");
	}

	//게시판 테이블에 저장되어 있는 글을 조회하기 위해 BoardDaoImpl객체의 getBoardList메소드 호출시..
	//선택한 검색기준값과, 입력한 검색어를 전달하여 SELECT작업을 진행함.
	//SELECT작업 후 검색된 글의 목록을 Vector배열에 담아 반환받습니다.
	Vector v = dao.getBoardList(keyField, keyWord);
	
	out.println(v.size());

%>

<table align=center border=0 width=80%>
<tr>
	<td align=left>Total :  Articles(
		<font color=red>  1 / 10 Pages </font>)
	</td>
</tr>
</table>

<table align=center width=80% border=0 cellspacing=0 cellpadding=3>
<tr>
	<td align=center colspan=2>
		<table border=0 width=100% cellpadding=2 cellspacing=0>
			<tr align=center bgcolor=#D0D0D0 height=120%>
				<td> 번호 </td>
				<td> 제목 </td>
				<td> 이름 </td>
				<td> 날짜 </td>
				<td> 조회수 </td>
			</tr>
		<%
			//만약에 조회된 글정보가 존재하지 않으면 
			if(v.isEmpty()){//비어 있다면?
		%>
			<tr>
				<td colspan="5" align="center">등록된 글이 없습니다.</td>
			</tr>
		
		<% 				
			}else{	//조회된 글이 있다면? (Vector배열에 BoardDto객체들이 존재한다면?)

				//날짜 형식으로 포맷을 변경 시켜 주는 객체 생성 
				SimpleDateFormat s =new SimpleDateFormat("yyyy-MM-dd");
				
					for(int i = 0; i < v.size(); i++){
						BoardDto tmp = (BoardDto)v.get(i);
						int num = tmp.getNum();
						String subject = tmp.getSubject();
						String name = tmp.getName();
						Timestamp regdate = tmp.getRegdate();
						int count = tmp.getCount();
						String email = tmp.getEmail();
					%>	
						<tr align="center">
							<td> <%=num %> </td>
							<td> <%=subject %> </td>
							<td><a href="mailto:<%=email%>"><%=name %></a></td>
							<td> <%=s.format(regdate) %> </td>
							<td> <%=count %> </td>	
						</tr>
		<% 			
			}
		}
		%>	
			
			
		</table>
	</td>
</tr>
<tr>
	<td><BR><BR></td>
</tr>
<tr>
	<td align="left">Go to Page </td>
	<td align=right>
		<a href="Post.jsp">[글쓰기]</a>
		<a href="javascript:list()">[처음으로]</a>
	</td>
</tr>
</table>
<BR>
<form action="List.jsp" name="search" method="post">
	<table border=0 width=527 align=center cellpadding=4 cellspacing=0>
	<tr>
		<td align=center valign=bottom>
			<select name="keyField" size="1">
				<option value="name"> 이름
				<option value="subject"> 제목
				<option value="content"> 내용
			</select>

			<input type="text" size="16" name="keyWord" >
			<input type="button" value="찾기" onClick="check()">
			<input type="hidden" name="page" value= "0">
		</td>
	</tr>
	</table>
</form>
</center>	
</BODY>
</HTML>