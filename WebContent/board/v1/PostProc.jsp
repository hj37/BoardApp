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