<%@page import="com.bean.board.BoardDto"%>
<%@page import="com.bean.board.BoardDaoImpl"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head><title>JSPBoard</title>
<link href="style.css" rel="stylesheet" type="text/css">
</head>
<body>
	<%
		//(설명) Reply.jsp화면은 답변글을 입력할 수 있는 디자인 화면으로 
		//기존에 DB에 찾아되어 있는 주글(부모글)에 대한 글제목, 글내용이 현재 화면에 출력되어 있어야 할것이다.
		
		//Read.jsp페이지(주글상세보기 화면)에서 답변링크를 클릭했을때 전달받은 3가지 값을 얻자
		int num = Integer.parseInt(request.getParameter("num"));
		String keyField = request.getParameter("keyField");
		String keyWord = request.getParameter("keyWord");
		
		//답변글을 DB에 추가하기 전에 주글(부모글)에 대한 정보(글제목, 글내용)를 DB에서 검색해서 가져오자 
		BoardDaoImpl dao = new BoardDaoImpl();
		BoardDto dto = dao.getBoardInfo(num);	//주글 글번호를 전달하여 주글에 대한 정보 검색 
		//검색한 주글(부모글)의 글제목 얻어 저장 
		String subject = dto.getSubject();
		//검색한 주글(부모글)의 글내용을 얻어 저장 
		String content = dto.getContent().replace("<br>","\n");
		
	%>



<center>
<br><br>
<table width=80% cellspacing=0 cellpadding=3>
 <tr>
  <td bgcolor=84F399 height=25 align=center>답변글작성</td>
 </tr>
</table>
<br>
<table width=80% cellspacing=0 cellpadding=3 align=center>
<form name=post method=post action="ReplyProc.jsp" > <%--답변글을 작성 후 답변글 등록 요청! --%>
	<%--글을 작성하는 사람의 IP주소 전달 --%>
 	<input type="hidden" name="ip" value="<%=request.getRemoteAddr() %>">
 	
 	<%--주글(부모글)에 대한 답변글을 달기 위해 부모글에 대한 글번호를 전달 --%>
 	<input type="hidden" name="num" value="<%=num%>">
 	
 	<%--이전 Read.jsp에서 검색했던 주글(부모글)에 대한 검색기준값, 검색어를 전달 --%>
 	<input type="hidden" name="keyField" value="<%=keyField%>">
 	<input type="hidden" name="keyWord" value="<%=keyWord%>">
 	
 <tr>
  <td align=center>
   <table border=0 width=100% align=center>
    <tr>
     <td width=10%>성 명</td>
     <td width=90%><input type=text name=name size=10 maxlength=8></td>
    </tr>
    <tr>
	 <td width=10%>E-Mail</td>
	 <td width=90%><input type=text name=email size=30 maxlength=30></td>
    </tr>
    <tr>
     <td width=10%>홈페이지</td>
     <td width=90%><input type=text name=homepage size=40 maxlength=30></td>
    </tr>
    <tr>
     <td width=10%>제 목</td>
     <td width=90%><input type=text name=subject size=50 maxlength=30 value="Re:<%=subject%>"></td>
    </tr>
    <tr>
     <td width=10%>내 용</td>
     <td width=90%><textarea name=content rows=10 cols=50><%=content%></textarea></td>
    </tr>
    <tr>
     <td width=10%>비밀 번호</td> 
     <td width=90% ><input type=password name=pass size=15 maxlength=15></td>
    </tr>
    <tr>
     <td colspan=2><hr size=1></td>
    </tr>
    <tr>
     <td><input type=submit value="답변글등록" >&nbsp;&nbsp;
         <input type=reset value="다시쓰기">&nbsp;&nbsp;
     </td>
    </tr> 
   </table>
  </td>
 </tr>
</form> 
</table>
</center>
</body>
</html>