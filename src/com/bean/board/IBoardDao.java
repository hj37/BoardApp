package com.bean.board;

import java.util.Vector;

/*Dao클래스는 DB작업을 할 클래스입니다.
Dao클래스를 만들때 팀프로젝트를 한다면...
철수는 자유게시판을 만들고, 영희는 취업게시판을 만든다고 가정할때 
각각의 자유게시판에도 글을 읽어오는 기능이 있고,
취업게시판에도 글을 읽어오는 기능이 있다고 가정할때..
위 2개의 게시판은 똑같은 글을 읽어오는 기능을 합니다.
문제점 : 똑같은 글을 읽어오는 기능의 메소드를 만든다고 할때..
각각 메소드의 이름을 달리해서 만들어주면 팀원끼리 혼란이 올것이다.
그래서.. 하나의 메소드의 이름을 정해서 (원칙을 정해서) 사용한다면 
메소드르 찾아보기도 쉽고 유지보수도 편리 할것입니다.
결론 : 어떠한 기준(원칙)을 정해 줄 수 있게 하는 것이 인터페이스입니다.

*/


public interface IBoardDao {
//추상메소드의 이름(규칙)을 정해놓은 인터페이스 만들기
	
	//DB에 저장된 전체 글을 검색해 주기 위한 추상메소드(틀) 
	public Vector getBoardList(String keyField,String keyWord);	//검색기준값, 검색어
	//DB에 새글을 추가 시키기 위한 추상메소드(틀) 
	public void insertBoard(BoardDto dto);
	//DB에 저장된 하나의 글을 수정시키기 위한 기능의 추상메소드(틀) 
	public void updateBoard(BoardDto dto);
	//DB에 저장된 하나의 글을 삭제 시키기 위한 기능의 추상메소드(틀) 
	public void deleteBoard(int num);
	//게시판의 전체 글중 하나의 글을 검색하기 위한 기능의 추상메소드(틀) 
	public BoardDto getBoard(int num);
	
	//답변 글 달기 기능의 추상메소드(틀) 
	public void replyBoard(BoardDto dto);
}
