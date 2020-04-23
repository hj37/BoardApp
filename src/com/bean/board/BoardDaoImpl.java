package com.bean.board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

//DB작업관련 클래스

public class BoardDaoImpl implements IBoardDao{
	//메소드 오버리이딩 단축키
	//alt + shift + s v
	
	//DB작업 관련 객체들을 저장할 변수 선언 
	private DataSource ds; //커넥션풀 역할을 하는 객체를 저장할 변수
	private Connection con; //DB연결 정보를 가지고 있는 객체를 저장할 변수 
	private PreparedStatement pstmt; //SQL문을 DB에 전송하여 실행할 실행객체를 저장할 변수 
	private ResultSet rs; //DB로부터 검색한 레코드정보를 임시로 저장 해놓을 객체를 저장한 변수 
	
	//생성자 : 커넥션풀 역할을 하는 객체를 얻는 생성자
	public BoardDaoImpl() {
		try {
			//1.WAS서버와 연결된 BoardApp웹프로젝트의 모든 정보를 가지고 있는 컨텍스트 객체 생성
			Context init = new InitialContext();
			
			//2.연결된 WAS서버에서 DataSource(커넥션풀)을 검색해서 가져오기 
			ds = (DataSource)init.lookup("java:comp/env/jdbc/jspbeginner");		//Contex.xml에서 이름 같은걸로 가져와야함 
			
			
		} catch (Exception e) {
			System.out.println("커넥션풀 DataSource얻기 실패 : " + e);
		}
	}//생성자 끝
	
	//자원 해제(리소스 반납)메소드
	public void freeResource() {
		if(con != null) {try {con.close();} catch (SQLException e) {e.printStackTrace();}}
		if(rs != null) {try {rs.close();} catch (SQLException e) {e.printStackTrace();}}
		if(pstmt != null) {try {pstmt.close();} catch (SQLException e) {e.printStackTrace();}}
	
	}
	
	
	//DB의 테이블에 저장되어 있는 글들을 검색해서 가져오기 위한 메소드
	//List.jsp페이지에서 사용하는 메소드
	@Override
	public Vector getBoardList(String keyField, String keyWord) {//검색기준값, 검색어를 전달받음
		
		Vector v = new Vector();
			
		String sql = "";
		
		try {
			//1.DataSource커넥션풀로부터 Connection얻기(DB연결) 
			con = ds.getConnection();
			//2 조건에 따라 입력
			//검색어를 입력하지 않았다면?
			if(keyWord == null || keyField.isEmpty()) {
				
				//가장 최신 글이 위로 오게 num필드값을 기준으로 하여 내림차순 정렬 하여 전체 글목록 검색 
				//SQL만들기
				sql = "select * from tblBoard order by num desc";

			//검색어를 입력 했다면?
			}else {
				
				sql = "select * from tblBoard where " + keyField
						+ " like '%" + keyWord + "%' order by num desc";
			}
			//3.SQL문을 실행할 객체 얻기
			pstmt = con.prepareStatement(sql);
			
			//4.위 SQL문 실행
			rs = pstmt.executeQuery();
			
			//5. 검색한 결과 글정보들을 ResultSet객체에서 꺼내와서 BoardDto객체에 저장 
			while(rs.next()) {
				
				BoardDto dto = new BoardDto();	//검색한 글정보 한 줄 단위로 저장할 용도
				//ResultSet객체에서 꺼내와서 dto저장 
				dto.setContent(rs.getString("content"));
				dto.setCount(rs.getInt("count"));
				dto.setDepth(rs.getInt("depth"));
				dto.setEmail(rs.getString("email"));
				dto.setHomepage(rs.getString("homepage"));
				dto.setIp(rs.getString("ip"));
				dto.setName(rs.getString("name"));
				dto.setPass(rs.getString("pass"));
				dto.setNum(rs.getInt("num"));
				dto.setSubject(rs.getString("subject"));
				dto.setPos(rs.getInt("pos"));
				dto.setRegdate(rs.getTimestamp("regdate"));
				
				v.add(dto);
				
			}//while문
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.out.println("getBoardList메소드 내부에서 오류 : " + e);
		}finally {
			freeResource();
		}
		
		return v;	//jspbeginner데이터베이스의 tblBoard테이블에 저장된 모든 글을 검색해서 가져와서
					//각각 BoardDto객체에 저장 후 모든 BoardDto객체들을 담고 있는 Vector리턴
	}//getBoardList메소드 끝 

	//DB에 새글을 추가 시키는 메소드
	//-> PostProc.jsp페이지에서 호출하는 메소드로.. 사용자가 입력한 새글 정보를 BoardDto객체에 저장후 
	//  insertBoard메소드 호출 시 인자로 전달받는다.
	@Override
	public void insertBoard(BoardDto dto) {
		try {
			//1. 커넥션풀(DataSource)로부터 커넥션(Connection)얻기
			con = ds.getConnection(); //DB연결
			//2. SQL 구문 만들기 (insert구문 만들기) 
			String sql ="insert into tblBoard(name,email,homepage,subject,"
					+ "content,regdate,pass,count,ip,pos,depth)"
					+ "values(?,?,?,?,?,?,?,0,?,0,0);";	//count -> 0, pos -> 0 ,depth ->0 
			//3.위 insert문장(SQL구문)을 DB에 전달하여 실행할 객체(PreparedStatement)얻기 
			// ? 기호에 대응되는 추가할 글에 대한 정보를 제외한 나머지 insert문장을 ProparedStatement에 저장 후 반환
			pstmt = con.prepareStatement(sql);
			
			//4. ? 기호에 대응되는 추가한 글에 대한 정보를 BoardDto객체의 각변수값을 얻어 설정!
			pstmt.setString(1,dto.getName());	//첫번째 ? 기호에 대응되는 insert할 값을 
												//BoardDto객체의 name변수값으로 설정
			
			pstmt.setString(2,dto.getEmail());	//두번째 ? 기호에 대응되는 insert할 값을 
												//BoardDto객체의 email변수값을 얻어 설정 
			
			pstmt.setString(3,dto.getHomepage()); // 세번째 ? homepage
			
			
			pstmt.setString(4,dto.getSubject());	//네번째? subject
			
			pstmt.setString(5,dto.getContent());	//다섯번째 ? content
			
			pstmt.setTimestamp(6, dto.getRegdate());	//여섯번째? regdate
			
			pstmt.setString(7, dto.getPass());	//일곱번째? pass
			
			pstmt.setString(8, dto.getIp()); //여덟번째 ? ip 
			
			
			//5. DB에 insert구문을 전달하여 실행!
			pstmt.executeUpdate();
			
			
			
		} catch (Exception e) {
			System.out.println("insertBoard메소드 내부에서 오류: " + e);
		}finally {
			//6. 자원해제 
			freeResource();
		}
		
		
		
	}

	@Override
	public void updateBoard(BoardDto dto) {
		// TODO Auto-generated method stub
		
		try {
			//커넥션풀로 커넥션 얻기(DB접속) 
			con = ds.getConnection(); //DB연결
			String sql = "update tblBoard set name = ?,email = ?, subject = ?, content = ? where num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getEmail());
			pstmt.setString(3, dto.getSubject());
			pstmt.setString(4, dto.getContent());
			pstmt.setInt(5,dto.getNum());
			//UPDATE구문 실행 
			pstmt.executeUpdate();

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println("updateBoard메소드 내부에서 오류 : " + e);

		}finally {
			freeResource();
		}
		
		
	}
	
	//UpdateProc.jsp에서 호출하는 메소드로 글 수정시 입력했던 정보들은 모두 BoardDto객체의 각 변수에 저장되어 있다.
	//그 BoardDto객체를 매개변수로 전달받아... UPDATE구문 만들자 
	public int updateBoard1(BoardDto dto) {
			int result = 0;
		try {
			//커넥션풀로 커넥션 얻기(DB연결객체얻기) 
			con = ds.getConnection(); //DB연결
			//매개변수로 전달받는 우리가 글 수정시 입력한 정보들을 담고 있는 BoardDto객체의 num변수에 해당되는 
			//글의 정보 중.. 글쓴이, 글을 작성한 사람의 이메일 주소, 글제목, 글내용을 UPDATE 수정 해라~
			//UPDATE구문 작성 		
			//"UPDATE 테이블명 SET 컬럼명 = 컬럼값, 컬럼명 = 컬럼값 WHERE 조건 
			String sql = "update tblBoard set name = ?,email = ?, subject = ?, content = ? where num = ?";
			pstmt = con.prepareStatement(sql);
			//?기호에 대응되는 수정할 값을 BoardDto객체의 각 변수값으로 설정
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getEmail());
			pstmt.setString(3, dto.getSubject());
			pstmt.setString(4, dto.getContent());
			pstmt.setInt(5,dto.getNum());
			//UPDATE구문 실행 후  
			result = pstmt.executeUpdate();	//수정에 성공한 레코드 개수를 반환함 반환값이 1또는 0임 

		} catch (Exception e) {
			// TODO: handle exception
			System.out.println("updateBoard메소드 내부에서 오류 : " + e);

		}finally {
			//자원해제 
			freeResource();
		}
	
		
		return result;	//UpdateProc.jsp로 수정에 성공하면 1을 반환 실패하면 0을 반환
	}
	
	

	@Override
	public void deleteBoard(int num) {
		// TODO Auto-generated method stub
		
	}

	
	//글번호를 매개변수로 전달받아.. 글번호에 해당하는 글하나의 정보를 검색하기 위한 메소드
	//글조회수 1증가 시키는 메소드
	@Override
	public BoardDto getBoard(int num) {
			

		//매개변수로 전달 받은 글 번호에 해당하는 글을 검색해서 저장할 BoardDto객체 생성
		BoardDto dto = new BoardDto();
		try {
			//커넥션풀로 커넥션 얻기(DB접속) 
			con = ds.getConnection(); //DB연결
			//글을 조회했을때.. 매개변수로 전달 받는 글번호에 해당하는  글조회수 1증가 시키는 UPDATE 구문 만들기
			String sql  = "update tblBoard set count = count+1 where num = ?";
			//?기호 해당되는 값을 제외한 나머지 UPDATE문장을 저장한? PreparedStatement실행 객체 얻기
			pstmt = con.prepareStatement(sql);
			//?기호 해당되는 글번호를 설정
			pstmt.setInt(1,num);
			//UPDATE구문 실행 
			pstmt.executeUpdate();
			//매개변수로 전달 받은 글번호에 해당 되는 글 하나의 정보를 검색하는 SELECT구문 만들기 
			sql = "select * from tblBoard where num = ?";	
			//?기호 해당되는 값을 제외한 나머지 SELECT문장을 저장한? PreparedStatement실행 객체 얻기
			pstmt = con.prepareStatement(sql);
			//?기호에 해당되는 글번호를 설정
			pstmt.setInt(1, num);
			//SELECT구문 실행한 후 검색된 글 하나의 정보를 ResultSet에 저장 후 반환 받기
			rs = pstmt.executeQuery();
			
			//ResultSet임시 저장소에 검색한 데이터(글 하나의 정보)가 존재하면?
			if(rs.next()) {
				//ResultSet에서 검색한 글의 정보들을 꺼내와서 BoardDto객체의 각 변수에 저장  
				dto.setContent(rs.getString("content"));
				dto.setCount(rs.getInt("count")); //검색한 글에 대한 글 조회수
				dto.setDepth(rs.getInt("depth"));	//검색한 글의 그룹 값 
				dto.setEmail(rs.getString("email"));	//검색한 글의 이메일주소정보
				dto.setHomepage(rs.getString("homepage"));	//검색한 글의 정보 중 작성자 홈페이지 주소정보
				dto.setIp(rs.getString("ip"));	//검색한 글의 정보 중 작성자의 ip주소 정보
				dto.setName(rs.getString("name"));	//검색한 글의 정보 중 작성자이름
				dto.setPass(rs.getString("pass"));	//검색한 글 의 정보 중 글의 비밀번호
				dto.setNum(rs.getInt("num")); //검색한 글의 글번호
				dto.setSubject(rs.getString("subject"));	//검색한 글의 제목 
				dto.setPos(rs.getInt("pos"));	//검색한 글의 정보 중 글의 들여쓰기 정도값
				dto.setRegdate(rs.getTimestamp("regdate"));	//검색한 글의 정보 중 글을 작성한 날짜
				dto.setSubject(rs.getString("subject"));	//검색한 글의 글제목 
			}
			
		} catch (Exception e) {
			
			System.out.println("getBoard메소드 내부에서 오류 : " + e);
			
		}finally {
			//자원해제
			freeResource();
		}
		
		return dto;	//DB로부터 검색한 하나의 글정보를 BoardDto객체에 저장 후 Read.jsp로 반환

	}//getBoard메소드
	
	
	//글 하나의 정보를 검색하여 글정보를 제공해주는 메소드 
	public BoardDto getBoardInfo(int num) {
			

		//매개변수로 전달 받은 글 번호에 해당하는 글을 검색해서 저장할 BoardDto객체 생성
		BoardDto dto = new BoardDto();
		try {
			//커넥션풀로 커넥션 얻기(DB접속) 
			con = ds.getConnection(); //DB연결
			
			//매개변수로 전달 받은 글번호에 해당 되는 글 하나의 정보를 검색하는 SELECT구문 만들기 
			String sql = "select * from tblBoard where num = ?";	
			//?기호 해당되는 값을 제외한 나머지 SELECT문장을 저장한? PreparedStatement실행 객체 얻기
			pstmt = con.prepareStatement(sql);
			//?기호에 해당되는 글번호를 설정
			pstmt.setInt(1, num);
			//SELECT구문 실행한 후 검색된 글 하나의 정보를 ResultSet에 저장 후 반환 받기
			rs = pstmt.executeQuery();
			
			//ResultSet임시 저장소에 검색한 데이터(글 하나의 정보)가 존재하면?
			if(rs.next()) {
				//ResultSet에서 검색한 글의 정보들을 꺼내와서 BoardDto객체의 각 변수에 저장  
				dto.setContent(rs.getString("content"));
				dto.setCount(rs.getInt("count")); //검색한 글에 대한 글 조회수
				dto.setDepth(rs.getInt("depth"));	//검색한 글의 그룹 값 
				dto.setEmail(rs.getString("email"));	//검색한 글의 이메일주소정보
				dto.setHomepage(rs.getString("homepage"));	//검색한 글의 정보 중 작성자 홈페이지 주소정보
				dto.setIp(rs.getString("ip"));	//검색한 글의 정보 중 작성자의 ip주소 정보
				dto.setName(rs.getString("name"));	//검색한 글의 정보 중 작성자이름
				dto.setPass(rs.getString("pass"));	//검색한 글 의 정보 중 글의 비밀번호
				dto.setNum(rs.getInt("num")); //검색한 글의 글번호
				dto.setSubject(rs.getString("subject"));	//검색한 글의 제목 
				dto.setPos(rs.getInt("pos"));	//검색한 글의 정보 중 글의 들여쓰기 정도값
				dto.setRegdate(rs.getTimestamp("regdate"));	//검색한 글의 정보 중 글을 작성한 날짜
				dto.setSubject(rs.getString("subject"));	//검색한 글의 글제목 
			}
			
		} catch (Exception e) {
			
			System.out.println("getBoard메소드 내부에서 오류 : " + e);
			
		}finally {
			//자원해제
			freeResource();
		}
		
		return dto;	//DB로부터 검색한 하나의 글정보를 BoardDto객체에 저장 후 Update.jsp로 반환

	}//getBoardInfo(int num)메소드

	@Override
	public void replyBoard(BoardDto dto) {
		// TODO Auto-generated method stub
		
	}
	
	
}
