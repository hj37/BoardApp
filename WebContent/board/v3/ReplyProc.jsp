<%@page import="com.bean.board.BoardDto"%>
<%@page import="com.bean.board.BoardDaoImpl"%>
<%@page import="java.sql.Timestamp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
    <%
    
    	//Reply.jsp페이지에서 전달받은 데이터 한글 처리 
    	request.setCharacterEncoding("UTF-8");
    %>
    
    <%--Reply.jsp에서 입력한 답변글 내용 + 주글내용을 request에서 얻어 BoardDto객체의 변수에 저장--%>
    <jsp:useBean id="dto" class="com.bean.board.BoardDto"/>
    <jsp:setProperty property="*" name="dto"/>
    
    <%
    	//DTO에 답변글을 작성한 날짜 추가로 저장 
    	dto.setRegdate(new Timestamp(System.currentTimeMillis()));
    
    	//Reply.jsp 답변쓰기 디자인 페이지에서 답변글내용을 입력하고 답변등록 버튼을 눌렀을때 전달받는
    	//주글에 대한 정보 3가지 얻기
    	int num = Integer.parseInt(request.getParameter("num")); //부모글번호
    	String keyField = request.getParameter("keyField");	//검색했던 부모글의 검색기준값
    	String keyWord = request.getParameter("keyWord");	//검색했던 부모글의 검색어값
    	
    	//부모글번호를 이용해 부모글정보를 검색해서 얻자 
    	BoardDaoImpl dao = new BoardDaoImpl();
		BoardDto ParentDto  = dao.getBoardInfo(num);
    	
		//답변글 작성시.. 부모글보다 큰 POS값이 있으면 1을 더해서 수정하기 
		dao.replyUpPos(ParentDto.getPos());
		
		//위에 생성한 답변글 dto객체에 부모글의 pos값과 depth값을 저장하기 
		dto.setPos(ParentDto.getPos());
		dto.setDepth(ParentDto.getDepth());
		
		//추가로 부모글의 pos와 depth를 저장한 입력한 답변글의 정보가 들어있는 위의 BoardDto객체를 전달하여 
		//답변글 추가 작업을 하자 
		dao.replyBoard(dto);	//답변글 추가 작업 요청 
		
		//DB에 답변글 추가에 성공했을 경우 다시 List.jsp를 요청해 이동
		response.sendRedirect("List.jsp");
    %>
    
    