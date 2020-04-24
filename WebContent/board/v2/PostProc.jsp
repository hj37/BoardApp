<%@page import="java.sql.Timestamp"%>
<%@ page contentType="text/html; charset=UTF-8"%>


<%
	//순서1.Post.jsp페이지에서 요청받은 글쓰기 내용 한글처리 
	request.setCharacterEncoding("UTF-8");
%>

<%--순서2. DB작업을 위한 Dao객체 생성 --%>
<jsp:useBean id="dao" class="com.bean.board.BoardDaoImpl"/>

<%--순서3. Post.jsp페이지에서 요청받은 글쓴내용을 request객체영역에서 얻어 BoardDto객체의 각 변수에 저장 --%>

<jsp:useBean id = "dto" class="com.bean.board.BoardDto"/>
<jsp:setProperty property="*" name="dto"/>

<%--순서4. 클라이언트가 입력한 글 내용을 DB에 추가하기 위해..BoardDaoImpl객체의 insertBoard메소드 호출 시 
	BoardDto객체를 인자로 전달하여 DB작업	(insert작업)시킴
--%>

<%
	//글을 입력한 시간을 생성하여 BoardDto객체의 regdate변수에 추가로 저장 
	dto.setRegdate(new Timestamp(System.currentTimeMillis())); //현재 시스템 시간을 반환해올 수 있음 long타입을 반환함
	
	//DB작업 (insert작업)을 위해 메소드 호출 시 .. BoardDto객체 전달 
	 dao.insertBoard(dto);
	
	//순서5. 글추가후 다시 List.jsp를 재요청하여 이동되도록 
	response.sendRedirect("List.jsp");

%>