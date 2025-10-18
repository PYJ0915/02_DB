-- 1번 문제 기본 조회 및 별칭 지정

-- 1-1) 모든 사원의 사원번호, 이름, 연봉을 조회하세요. 연봉은 급여(SALARY)의 12배로 계산하며, 컬럼명을 각각 '사번', '직원명', '연봉'으로 지정하세요.
SELECT EMP_ID 사번, EMP_NAME 직원명, SALARY * 12 연봉 FROM EMPLOYEE

-- 1-2) 현재 날짜(SYSDATE)를 조회하고, 컬럼명을 '오늘날짜'로 지정하여 출력하세요.
SELECT SYSDATE AS 오늘날짜 FROM DUAL;

-- 2번 조건절 (WHERE) 및 산술 연산

-- 문제 2-1) 급여가 400만원 초과인 사원의 이름, 급여, 부서코드를 조회하세요.
SELECT EMP_NAME, SALARY, DEPT_CODE FROM EMPLOYEE WHERE SALARY > 4000000;

-- 문제 2-2) 2000년 1월 1일 이전에 입사한 사원의 이름과 입사일을 조회하세요.
SELECT EMP_NAME, HIRE_DATE FROM EMPLOYEE WHERE HIRE_DATE < '2000-01-01'

-- 문제 2-3) 보너스율(BONUS)이 있는 사원의 이름, 급여, 보너스율을 조회하세요.
SELECT EMP_NAME, (SALARY + (SALARY * BONUS)), BONUS FROM EMPLOYEE WHERE BONUS IS NOT NULL;

-- 3번 논리 연산자 (AND, OR, BETWEEN, IN)

-- 3-1) 급여가 200만원 이상 300만원 이하인 사원의 사원번호, 이름, 급여를 조회하고, 급여 오름차순으로 정렬하세요.
SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE WHERE SALARY BETWEEN 2000000 AND 3000000 ORDER BY SALARY;

-- 3-2) 부서코드가 D5 또는 D6에 속하는 사원의 이름, 부서코드를 IN 연산자를 사용하여 조회하세요
SELECT EMP_NAME, DEPT_CODE FROM EMPLOYEE WHERE DEPT_CODE IN('D5', 'D6');

-- 3-3) **직급코드(JOB_CODE)**가 'J7'이 아닌 사원 중에서, 급여가 300만원 이상인 사원의 이름, 직급코드, 급여를 조회하세요.
SELECT EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE WHERE JOB_CODE != 'J7' AND SALARY >= 3000000;

-- 문제 4번 문자열 검색 (LIKE, ESCAPE)

-- 4-1) 이름이 '유'로 시작하는 사원의 사원번호와 이름을 조회하세요.
SELECT EMP_NAME, PHONE FROM EMPLOYEE WHERE EMP_NAME LIKE '유%';

-- 4-2) 전화번호(PHONE)가 '010'을 포함하고 있는 사원의 이름과 전화번호를 조회하세요.
SELECT EMP_NAME, PHONE FROM EMPLOYEE WHERE PHONE LIKE '%010%';

-- 4-3) 이메일(EMAIL) 주소에서 언더바 ('_') 바로 앞이 네 글자인 사원의 이름과 이메일을 조회하세요. 
SELECT EMP_NAME, EMAIL FROM EMPLOYEE WHERE EMAIL LIKE '____^_%' ESCAPE '^';

-- 5번 정렬 (ORDER BY) 및 중첩 정렬

-- 5-1) 모든 사원의 이름, 부서코드, 급여를 조회하되, 부서코드 오름차순으로 1차 정렬하고, 같은 부서 내에서는 급여 내림차순으로 2차 정렬하세요.
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE ORDER BY DEPT_CODE, SALARY DESC;

-- 5-2) 입사일(HIRE_DATE) 순서대로 이름과 입사일을 조회하세요. 입사일 컬럼에 '입사일자'라는 별칭을 사용하고, 정렬 시 이 별칭을 활용하세요.
SELECT EMP_NAME, HIRE_DATE "입사일자" FROM EMPLOYEE ORDER BY 입사일자;

-- 6번 단일 행 함수 (LENGTH, INSTR, SUBSTR, ROUND, MOD)

-- 6-1) 사원들의 이름, 이메일, 이메일에서 '@' 기호가 몇 번째에 있는지 조회하세요.
SELECT EMP_NAME, EMAIL, INSTR(EMAIL, '@') FROM EMPLOYEE;

-- 6-2) 모든 사원의 이름과 주민등록번호 앞 6자리를 조회하세요. 주민등록번호는 EMP_NO 컬럼을 사용하세요.
SELECT EMP_NAME, SUBSTR(EMP_NO, 1, 6) FROM EMPLOYEE;

-- 6-3) 모든 사원의 이름, 급여, 그리고 급여를 100만으로 나누었을 때의 나머지 값을 조회하세요.
SELECT EMP_NAME, SALARY, MOD(SALARY, 1000000) FROM EMPLOYEE;

-- 6-4) 숫자 38.745를 소수점 둘째 자리에서 반올림하여 소수점 첫째 자리까지 표시하세요.
SELECT ROUND(38.745, 1) FROM DUAL;
