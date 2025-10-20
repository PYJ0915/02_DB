-- 한 줄 주석

/*
 * 
 * 범위 주석
 * 
 */

-- SQL (Structured Query Language, 구조적 질의 언어)
-- 데이터 베이스와 상호작용을 하기 위해 사용하는 표준 언어
-- 데이터의 조회, 삽입, 수정 등의 명령을 SQL로서 내릴 수 있다


-- 선택한 SQL 수행 : 구문에 커서 올리고 CTRL + ENTER
-- 전체 SQL 수행 : ALT + X

-- 11G 이전 문법 사용 허용
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-- 새로운 사용자 계정 (sys : 최고 관리자 계정)
CREATE USER kh_pyj IDENTIFIED BY kh1234;
-- 계정 생성 구문 (kh_pyj : USERNAME / kh1234 : PASSWORD)
-- ORA-65096: 공통 사용자 또는 롤 이름이 부적합합니다.
-- ORA-01920: 사용자명 'KH_PYJ'(이)가 다른 사용자나 롤 이름과 상충됩니다.

-- 사용자 계정에 권한 부여 설정
GRANT RESOURCE, CONNECT TO kh_pyj;
-- RESOURCE : 테이블이나 인덱스 같은 DB 객체를 생성할 수 있는 권한
-- CONNECT : DB에 연결하고 로그인할 수 있는 권한

-- 객체가 생성될 수 있는 공간 할당량 무제한 지정
ALTER USER kh_pyj DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;

CREATE USER workbook IDENTIFIED BY workbook;
GRANT RESOURCE, CONNECT TO workbook;
ALTER USER workbook DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;
