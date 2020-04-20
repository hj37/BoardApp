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

	@Override
	public void insertBoard(BoardDto dto) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateBoard(BoardDto dto) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteBoard(int num) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public BoardDto getBoard(int num) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void replyBoard(BoardDto dto) {
		// TODO Auto-generated method stub
		
	}
	
	
}
