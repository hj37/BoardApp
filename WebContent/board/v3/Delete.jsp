<%@page import="com.bean.board.BoardDto"%>
<%@ page contentType="text/html; charset=UTF-8" %>


<%--
	Read.jsp페이지에서 삭제 <a>링크를 클릭했을때...
	Delete.jsp페이지를 요청하면서 삭제할 글번호를 전달 했으므로 
	삭제할 글번호를 이용해 글을 DB에 저장된 하나의 글을 삭제 작업 해야함.
 --%>
 
 	<jsp:useBean id="dao" class="com.bean.board.BoardDaoImpl"/>
 	<%
 		//Read.jsp페이지에서 삭제<a>링크를 눌렀을때 삭제할 글번호 얻기
 		//Delete.jsp페이지의 디자인에서 삭제할 글에 대한 비밀번호 입력 후 삭제완료버튼 클릭했을때..
 		//삭제할 글번호를 hidden값으로 전달받기 
 		
 		int num = Integer.parseInt(request.getParameter("num"));
 		//얻은 글번호를 이용해 DB에 저장된 글에 대한 비밀번호를 검색하여 가져온다.
 		BoardDto dto = dao.getBoardInfo(num);
 		
//  		/아래의 디자인 화면에서 사용자가 입력한 비밀번호를 저장할 변수 선언.
		String paramPass="";
		//DB에 저장된 글의 비밀번호를 저장할 변수 선언
		String dbPass="";
		dbPass = dto.getPass();	// DB 비밀번호
 		
		if(request.getParameter("pass") != null){//아래의 디자인화면에서 삭제할 글의 비밀번호를 입력했다면
			//사용자가 입력한 비밀번호를 얻어 변수에 저장
			paramPass = request.getParameter("pass");
			
			//입력한 비밀번호와 DB에 저장되어 있는 비밀번호가 동일하지 않다면?
	 		if(!paramPass.equals(dbPass)){
		%>
			
			<script type="text/javascript">
				window.alert("입력하신 비밀번호가 올바르지 않습니다.");
				history.go(-1);
			</script>
		<%	
	 		}else{//입력한 비밀번호와 DB에 저장된 삭제할 글에 대한 비밀번호와 동일한다면?
	 				//BoardDaoImpl객체의 deleteBoard(int num)메소드 호출시... 삭제할 글번호를 전달하여 
	 				//DELETE명령함.
	 				dao.deleteBoard(num);
	 		
	 				//삭제에 성공하면 List.jsp를 재요청해 이동함.
	 				response.sendRedirect("List.jsp");
	 		}
			
		}
 	
 	%>





<html>
<head><title>JSPBoard</title>
<link href="style.css" rel="stylesheet" type="text/css">
<script>
	function check() {
		if (document.form.pass.value == "") {
		alert("패스워드를 입력하세요.");
		form.pass.focus();
		return false;
		}
		document.form.submit();
	}
</script>
</head>
<body>
<center>
<br><br>
<table width=50% cellspacing=0 cellpadding=3>
 <tr>
  <td bgcolor=#dddddd height=21 align=center>
      사용자의 비밀번호를 입력해 주세요.</td>
 </tr>
</table>
<table width=70% cellspacing=0 cellpadding=2>
<form name=form method=post action="Delete.jsp" >

	<%--삭제할 글번호 전송 --%>
	<input type="hidden" name="num" value="<%=num%>">
	
 <tr>
  <td align=center>
   <table align=center border=0 width=91%>
    <tr> 
     <td align=center>  
	  <input type=password name="pass" size=17 maxlength=15>
	 </td> 
    </tr>
    <tr>
     <td><hr size=1 color=#eeeeee></td>
    </tr>
    <tr>
     <td align=center>
	  <input type=button value="삭제완료" onClick="check()"> 
      <input type=reset value="다시쓰기"> 
      <input type=button value="뒤로" onClick="history.back()">
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
