<%@page import="com.bean.board.BoardDto"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%
	//Update.jsp에서 입력한 수정할 글내용은 모두 request객체영역에 저장되어있으므로 
	//한글이 하나라도 존재하면 한글깨짐 방지를 위해 문자셋 방식을 UTF-8;
	request.setCharacterEncoding("UTF-8");
	
	//수정할 글번호를 request영역에서 얻기 
	int num = Integer.parseInt(request.getParameter("num"));
%>


	<%-- 수정 DB작업을 위해 BoardDaoImpl객체 생성 --%>
	<jsp:useBean id="dao" class="com.bean.board.BoardDaoImpl"></jsp:useBean>
	
	<%-- Update.jsp에서 입력한 수정할 내용을 request객체에서 꺼내와서 BoardDto객체의 각변수에 저장 --%>
	<jsp:useBean id="dto" class="com.bean.board.BoardDto"></jsp:useBean>
	<jsp:setProperty property="*" name="dto"/>
	
<%

	//수정할 글 번호를 통해 수정할 글번호를 다시 검색해서 가져옴
	BoardDto tmpDto = dao.getBoardInfo(num);

	//DB에서 검색된 수정할 글정보중!! DB에 저장된 비밀번호값 얻기 
	String storedPass = tmpDto.getPass();
	
	//Update.jsp페이지에서 글 수정 시 입력한 비밀번호값 얻기 
	String paramPass = dto.getPass();
	
	//Update.jsp페이지에서 글 수정시 입력한 비밀번호와 DB에 저장되어 있는 비밀번호가 다르면 
	if(!paramPass.equals(storedPass)){
%>
	<script type="text/javascript">
		window.alert("입력하신 글의 비밀번호가 올바르지 않습니다.");
		history.back(); //Update.jsp로 이동하여 다시 비밀번호 입력하도록 유도 
	
	</script>
<%		
	}else{//입력한 비밀번호와 DB에 저장되어 있는 글에 대한 비밀번호가 동일하면 
		
		//BoardDaoImpl객체의 updateBoard메소드 호출 시 매개변수로 위에 액션태그로 생성된 BoardDto객체를 전달하여
		//UPDATE작업 명령!
		int result = dao.updateBoard1(dto);	//글 수정에 성공하면 1을 반환받고 실패하면 0을 반환 받아 처리 

		if(result == 0){
%>		
		<script>
			alert("수정실패");
			history.back();
		</script>
		
	
		
<%		
		}else{
%>
	<script type="text/javascript">
		alert("수정 성공");
		location.href="List.jsp";
	</script>


<%
		}
	/* 
		//List.jsp페이지를 재요청해 이동하여 검색하여 나타냄
		response.sendRedirect("List.jsp"); */
	}

%>