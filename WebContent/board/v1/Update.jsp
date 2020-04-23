<%@page import="com.bean.board.BoardDto"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<html>
<head> <title>JSPBoard</title>
<link href="style.css" rel="stylesheet" type="text/css">
<script>
	function check() {
	   if (document.form.pass.value == "") {
		 alert("수정을 위해 패스워드를 입력하세요.");
	     form.pass.focus();
		 return false;
		 }
	   document.form.submit();
	}
</script>
</head>
<body>

	<%--
		Read.jsp페이지에서 수정링크 클릭했을때.. 수정할 글번호를 request내장객체영역에 저장후 
		Update.jsp로 전송해 Update.jsp페이지에서 수정 하기전 수정할 글번호를 이용해 
		한번 더 글을 검색 후 아래의 디자인 화면에 출력하자.
	 --%>
	 <jsp:useBean id="dao" class="com.bean.board.BoardDaoImpl"></jsp:useBean>
	 
	<%
		//수정할 글번호 얻기 
		int num = Integer.parseInt(request.getParameter("num"));
	
		//수정할 글번호를 getBoardInfo()메소드에 전달하여 하나의 글 정보를 검색한 후 BoardDto 객체에 저장 후 반환.
		BoardDto dto = dao.getBoardInfo(num);
		
		String name = dto.getName();
		String email = dto.getEmail();
		String subject = dto.getSubject();
		String content = dto.getContent();
	%>


<center>
<br><br>
<table width=460 cellspacing=0 cellpadding=3>
  <tr>
   <td bgcolor=#FF9018  height=21 align=center class=m>수정하기</td>
  </tr>
</table>

<form name=form method=post action="UpdateProc.jsp" >
	
	<%--수정할 글번호 전달 --%>
	<input type="hidden" name="num" value="<%=num%>">
	
<table width=70% cellspacing=0 cellpadding=7>
 <tr>
  <td align=center>
   <table border=0>
    <tr>
     <td width=20%>성 명</td>
     <td width=80%>
	  <input type=text name=name size=30 maxlength=20 value="<%=name%>">
	 </td>
	</tr>
    <tr>
     <td width=20%>E-Mail</td>
     <td width=80%>
	  <input type=text name=email size=30 maxlength=30 value="<%=email%>">
	 </td>
    </tr>
	<tr>
     <td width=20%>제 목</td>
     <td width=80%>
	  <input type=text name=subject size=50 maxlength=50 value="<%=subject%>">
	 </td>
    <tr>
     <td width=20%>내 용</td>
     <td width=80%>
	  <textarea name=content rows=10 cols=50><%=content%></textarea>
	 </td>
    </tr>
	<tr>
     <td width=20%>비밀 번호</td> 
     <td width=80%><input type=password name=pass size=15 maxlength=15>
      수정시에는 비밀번호가 필요합니다.</td>
    </tr>
	<tr>
     <td colspan=2 height=5><hr size=1></td>
    </tr>
	<tr>
     <td colspan=2>
	  <input type=Button value="수정완료" onClick="check()">
      <input type=reset value="다시수정"> 
      <input type=button value="뒤로" onClick="history.back()">
	 </td>
    </tr> 
   </table>
  </td>
 </tr>
</table>
</form> 
</center>
</body>
</html>