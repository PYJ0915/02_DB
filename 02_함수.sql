-- 함수 : 컬럼의 값을 읽어서 연산을 한 결과를 반환

-- 단일 행 함수 : N개의 값을 읽어서 연산 후 N개의 결과를 반환
-- 그룹 함수 : N개의 값을 읽어서 연산 후 1개의 결과를 반환 (합계, 평균, 최대/최소)

-- 함수는 SELECT 문의 
-- SELECT절, WHERE절, ORDER BY절, GROUP BY절, HAVING절에서 사용 가능


-------------------------- 단일 행 함수 ---------------------------------

-- LENGTH(컬럼명 | 문자열) : 길이 반환

-- EMPLOYEE 테이블에서 모든 사원의 EMAIL, EMAIL의 길이를 조회

SELECT EMAIL, LENGTH(EMAIL) FROM EMPLOYEE;

----------------------------------------------------------------------

-- INSTR(컬럼명 | 문자열, '찾을 문자열' [, 찾기 시작할 위치] [, 순번])
-- 지정한 위치부터 지정한 순번 째로 검색되는 문자의 위치를 반환

-- 문자열을 앞에서부터 검색하여 첫번째 B위치 조회
-- AABAACAABBAA
SELECT INSTR('AABAACAABBA', 'B') "첫번 째 B" FROM DUAL -- 3

-- 문자열을 5번째 문자부터 검색하여 처음으로 검색되는 B 위치 조회
SELECT INSTR('AABAACAABBAA', 'B', 5) "B 찾기" FROM DUAL -- 9

-- 문자열을 5번째 문자부터 검색하여 두 번째로 검색되는 B 위치 조회
SELECT INSTR('AABAACAABBAA', 'B', 5, 2) "B 찾기" FROM DUAL -- 10

-- EMPLOYEE 테이블에서 사원명, 이메일, 이메일 중 '@'의 위치 조회
SELECT EMP_NAME, EMAIL, INSTR(EMAIL, '@') "골뱅이 위치" FROM EMPLOYEE;

----------------------------------------------------------------------

-- SUBSTR(컬럼명 | '문자열', 잘라내기 시작할 위치 [, 잘라낼 길이])
-- 컬럼이나 문자열에서 지정한 위치부터 지정한 길이만큼 문자열을 잘라내어 반환
--> 잘라낼 길이 생략 시, 끝까지 잘라냄

-- EMPLOYEE 테이블에서 사원명, 이메일 중 아이디 부분만 조회
SELECT EMP_NAME, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') - 1) ID FROM EMPLOYEE;  

----------------------------------------------------------------------

-- TRIM([옵션][문자열 | 컬럼명 FROM] 컬럼명 | 문자열)
-- 주어진 컬럼이나 문자열의 앞, 뒤, 양쪽에 있는 지정된 문자를 제거
--> 양쪽 공백 제거에 많이 사용함

-- [옵션] : LEADING(앞쪽), TRAILING(뒤쪽), BOTH(양쪽, 기본값)

SELECT TRIM('           H E L L O              ') FROM DUAL -- H E L L O

-- ####안녕####
SELECT TRIM(TRAILING '#' FROM '####안녕####') "뒤 쪽 # 제거" FROM DUAL;

-------------------------------------------------------------------------

-- 숫자 관련 함수

-- ABS(숫자 | 컬럼명) : 절댓값
SELECT ABS(-10) FROM DUAL;

SELECT '절댓값 같음' FROM DUAL WHERE ABS(10) = ABS(-10); -- WHERE절에서도 함수 가능!

-- MOD(숫자 | 컬럼명, 숫자 | 컬럼명) : 나머지 값 반환
-- EMPLOYEE 테이블에서 사원의 월급을 100만으로 나누었을 때 나머지 값 조회

SELECT EMP_NAME, SALARY, MOD(SALARY, 1000000) "100만으로 나눈 나머지" FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사번이 짝수인 사원의 사번, 이름 조회

SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE MOD(EMP_ID, 2) <> 0; -- 홀수 사번

-- ROUND(숫자 | 컬럼명, [, 소수점 위치]) : 반올림
-- 소수점 위치 미작성 시, 첫번째 자리에서 반올림
SELECT ROUND(123.456) FROM DUAL; -- 123
SELECT ROUND(123.456, 1) FROM DUAL; -- 123.5
-- 소수점 두번째 자리에서 반올림하여 소수점 첫번째 자리까지 표기하겠다

-- CEIL(숫자 | 컬럼명) : 올림
-- FLOOR(숫자 | 컬럼명) : 내림
--> 둘 다 소숫점 첫째 자리에서 올림/내림 처리
SELECT CEIL(123.1) FROM DUAL; -- 124
SELECT FLOOR(123.1) FROM DUAL; -- 123

-- TRUNC(숫자 | 컬럼명 [, 위치]) : 특정 위치 아래를 절삭
SELECT TRUNC(123.456) FROM DUAL; -- 소숫점 아래를 절삭(기본값)
SELECT TRUNC(123.456, 1) FROM DUAL; 

-------------------------------------------------------------------------------

-- 날짜(DATE) 관련 함수

-- SYSDATE : 시스템 상의 현재 시간(년, 월, 일, 시, 분, 초)을 반환
SELECT SYSDATE FROM DUAL; -- 2025-10-20 09:15:02.000

-- STSTIMESTAMP : SYSDATE + MS 단위 추가(UTC 정보)
SELECT SYSTIMESTAMP FROM DUAL; -- 2025-10-20 09:16:10.765 +0900

-- MONTHS_BETWEEN(날짜, 날짜) : 두 날짜의 개월 수 차이를 반환
SELECT ABS(ROUND(MONTHS_BETWEEN(SYSDATE, '2026-02-27'), 1)) "수강 기간(개월)" FROM DUAL; -- 4.2
-- 함수 안에 함수도 가능!

-- EMPLOYEE 테이블에서 사원의 이름, 입사일, 근무한 개월 수, 근무 년차 조회
SELECT EMP_NAME, HIRE_DATE, 
CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월' "근무한 개월 수", 
CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) || '년차' "근속 연수" 
FROM EMPLOYEE;
-- || : 연결 연산자

-- ADD_MONTHS(날짜, 숫자) : 날짜에 숫자만큼의 개월 수 더함. (음수도 가능)
SELECT ADD_MONTHS(SYSDATE, 4) FROM DUAL; -- 2026-02-20 09:30:22.000
SELECT ADD_MONTHS(SYSDATE, -1) FROM DUAL; -- 2025-09-20 09:30:47.000

-- LAST_DAY(날짜) : 해당 달의 마지막 날짜 구함
SELECT LAST_DAY(SYSDATE) FROM DUAL; -- 2025-10-31 09:33:25.000
SELECT LAST_DAY('2020-02-01') FROM DUAL; -- 2025-10-31 09:33:25.000
-- 문자열 형태로 날짜를 전달해도 자동으로 형변한 해줌!

-- EXTRACT(YEAR | MONTH | DAY FROM 날짜) : 년, 월, 일 정보를 추출하여 반환

-- EMPLOYEE 테이블에서 각 사원의 이름, 입사일 조회(입사년도, 월, 일)
-- 2010년 10월 10일
SELECT HIRE_DATE FROM EMPLOYEE; -- 1990-02-06 00:00:00.000
SELECT EMP_NAME, 
EXTRACT(YEAR FROM HIRE_DATE) || '년 ' || 
EXTRACT(MONTH FROM HIRE_DATE) || '월 ' || 
EXTRACT(DAY FROM HIRE_DATE) || '일' AS 입사일
FROM EMPLOYEE;

-------------------------------------------------------------------------------

-- 형변환 함수
-- 문자열(CHAR), 숫자(NUMBER), 날짜(DATE)끼리 형변환 가능

-- 문자열로 변환
-- TO_CHAR(날짜 | 숫자 [포맷]) : 날짜 | 숫자형 데이터를 문자형 데이터로 변경

-- 숫자 -> 문자 변환 시 포맷 패턴
-- 9 : 숫자 한 칸을 의미, 여러 개 작성 시 오른쪽 정렬
-- 0 : 숫자 한 칸을 의미, 여러 개 작성 시 오른쪽 정렬 + 빈칸 0 추가
-- L : 현재 DB에 설정된 나라의 화폐 기호

SELECT TO_CHAR(1234) FROM DUAL; -- '1234'
SELECT TO_CHAR(1234, '99999') FROM DUAL; -- ' 1234' => 5칸 확보 후 한 칸 비워두고 오른쪽 정렬
SELECT TO_CHAR(1234, '00000') FROM DUAL; -- '01234' => 5칸 확보 후 빈 칸 0으로 채움
SELECT 1234 FROM DUAL; -- 1,234

SELECT TO_CHAR(1000000, '9,999,999') || '원' FROM DUAL; -- 1,000,000원
SELECT TO_CHAR(1000000, 'L9,999,999') FROM DUAL; -- ￦1,000,000

-- 날짜 -> 문자 변환 시 포맷 패턴
-- YYYY 년도 / YY : 년도(짧게) / MM : 월 / DD : 일
-- AM 또는 PM : 오전/오후 표시 / HH : 시간 / HH24 : 24시간 표기법
-- MI : 분 / SS: 초 / DAY : 요일(전체) / DY : 요일(요일명만 표시)

-- 2025/10/20 10:06:30 월요일
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD/HH24:MI:SS DAY') FROM DUAL;

-- 10/2O (월)
SELECT TO_CHAR(SYSDATE, 'MM/DD (DY)') FROM DUAL;

-- 2025년 10월 20일 (월)
SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" (DY)') FROM DUAL;
-- ORA-01821: 날짜 형식이 부적합합니다 => 쌍따옴표를 이용하여 단순한 문자로 인식시키면 해결 완료

-----------------------------------------------------------------------------------

-- 날짜 형태로 변환 TO_DATE

-- TO_DATE(문자, [포맷]) : 문자형 -> 날짜로 변경
-- TO_DATE(숫자, [포맷]) : 숫자형 -> 날짜로 변경
--> 지정된 포맷으로 날짜를 인식함

SELECT TO_DATE('2025-10-20') FROM DUAL; -- 2025-10-20 00:00:00.000
SELECT TO_DATE(20251020) FROM DUAL; -- 2025-10-20 00:00:00.000

SELECT TO_DATE('251020 101730') FROM DUAL; 
-- ORA-01861: 리터럴이 형식 문자열과 일치하지 않음
-- => 패턴을 적용해서 작성된 문자열의 각 문자가 어떤 날짜 형식인지 인식시킴

SELECT TO_DATE('251020 101730', 'YYMMDD HH24MISS') FROM DUAL; -- 2025-10-20 10:17:30.000

-- Y 패턴 : 현재 세기(21세기 == 20XX 년도 == 2000년대)
-- R 패턴 : 1세기 기준으로 절반(50년) 이상인 경우 이전 세기(1900년대) 절반 미만인 경우 현재 세기(2000년대)

SELECT TO_DATE('800505', 'YYMMDD') FROM DUAL; -- 2080-05-05 00:00:00.000
SELECT TO_DATE('800505', 'RRMMDD') FROM DUAL; -- 1980-05-05 00:00:00.000
SELECT TO_DATE('490505', 'RRMMDD') FROM DUAL; -- 2049-05-05 00:00:00.000

-- EMPLOYEE 테이블에서 각 직원이 태어난 생년월일 조회

SELECT * FROM EMPLOYEE;

-- 1) 주민번호(EMP_NO)에서 - 앞 글자까지 추출
SELECT EMP_NAME, 
SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') -1 ) AS "생년월일"
FROM EMPLOYEE; --621231

-- 2) 추출된 생년월일을 TO_DATE 타입으로 변경 => RR패턴을 이용하여 1900년도로 변환
SELECT EMP_NAME, 
TO_DATE(SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') -1 ), 'RRMMDD')
AS "생년월일"
FROM EMPLOYEE;

-- 3) TO_CHAR를 이용해서 문자열 변환 => 1962년 12월 31일
SELECT EMP_NAME, 
TO_CHAR(TO_DATE(SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') -1 ), 'RRMMDD'), 'YYYY"년" MM"월" DD"일"')
AS "생년월일"
FROM EMPLOYEE;

----------------------------------------------------------------------------------------------------

-- 숫자 형변환
-- TO_NUMBER(문자데이터, [포멧]) : 문자형 데이터를 숫자 데이터로 변경
-- 날짜 데이터를 숫자형으로 변경 원할 시 
-- => TO_CHAR(날짜)를 이용하여 문자형으로 변경 후 TO_NUBER(문자)를 이용하여 숫자로 변경

SELECT '1,000,000' + 500000 FROM DUAL;
-- ORA-01722: 수치가 부적합합니다 =>',' 때문에 완전한 문자열로 인식!

SELECT TO_NUMBER('1,000,000', '9,999,999') + 500000 FROM DUAL;

----------------------------------------------------------------------------------------------------

-- NULL 처리 함수

-- NVL(컬럼명, 컬럼값이 NULL일 때 바꿀 값) : NULL인 컬럼값을 다른 값으로 변경

-- NULL과 산술연산을 진행하면 무조건 결과가 NULL
SELECT EMP_NAME, SALARY, NVL(BONUS, 0), SALARY * NVL(BONUS, 0) FROM EMPLOYEE;

-- NVL2(컬럼명, 바꿀 값1, 바꿀 값2) : 해당 컬럼의 값이 있으면 바꿀 값1 변경, NULL이라면 바꿀 값2

-- EMPLOYEE 테이블에서 보너스를 받으면 'O', 받지 않으면 'X' 조회
SELECT EMP_NAME, NVL2(BONUS, 'O', 'X') "보너스 수령 여부" FROM EMPLOYEE;

----------------------------------------------------------------------------------------------------

-- 선택함수 : 여러가지 경우에 따라 알맞은 결과를 선택할 수 있는 함수

-- DECODE(계산식 | 컬럼명, 조건값1, 선택값1, 조건값2, 선택값2, ..., 아무것도 일치하지 않을 때)
-- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과값 반환

-- 직원의 성별 구하기
SELECT EMP_NAME, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남성', '2', '여성') 성별 FROM EMPLOYEE;

-- 직원의 급여를 인상하려고 한다!
-- 직급 코드가 J7인 직원은 20% 인상
-- 직급 코드가 J6인 직원은 15% 인상
-- 직급 코드가 J5인 직원은 10% 인상
-- 그외 직급은 5% 인상
-- 이름, 직급코드, 급여, 안상률, 인상된 급여를 조회

SELECT EMP_NAME, JOB_CODE, SALARY,
DECODE(JOB_CODE, 'J7', '20%', 'J6', '15%', 'J5', '10%', '5%') "인상율", 
DECODE(JOB_CODE, 'J7', SALARY * 1.2, 'J6', SALARY * 1.15, 'J5', SALARY * 1.1, SALARY * 1.05) "인상된 급여" 
FROM EMPLOYEE;

-- CASE 표현식 
-- CASE WHEN 조건식 THEN 결과값
--		WHEN 조건식 THEN 결과값
-- 		ELSE 결과값
-- END

-- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과값을 반환 (조건은 범위 값 가능!)

-- EMPLOYEE 테이블에서 급여가 500만원 이상이면 '대' 300만원 이상이면 '중' 급여가 300만원 미만이면 '소'로 조회
-- 사원이름, 급여, 급여 받는 정도 조회

SELECT EMP_NAME, SALARY, 
CASE WHEN SALARY >= 5000000 THEN '대' 
WHEN SALARY >= 3000000 THEN '중' 
ELSE '소' END "급여 받는 정도" FROM EMPLOYEE; 

----------------------------------------------------------------------------------------------------

-- 그룹 함수
-- 하나 이상의 행을 그룹으로 묶어 연산하여 총합, 평균 등의 1개의 결과 행으로 반환하는 함수

-- SUM(숫자가 기록된 컬럼명) : 합계
-- 모든 직원의 급여 합 조회
SELECT SUM(SALARY) FROM EMPLOYEE; -- 23개의 데이터를 1개의 결과로 반환 => 70,096,240

-- AVG(숫자가 기록된 컬럼명) : 평균
-- 전 직원 급여 평균 조회
SELECT ROUND(AVG(SALARY)) FROM EMPLOYEE; -- 3047663

-- 부서코드가 D9인 사원들의 급여 총합, 평균 조회
/* 3 */ SELECT SUM(SALARY), ROUND(AVG(SALARY)) 
/* 1 */ FROM EMPLOYEE 
/* 2 */ WHERE DEPT_CODE = 'D9';

-- MIN(컬럼명) : 최솟값
-- MAX(컬럼명) : 최댓값
--> 타입 제한 X (숫자: 대/소, 날짜: 과거/미래, 문자열: 문자 순서)

-- 급여 최솟값, 가장 빠른 입사일, 알파벳 순서가 가장 빠른 이메일 조회
SELECT MIN(SALARY), MIN(HIRE_DATE), MIN(EMAIL) FROM EMPLOYEE;

-- 급여 최댓값, 가장 늦은 입사일, 알파벳 순서가 가장 늦은 이메일 조회
SELECT MAX(SALARY), MAX(HIRE_DATE), MAX(EMAIL) FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 급여를 가장 많이 받는 사원의 이름, 급여, 직급코드를 조회하라

-- 가장 큰 급여 조회
SELECT MAX(SALARY) FROM EMPLOYEE; -- 서브 쿼리 + 그룹 함수

SELECT EMP_NAME, SALARY, JOB_CODE FROM EMPLOYEE WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE);

-- COUNT() : 행 개수를 헤아려서 반환
-- COUNT(컬럼명) : NULL을 제외한 실제 값이 기록된 행의 개수 반환
-- COUNT(*) : NULL을 포함한 전체 행의 개수 반환
-- COUNT(DISTICNT 컬럼명) : 중복을 제거한 행 개수 반환

SELECT COUNT(*) FROM EMPLOYEE; -- 23




