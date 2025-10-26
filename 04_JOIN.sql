/*
                         [JOIN 용어 정리]
                       
          오라클                                    SQL : 1999표준(ANSI)
----------------------------------------------------------------------------------------------------------------
         등가 조인                               내부 조인(INNER JOIN), JOIN USING / ON
                                              + 자연 조인(NATURAL JOIN, 등가 조인 방법 중 하나)
----------------------------------------------------------------------------------------------------------------
         포괄 조인                               왼쪽 외부 조인(LEFT OUTER), 오른쪽 외부 조인(RIGHT OUTER)
                                              + 전체 외부 조인(FULL OUTER, 오라클 구문으로는 사용 못함)
----------------------------------------------------------------------------------------------------------------
     자체 조인, 비등가 조인                                  JOIN ON
----------------------------------------------------------------------------------------------------------------
      카테시안(카티션) 곱                              교차 조인(CROSS JOIN)
     CARTESIAN PRODUCT


- 미국 국립 표준 협회(American National Standards Institute, ANSI) 미국의 산업 표준을 제정하는 민간단체.
- 국제표준화기구 ISO에 가입되어 있음.

*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- JOIN
-- 하나 이상의 테이블에서 데이터를 조회하기 위해 사용.
-- 수행 결과는 하나의 Result Set으로 나옴.


-- (참고) JOIN은 서로 다른 테이블의 행을 하나씩 이어 붙이기 때문에
--       시간이 오래 걸리는 단점이 있다!


/*
- 관계형 데이터베이스에서 SQL을 이용해 테이블간 '관계'를 맺는 방법.

- 관계형 데이터베이스는 최소한의 데이터를 테이블에 담고 있어 원하는 정보를 테이블에서 조회하려면 한 개 이상의 테이블에서 데이터를 읽어와야 되는 경우가 많다. 
  이 때, 테이블간 관계를 맺기 위한 연결고리 역할이 필요한데, 두 테이블에서 같은 데이터를 저장하는 컬럼이 연결고리가됨.  
*/

/*
 - 연결고리(Join Key)의 정체
 => 무엇? 두 테이블의 관련 있는 컬럼 쌍과 그 관계를 명시한 조건
	가장 흔한 형태: A.키컬럼 = B.키컬럼 (equi-join)

 => 왜 필요?
 1. 서로 다른 테이블의 같은 실세계 개체(같은 학생, 같은 과목)를 한 행으로 합치기 위해
 2. 불필요한 모든 조합을 막고(카티전 곱 방지), 의미 있는 매칭만 남기기 위해

cf) 보통 부모(PK/UK) – 자식(FK) 컬럼이 자연스러운 연결고리다.
	하지만 반드시 FK만 써야 하는 건 아니고, 업무상 유일함이 보장되는 컬럼(대체키, 비즈니스 키)로도 연결 가능.
	
  - JOIN의 종류별 연결고리의 역할
  1. INNER JOIN => 양쪽에 연결고리 값이 매칭되는 행만 남기며, 연결고리를 충족하지 못한 행은 버려진다
  
  2. LEFT OUTER JOIN => 왼쪽 행은 전부 남기며 오른쪽 행은 연결고리 값이 매칭될 시 채워진다 
  						연결고리를 충족하지 못한 오른쪽 행은 NULL로 채워짐
  						
  3. RIGHT OUTER JOIN => 오른쪽 행은 전부 남기며 왼쪽 행은 연결고리 값이 매칭될 시 채워진다 
  						 연결고리를 충족하지 못한 왼쪽 행은 NULL로 채워짐
  				   		 
  4. FULL OUTER JOIN => 양쪽의 모든 행을 유지하며, 연결고리 값이 매칭되지 못하는 행들은 NULL로 채워진다
  
  5. CROSS JOIN => 연결고리(ON 조건)가 없으며 두 테이블 간 가능한 모든행의 조합이 결과 집합으로 출력된다
  				   (결과 행의 개수 = 왼쪽 테이블 행 수 × 오른쪽 테이블 행 수)
  				   
  6. SELF JOIN => 같은 테이블을 별칭 2개로 나누어 자기 자신과 조인하며, 보통 상하위/선후행 관계를 표현할 때 사용한다
  
  - 연결고리 설정 시 체크리스트
	1. 키/유일성 확인
	   - 가능한 PK/UK ↔ FK를 우선 사용 (중복/누락 최소화)
	2. NULL 처리
	   - INNER JOIN에서 연결고리 컬럼이 NULL이면 매칭 불가 → 행 제외
	   - 외래키 컬럼이 NULL을 가질 수 있는 모델이라면, LEFT JOIN으로 남길지 판단
	3. 다대다(N:M) 구조 주의
	   - TB_CLASS ↔ TB_PROFESSOR는 중간 테이블(TB_CLASS_PROFESSOR)로 풀어야 함, 이때 연결고리는 보통 두 번의 1:N으로 분해
	4. 다중 매칭(중복) 주의
	   - 업무 키로 조인 시 한쪽에 중복이 있으면 결과가 곱으로 늘어남
	   - 필요 시 DISTINCT/집계/서브쿼리로 중복 제어
	5. USING / NATURAL JOIN 주의
	   - USING(col)은 같은 이름의 컬럼에만 쓰고 모호성 줄이는 데 유용
	   - NATURAL JOIN은 컬럼명이 같다는 이유만으로 자동 연결 → 예상치 못한 컬럼이 연결고리가 될 수 있어 실무에서 비권장
	6. 성능(인덱스)
	   - 연결고리에 쓰는 컬럼엔 인덱스가 있으면 유리 (특히 큰 테이블)
	   - 보통 부모 PK/UK, 자식 FK에 인덱스 구성
	   - 불필요한 함수/형변환이 연결고리에 걸리면 인덱스 활용이 깨질 수 있음
	   
   - 조인 사용할 시 사고법 정리
    1. 데이터 모델: 두 테이블의 관계(1:1, 1:N, N:M)를 먼저 파악
	2. 키 선택: PK/UK ↔ FK를 1순위로, 불가하면 유일한 업무 키
	3. 중복/NULL/유실: INNER/OUTER 선택과 추가 조건으로 제어
	4. 성능: 조인 컬럼 인덱스, 불필요 변환 회피, 필요 시 서브쿼리/윈도우 함수 고려
*/

------------------------------------------------------------------------------------

-- 사번, 이름, 부서코드, 부서명 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE 
FROM EMPLOYEE;

-- 부서명은 DEPARTMENT 테이블에서 조회 가능
SELECT DEPT_TITLE FROM DEPARTMENT;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE 
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
-- 테이블 간의 관계 파악 중요!

-- 1. 내부 조인(INNER JOIN, ANSI) (== 등가조인(EQUAL JOIN, ORACLE))
--> 연결되는 컬럼의 값이 일치하는 행들만 조인됨.
--> 일치하는 값이 없는 행은 조인에서 제외됨.

-- 작성방법은 크게 ANSI구문과 오라클 구문으로 나뉘고
-- ANSI에서 USING과 ON을 쓰는 방법으로 나뉜다

-- 1) 연결에 사용할 두 컬럼명이 다른 경우
-- ANSI 표준
-- 연결에 사용할 컬럼명이 다른 경우 ON()을 사용
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE 
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 오라클 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE 
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- DEPARTMENT 테이블, LOCATION 테이블을 참조하여
-- 부서명, 지역명 조회
SELECT * FROM DEPARTMENT; -- LOCATION_ID
SELECT * FROM LOCATION; -- LOCAL_CODE

-- ANSI 표준
SELECT DEPT_TITLE, LOCAL_NAME 
FROM DEPARTMENT
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);

-- 오라클 방식
SELECT DEPT_TITLE, LOCAL_NAME 
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

-- 2) 연결에 사용할 컬럼명이 같은 경우

-- EMPLOYEE 테이블과 JOB 테이블을 참조하여
-- 사번, 이름, 직급코드, 직급명 조회

SELECT * FROM EMPLOYEE; -- JOB_CODE
SELECT * FROM JOB; -- JOB_CODE

-- ANSI 표준
-- 연결에 사영할 컬럼명이 같은 경우 USING(컬럼명) 사용
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

-- 오라클 구문
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE JOB_CODE = JOB_CODE;
-- ORA-00918: 열의 정의가 애매합니다 => JOB_CODE가 어떤 테이블의 것인지 애매

-- 테이블에 별칭을 붙여 어떤 테이블의 것인지 확실히 하여 해결! (테이블에 별칭 붙이기 싫다면 테이블명. 방식도 가능)
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

--------------------------------------------------------------------------------------------

-- 2. 외부 조인(OUTER JOIN, ANSI) (== 포괄 조인 (ORACLE))

-- 두 테이블의 지정하는 컬럼값이 일치하지 않는 경우에도 조인에 포함시킴
-- ** 반드시 OUTER JOIN임을 명시해야함! **

SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE 
FROM EMPLOYEE
/*INNER*/ JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 1) LEFT [OUTER] JOIN : 합치기에 사용한 두 테이블 중 왼편에 기술된 테이블의 컬럼수를 기준으로 JOIN
--> 왼편에 작성된 테이블의 모든행이 결과에 포함되어야한다. (JOIN이 되지않는 행도 결과에 포함!)

-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE LEFT /* OUTER */ JOIN DEPARTMENT
ON(DEPT_CODE = DEPT_ID); -- 23행 (DEPT_CODE가 NULL인 하동운, 이오리 포함)
-- 테이블 위치가 중요! => 왼쪽의 테이블을 기준으로 JOIN

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);
-- 기준의 반대쪽 테이블 컬럼에 (+) 기호 작성해야함!

-- RIGHT [OUTER] JOIN : 합치기에 사용한 두 테이블 중 오른편에 기술된 테이블의 컬럼수를 기준으로 JOIN

-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE RIGHT /* OUTER */ JOIN DEPARTMENT
ON(DEPT_CODE = DEPT_ID);
-- 테이블 위치가 중요! => 오른쪽의 테이블을 기준으로 JOIN

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;

-- 3) FULL [OUTER] JOIN : 합치기에 사용한 두 테이블이 가진 모든 행을 결과에 포함
-- ** 오라클 구문 FULL OUTER JOIN 사용 불가! **

-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE FULL /* OUTER */ JOIN DEPARTMENT
ON(DEPT_CODE = DEPT_ID);
-- 두 테이블이 지정하는 모든 컬럼값 포함

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID(+);
-- ORA-01468: outer-join된 테이블은 1개만 지정할 수 있습니다 => FULL 불가!

----------------------------------------------------------------------------------------------------------

-- 3. 교차 조인(CROSS JOIN, ANSI) (== 카테시안 곱 (CARTESIAN PRODUCT, ORACLE))
-- 조인되는 테이블의 각 행들이 모두 매핑된 데이터가 검색되는 방법 (곱집합)
--> JOIN 구문 잘못 작성하는 경우 CROSS JOIN의 결과가 조회됨

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT
ORDER BY EMP_NAME;
-- EMP_NAME 하나 당 가져올 수 있는 모든 DEPT_TITLE을 다 가져옴
-- => EMP_NAME 23개 * DEPT_TITLE 9개 = 207개의 행!


-----------------------------------------------------------------------------------------------------------

-- 4. 비등가 조인 (NON EQUAL JOIN, ORACLE (== JOIN ON, ANSI)) 
-- '=' (등호)를 사용하지 않는 JOIN문
-- 지정한 컬럼값이 일치하는 경우가 아닌, 값의 범위에 포함되는 행들을 연결하는 방식

SELECT * FROM SAL_GRADE;

SELECT EMP_NAME, SAL_LEVEL 
FROM EMPLOYEE;

-- 사원의 급여에 따라 급여 등급 파악하기
SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL 
FROM EMPLOYEE
JOIN SAL_GRADE ON(SALARY BETWEEN MIN_SAL AND MAX_SAL);

------------------------------------------------------------------------------------------------------------

-- 5. 자체 조인(SELF JOIN)

-- 같은 테이블의 조인
-- 자기 자신과 조인 맺음
-- TIP! 같은 테이블 2개 있다고 생각하고 JOIN
-- 테이블마다 별칭 작성(미작성 시 열의 정의가 애매하다.. 오류 발생)

-- 사번, 이름, 사수의 사번, 사수의 이름 조회
-- 단, 사수가 없을 시에는 '없음', '-' 조회

SELECT * FROM EMPLOYEE;
SELECT * FROM EMPLOYEE;

-- ANSI 표준
SELECT E1.EMP_ID 사번, E1.EMP_NAME "사원 이름", 
NVL(E1.MANAGER_ID, '없음') "사수의 사번", 
NVL(E2.EMP_NAME, '-') "사수의 이름"
FROM EMPLOYEE E1
LEFT JOIN EMPLOYEE E2 ON(E1.MANAGER_ID = E2.EMP_ID)
ORDER BY E1.EMP_ID;

-- 오라클 구문
SELECT E1.EMP_ID 사번, E1.EMP_NAME "사원 이름", 
NVL(E1.MANAGER_ID, '없음') "사수의 사번", 
NVL(E2.EMP_NAME, '-') "사수의 이름"
FROM EMPLOYEE E1, EMPLOYEE E2
WHERE E1.MANAGER_ID = E2.EMP_ID(+)
ORDER BY E1.EMP_ID;

-----------------------------------------------------------------------------------------------

-- 6. 자연 조인(NATURAL JOIN)
-- 동일한 타입과 이름을 가진 컬럼이 있는 테이블 간의 조인을 간단히 표현하는 방법
-- 반드시 두 테이블 간의 동일한 컬럼명, 타입을 가진 컬럼이 필요!

SELECT JOB_CODE FROM EMPLOYEE;
SELECT JOB_CODE FROM JOB;

SELECT EMP_NAME, JOB_NAME 
FROM EMPLOYEE
-- JOIN JOB USING(JOB_CODE);
NATURAL JOIN JOB; -- 컬럼명과 타입을 다 알고 있어야 함!

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
NATURAL JOIN DEPARTMENT;
--> 잘못 조인하면 CROSS JOIN 결과 조회

-------------------------------------------------------------------------------------------

-- 7. 다중 조인
-- N개의 테이블을 조인할 때 사용 (** 순서 중요!!! **)

-- 사원 이름, 부서명, 지역명 조회
-- EMP_NAME (EMPLOYEE)
-- DEPT_TITLE (DEPARTMENT)
-- LOCAL_NAME (LOCATION)

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;

-- ANSI 표준
SELECT EMP_NAME "사원 이름", DEPT_TITLE 부서명, LOCAL_NAME 지역명
FROM EMPLOYEE 
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID) -- EMPLOYEE 테이블과 DEPARTMENT 테이블을 먼저 JOIN
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE); -- (EMPLOYEE + DEPARTMENT) 테이블에 LOCATION 테이블 JOIN

-- 오라클 구문
SELECT EMP_NAME "사원 이름", DEPT_TITLE 부서명, LOCAL_NAME 지역명
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID -- EMPLOYEE 테이블과 DEPARTMENT 테이블을 먼저 JOIN
AND LOCATION_ID = LOCAL_CODE; -- JOIN된 테이블에 LOCATION 테이블 JOIN

-- 다중 조인 연습 문제

-- 직급이 대리이면서, 아시아 지역에 근무하는 직원 조회
-- 사번, 이름, 직급명, 부서명, 근무지역명, 급여

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM JOB;
SELECT * FROM LOCATION;

-- ANSI 표준 VER.
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
WHERE JOB_NAME = '대리' AND LOCAL_NAME LIKE 'ASIA%';

-- 오라클 VER.
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, DEPT_TITLE, LOCAL_NAME, E.SALARY
FROM EMPLOYEE E, JOB J, DEPARTMENT, LOCATION
WHERE E.JOB_CODE = J.JOB_CODE 
AND E.DEPT_CODE = DEPT_ID 
AND LOCATION_ID = LOCAL_CODE
AND JOB_NAME = '대리' AND LOCAL_NAME LIKE 'ASIA%';

------------------------------------------------------------------------------------------------------------------------

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM JOB;
SELECT * FROM LOCATION;
SELECT * FROM SAL_GRADE;
SELECT * FROM NATIONAL;

-- 1. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 '전'씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.
SELECT EMP_NAME 사원명, EMP_NO 주민번호, DEPT_TITLE 부서명, JOB_NAME 직급명
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SUBSTR(EMP_NO, 1, 2) BETWEEN 70 AND 79 /*== EMP_NO LIKE '7%*/
AND SUBSTR(EMP_NO, 8, 1) = 2
AND EMP_NAME LIKE '전%';

-- 2. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 직급명, 부서명을 조회하시오.
SELECT EMP_ID 사번, EMP_NAME 사원명, JOB_NAME 직급명, DEPT_TITLE 부서명
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE) -- == NATURAL JOIN JOB => 연결고리의 컬럼명과 타입이 완전 일치하기 때문에
JOIN DEPARTMENT ON(DEPT_CODE  = DEPT_ID)
WHERE EMP_NAME LIKE '%형%';

-- 3. 해외영업 1부, 2부에 근무하는 사원의 사원명, 직급명, 부서코드, 부서명을 조회하시오.
SELECT EMP_NAME 사원명, JOB_NAME 직급명, DEPT_CODE 부서코드, DEPT_TITLE 부서명
FROM EMPLOYEE 
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE IN ('해외영업1부', '해외영업2부');

-- 4. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
SELECT EMP_NAME 사원명, BONUS 보너스포인트, DEPT_TITLE 부서명, LOCAL_NAME 근무지역명
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
LEFT JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
-- OUTER JOIN을 해야 DEPT_CODE나 LOCATION_ID 값이 일치하지 않는 사원 중 보너스가 있는 사원 조회 가능!
WHERE BONUS IS NOT NULL;

-- 5. 부서가 있는 사원의 사원명, 직급명, 부서명, 지역명 조회 
SELECT EMP_NAME 사원명, JOB_NAME 직급명, DEPT_TITLE 부서명, LOCAL_NAME 지역명
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);
-- WHERE절에서 부서가 없는 사원을 걸러내지 않아도 INNER JOIN을 통해 자연스럽게 걸러짐

-- 6. 급여등급별 최소급여(MIN_SAL)를 초과해서 받는 직원들의 사원명, 직급명,급여, 연봉(보너스포함)을 조회하시오. (연봉에 보너스포인트를 적용하시오.)
SELECT EMP_NAME 사원명, JOB_NAME 직급명, SALARY 급여, (SALARY + (SALARY * NVL(BONUS, 0))) * 12 "연봉(보너스포함)"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN SAL_GRADE USING(SAL_LEVEL)
WHERE SALARY > MIN_SAL;

-- 주의사항!
-- NATURAL JOIN을 다중 조인에서 사용할 때는 
-- SELECT 절에 NATURAL JOIN에서 
-- 사용되었을 연결고리 컬럼을 반드시 작성해야한다!

-- 7. 한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을 조회하시오.
SELECT EMP_NAME 사원명, DEPT_TITLE 부서명, LOCAL_NAME 지역명, NATIONAL_NAME 국가명
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME IN ('한국', '일본');

-- 8. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오.(SELF JOIN 사용)
SELECT E1.EMP_NAME 사원명, E1.DEPT_CODE 부서코드, E2.EMP_NAME 동료이름
FROM EMPLOYEE E1 
JOIN EMPLOYEE E2 ON(E1.DEPT_CODE = E2.DEPT_CODE)
WHERE E1.EMP_NAME != E2.EMP_NAME
ORDER BY 1;

-- 9. 보너스포인트가 없는 직원들 중에서 직급코드가 J4와 J7인 직원들의 사원명, 직급명, 급여를 조회하시오. (단, JOIN, IN 사용할 것)
SELECT EMP_NAME 사원명, JOB_NAME 직급명, SALARY 급여
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_CODE IN('J4','J7') AND BONUS IS NULL;


