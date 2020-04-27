<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="com.bean.board.BoardDto"%>
<%@page import="java.util.Vector"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
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
	
	//추가2.
	//처음으로 링크 눌렀을때.. 호출되는 함수 
	function fnList() {
		//<form>태그의 name속성을 이용해 접근하여 action속성의 값을 List.jsp로 설정 
		document.list.action = "List.jsp";
		//<form>태그의 요청 전송 
		document.list.submit(); 
	}
	
	//글제목을 클릭했을때.. 수정할 글번호를 매개변수로 전달 받아 새로 생성하는 form태그 내부의 input태그의 value속성값으로 설정
	//설정후 form태그를 이용해 전송!
	function fnRead(num){
		
		document.read.num.value = num;
		document.read.submit();
		
	}
	
	
	
	
</script>
<body>
<div style ="text-align:center"><br>
<h2>JSP Board</h2>

<%-- 순서1. DB작업을 하기 위해 BoardDaoImpl객체 생성 --%>
<jsp:useBean id="dao" class="com.bean.board.BoardDaoImpl"/>

<%-- 순서2. 검색기준값과 검색어를 저장하기 위한 변수 선언 --%>
<%!
	String keyWord="",keyField = "";

	//[1]페이징 처리를 위한 변수 선언 
	int totalRecord = 0; //게시판에 저장된 전체 글의 개수 [2]
	int numPerPage = 5; //한페이지당 보여줄 글의 개수 
	int pagePerBlock = 3; //한블럭당 묶여질 페이지수 
	/* 
		pagePerBlock변수 설명 
			게시판 하단 부분에 보면      이전 3개 ◀ 1 2 3 4 5 ▶ 다음 3개가 있는데...
			◀ 또는 ▶를 클릭했을때.. 게시판에 글이 많을 경우 한 페이지씩 이동하는것은 매우 불편합니다.
			그럴때에는 여러페이지번호를 하나로 묶어서 블럭 단위로 이동하게 만드는 메뉴도 있을 것이다.
			여러페이지번호를 하나로 묶어서 ◀ 또는  ▶를 클릭했을때.. 좀 더 이동을 빠르게 하고 싶을때 사용하는 변수
			페이지번호 몇개를? 묶어서 한 블럭을 만들것인가? 한 블럭당 묶여질 페이지 개수를 저장할 변수이다.
	*/
	
	int totalPage = 0; 	//전체 페이지수 [4]
	int totalBlock = 0; //전체 블럭수 [9]
	int nowPage = 0; //현재 보여질 페이지 번호 저장 [7]
	int nowBlock = 0; //현재 보여지는 페이지가 속한 블럭번호 저장 [8]
	int beginPerPage = 0; //각 페이지의 시작 글번호를 얻어 저장[10]
	
	//--------------------------------------------[1]
	

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
	
	//추가4.
	//[처음으로] 링크를 클릭했을때.. (List.jsp를 재요청 했을때..)
	//<input>태그의 type속성값이 hidden으로 요청한 name=reload인 값이 존재 하면(재요청한 값이 존재 하면)
	if(request.getParameter("reload") != null){
		//만약 List.jsp페이지로 다시 요청받은 값이 true와 같을때..(재요청을 했다면)
		if(request.getParameter("reload").equals("true")){
			keyWord = ""; //입력한 검색어를 비우기 위해 빈문자열을 변수에 저장 
		}
	}
	

	//게시판 테이블에 저장되어 있는 글을 조회하기 위해 BoardDaoImpl객체의 getBoardList메소드 호출시..
	//선택한 검색기준값과, 입력한 검색어를 전달하여 SELECT작업을 진행함.
	//SELECT작업 후 검색된 글의 목록을 Vector배열에 담아 반환받습니다.
	Vector v = dao.getBoardList(keyField, keyWord);
	
	//[2] 게시판에 저장된 전체 글의 개수 구하기
	totalRecord = v.size();
	
	//[4] 전체페이지수 구하기 = 게시판에 저장된 전체 글의 갯수 / 한 페이지당 보여질 글의 갯수  
	//설명: 게시판에 저장된 전체 글의 수가? 26개라고 가정했을때...
	// 게시판의 전체 페이지수는? 한페이지당 만약 5개의 글만 보여지게 한다면...
	// 전체글개수(26)를 한페이지당 보여질 글 개수(5)로 나눈 몫-> 5페이지가 나오고 .. 나머지 1개글이 있으니
	// 나머지 1개 글을 나타내기 위해 1개의 페이지가 더 필요하므로 ... 총 6페이지가 나와야함.
	
	//(double)totalRecord/numPerPage; 계산하면 실수 값이 나올 것이다.
	//  	26.0 		/ 5  = 5.2가 나온다.
	// 1개의 페이지가 더 필요하므로 실수 5.2를 올림하여 6.0으로 만들어 준다.
	//Math클래스의 ceil메소드는 실수값을 넣으면 무조건 올림처리한다.
	// 5.2 -> 6.0 으로 만든 뒤 다시 int형으로 형변환 하여 6으로 만든 후 저장 
	totalPage = (int)Math.ceil((double)totalRecord/numPerPage);
	
	//[9]전체 블럭수 구하기 = 전체 페이지수 / 한 블럭당 묶여질 페이지 번호 개수 
	totalBlock = (int)Math.ceil((double) totalPage / pagePerBlock);
	
	//[7] 현재 보여질 페이지 번호 구하기 
	//설명 : 게시판 하단 부분에 보면 이전 3개 ◀  1 2 3 ▶ 다음 3개가 있는데...
	// 		1 2 3 중 하나의 페이지번호를 클릭하여 선택했을때 다시 ~~ List.jsp페이지를 재요청하면?
	// 		1 2 3 중 선택한 하나의 페이지 번호가 List.jsp페이지로 넘어오면서?
	// 		nowPage(현재 선택한 페이지 번호)를 얻는다.
	
	//만약 1 2 3 중 선택한 페이지 번호가 있을때만?	
	if(request.getParameter("nowPage") != null){
		// 1 2 3 중 현재 선택한 페이지 번호를 얻어 저장 
		nowPage = Integer.parseInt(request.getParameter("nowPage"));
	}
	
	//[8] 현재 보여지는 페이지가 속한 블럭 위치 번호 구하기 ( ◀ 1 2 3 ▶에서 ▶를 누른게 몇 번째 블럭으로 이동하는지 블럭위치구하기) 
	//만약  ▶를 클릭하여 전달받은 블럭 위치 번호가 존재할때만?
	if(request.getParameter("nowBlock") != null){
		
		//클릭한   ▶에 대한 그 다음에 위치한 블럭위치번호를 얻어 저장 
		nowBlock = Integer.parseInt(request.getParameter("nowBlock"));
				
	}
	
	//[10] 각페이지마다 가장 위쪽에 첫번째로 보여질 시작 글번호 구하기 
	//현재 보여질 페이지 번호 X 한 페이지당 보여질 글의 갯수 
	beginPerPage = nowPage * numPerPage;
	//위의 변수값을 구하는 이유 : 각 페이지마다 보여질 글들을 분할해서 보여주기 위해 구했음 
%>

<table align=center border=0 width=80%>
<tr>					<%--[3] 게시판에 저장된 전체 글 수  --%>
	<td align=left>Total : <%=totalRecord%> Articles(
		<%--[6]현재 보여지는 페이지번호 --%>		<%--[5] 전체페이지수  --%>
		<font color=red> <%=nowPage + 1 %> / <%=totalPage %>  Pages </font>)
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
				
			//[11] BoardDto객체의 정보들을 한 페이지마다 출력해준다.
			//예) 첫 번쨰로 보여질 글번호가 5라고 가정할때의 상황 
			// int cnt = 5; cnt < (5+5); cnt++ 이므로... 5, 4, 3, 2, 1번호를 가진 글이 출력된다.
			
					for(int cnt = beginPerPage; cnt <(beginPerPage+numPerPage); cnt++){
						
						//만약 cnt값이 총글의 갯수와 같아지면... 필요없는 반복은 끝내라 
						if(cnt == totalRecord){
							break;
						}
						
						
						BoardDto tmp = (BoardDto)v.get(cnt);
						int num = tmp.getNum();
						String subject = tmp.getSubject();
						String name = tmp.getName();
						Timestamp regdate = tmp.getRegdate();
						int count = tmp.getCount();
						String email = tmp.getEmail();
						//들여쓰기값 얻어 저장 
						int depth = tmp.getDepth();
					%>	
						<tr>
							<td> <%=num %> </td>
							<td>
								<%=dao.useDepth(depth) %>
								<%--게시판 글 리스트 중에서 글제목을 클릭했을때.. 함수 호출시 수정할 글번호를 전달하여 form태그를 실행 --%>
								<a href="Read.jsp" onclick="fnRead('<%=num%>'); return false;" >
								<%=subject %>
								</a> 
							</td>
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
	<td align="left">Go to Page 
		 
		
	
		<%
			//게시판에 글이 하나라도 존재하면?
			if(totalBlock > 0 ){
				//현재 블럭의 위치가 적어도 0보다 클때.. 이전으로 이동한 블럭이 있다는 뜻이므로 
				// ◀◀◀이전 링크를 나타내게 할 수 있음 
				if(nowBlock > 0){
		%>							 <%-- 이전 링크를 눌렀을때 이전 블럭이전위치번호와, 이전블럭위치번호에 해당되는 시작페이지 번호를 List.jsp로 요청함 --%>
				◀◀◀<a href="List.jsp?nowBlock=<%=nowBlock-1%>&nowPage=<%=(nowBlock-1)*pagePerBlock%>">
				이전<%=pagePerBlock%>개</a>
		
		<% 			
				}
			}
		
			//[12] 게시판 하단 페이지 번호 출력 하는 부분 
			// -> 한 블럭당 몇개의 페이지 번호를 묶어서 출력할 것인가 기준을 잡아야 하는데 ..
			// int pagePerBlock = 3 //한블럭당 묶여질 페이지 수를 위 변수에 저장해 놓았다.
			// 그러므로 한 블럭당 3개의 페이지번호를 묶는다고 보면 된다.
			// 1 2 3  <----- 0블럭 
			// 4 5 6 <------ 1블럭 
			// 7 8 9 <-------2블럭 
			//위와 같이 한 블럭당 3개의 페이지씩 출력하면 된다.
			
			//한블럭당 묶여질 페이지수만큼 반복하면서 페이지번호를 출력한다.
			for(int cnt=0; cnt <pagePerBlock; cnt++){	//3번반복
				
				//현재 보여질 페이지 번호가 전체 페이지개수와 같을때 3번 반복하지 않고 빠져나감
				if((nowBlock * pagePerBlock) + cnt == totalPage){
					break;
				}
		%>	
			<%--링크 걸어주기 : 페이지번호 중 하나를 선택했을때 
				현재 글목록이 보이는 블럭위치값, 현재 선택한 페이지 번호를 전달한다.
				실제 페이지의 위치0은 1페이지를 말한다.
			 --%>
			<a href="List.jsp?nowBlock=<%=nowBlock%>&nowPage=<%=(nowBlock*pagePerBlock)+cnt%>">
				<%-- 
						1 2 3 <--- 0블럭
					 3>
						4 5 6 <--- 1블럭 
					 3>	
						7 8 9 <--- 2블럭
						
					위그림과 같이 3> 이라는 간격은 블럭당 묶여질 페이지수를 뜻한다. 
					현재블럭 위치 * 한블럭당 묶여질 페이지수 계산하여 블럭번호는 0부터 시작하므로 
					1부터 시작하게 하기 위해 + 1을 해주고.. 1 페이지번호를 2페이지번호, 3페이지번호로 증가하기 위해 
					+cnt값을 for반복문을 돌면서 1씩 증가시켜서 구한다.
					
					
					(현재블럭위치 * 한 블럭당 묶여질 페이지수 ) + 1 + cnt 
					(0블럭   * 3페이지 				)  + 1  + 0 -> 1페이지번호가 나옴
					(0블럭  * 3페이지 				) + 1 + 1 -> 2페이지번호가 나옴 
					(0블럭  * 3페이지 				) + 1 + 2 -> 3페이지번호가 나옴 
					
					그러므로 for반복하면서 1 2 3 페이지번호가 화면에 출력됨.
				--%>
				
				
				
				<%=(nowBlock * pagePerBlock) + 1 + cnt %>
				
				<%--http://localhost:8090/BoardApp/board/v2/List.jsp?nowBlock=0 테스트하기  --%>
			</a>
			 
			 
			 
			 
			 
			 
		<% 	
/* 
	 	하나의 블럭당 1p 2p 3p .... 4p 5p 6p 페이지를 블럭단위로 묶을 수 있는데...
	 	총글의 갯수를 생각 해 본다면... 마지막 하나의 블럭에는 글의 갯구에 따라 7p와 같이 
	 	1개의 페이지번호만 한 블럭으로 묶여 질 수도 있다.
	 	
 */	 		if(((nowBlock*pagePerBlock) + 1 + cnt) == totalRecord){//마지막글 만큼 왔을 경우 위와 같이 for문에서 3번 반복하지 않아도 되므로 
	 			//(총글의 갯수) == 게시판에 저장된 전체 글의 갯수와 같다면?
	 			break;
 			}
	 	
		
		
		
		
			}//for
		%>
		
				 
				<% 	
				//이동할 블럭이 존재하면 >>> 다음 3개 표시 
				if(totalBlock > nowBlock + 1){
				%>	
					<%-- 다음 3개 링크를 눌렀을때 그 다음 블럭위치번호와 , 
					그 다음 블럭에 속한 첫번째페이지의 번호를 List.jsp로 전달함. --%>
					▶▶▶
					<a href="List.jsp?nowBlock=<%=nowBlock+1%>&nowPage=<%=(nowBlock+1)*pagePerBlock%>">
						다음<%=pagePerBlock%>개
					
					</a>
				<% 
				}//if
				%>
			
		
	
	
	</td>
	
	<td align=right>
		<a href="Post.jsp">[글쓰기]</a>
		
		<%--추가1. --%>
		<a href="#" onclick="fnList(); return false;" >[처음으로]</a>
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
</div>	


<%--추가3. 현재 List.jsp페이지가 리로드 하는지 않하는지 구별 하기 위한 true값을 다시 List.jsp에 요청함 --%>
<form name="list" method="post">
	<input type="hidden" name="reload" value="true"/>
</form>

<%--게시판 글리스트 정보 중 글제목을 클릭했을때..
	Read.jsp로 선택한 글번호, 글을 선택하기 위해 검색한 검색 기준값, 글을 선택하기 위해 검색한 검색어값을 전달함.
	 --%>

<form action="Read.jsp" name="read" method="post">

	<input type ="hidden" name="num"> <%--수정할 글번호 전달 --%>
	<input type ="hidden" name="keyField" value="<%=keyField%>"/>
	<input type="hidden" name="keyWord" value="<%=keyWord %>"/>
	
</form>
	 
	 
	 

</body>
</html>