--1.請統計員工負責的訂單數、銷售產品個數、銷售產品類別個數。
SELECT  E.姓名 ,  E.職稱 , COUNT(DISTINCT  O.訂單號碼)  訂單數量 ,
					 	   COUNT(DISTINCT  OD.產品編號) 產品個數,
					       COUNT(DISTINCT  P.類別編號)   類別個數
FROM   dbo.員工 E  LEFT JOIN      
	   (dbo.訂貨主檔 O JOIN  dbo.訂貨明細  OD  ON O.訂單號碼=OD.訂單號碼
				       JOIN  dbo.產品資料  P    ON OD.產品編號=P.產品編號
                       JOIN  dbo.產品類別  PG   ON PG.類別編號=P.類別編號)
					   ON E.員工編號=O.員工編號
GROUP  BY  E.姓名 ,  E.職稱
ORDER BY 1

--2.請提供1997年業績最好的三名員工。
SELECT  TOP 3 WITH TIES  E.姓名 ,SUM(單價*數量*(1-折扣)) 業績
FROM    員工 E JOIN 訂貨主檔 O   ON  E.員工編號=O.員工編號
			   JOIN 訂貨明細 OD  ON  O.訂單號碼=OD.訂單號碼
WHERE YEAR(O.訂單日期) = 1997
GROUP BY  E.姓名
ORDER BY  業績  DESC
GO

--3.請提供1996年飲料類產品銷售數量低於該類產品當年度銷售平均數量的訂單號碼及客戶
select O.訂單號碼,C.公司名稱,SUM(A.數量) 總數量
from 訂貨主檔 O JOIN 訂貨明細 A ON O.訂單號碼=A.訂單號碼 
				JOIN 產品資料 P ON A.產品編號=P.產品編號
				JOIN 客戶 C ON O.客戶編號=C.客戶編號
				JOIN 產品類別 B ON P.類別編號=B.類別編號				
WHERE  YEAR(O.訂單日期)='1996' AND B.類別名稱='飲料'
GROUP BY O.訂單號碼,C.公司名稱,B.類別編號
HAVING  SUM(A.數量)<(SELECT AVG(S1.數量) FROM 訂貨明細 S1 JOIN  產品資料 S2 ON S1.產品編號=S2.產品編號 WHERE S2.類別編號=B.類別編號)
go

--1996年飲料類的平均數量
select avg(A.數量)
from 訂貨主檔 O JOIN 訂貨明細 A ON O.訂單號碼=A.訂單號碼 
				JOIN 產品資料 P ON A.產品編號=P.產品編號
				JOIN 客戶 C ON O.客戶編號=C.客戶編號
				JOIN 產品類別 B ON P.類別編號=B.類別編號				
WHERE  YEAR(O.訂單日期)='1996' AND B.類別名稱='飲料'
go


--4.請找出交易金額(單價*數量*(1-折扣))達15,000元以上的訂單、承辦人員及客戶。
SELECT  O.訂單號碼 , E.姓名 , C.公司名稱 , SUM(單價*數量*(1-折扣)) 交易金額
FROM   dbo.訂貨明細 OD  JOIN  dbo.訂貨主檔 O  ON  OD.訂單號碼 = O.訂單號碼
						JOIN  dbo.員工 E  ON   O.員工編號 = E.員工編號
						JOIN  dbo.客戶 C  ON   O.客戶編號 = C.客戶編號
GROUP BY  O.訂單號碼 , E.姓名 , C.公司名稱
HAVING SUM(單價*數量*(1-折扣))>=15000
GO



--5.請統計員工1996,1997,1998年業績，業績取至小數位第2位，第3位四捨五入，並以年度為欄位顯示統計資料，當年度沒有業績者以無交易顯示。
select 編號,姓名,職稱,isnull(cast([1996] as varchar(10)),'無交易') '1996年',
					  isnull(cast([1997] as varchar(10)),'無交易') '1997年',
					  isnull(cast([1998] as varchar(10)),'無交易') '1998年'
from (select  e.員工編號 編號,e.姓名 姓名,e.職稱 職稱,
			  year(o.訂單日期) 年度,cast(od.單價*od.數量*(1-od.折扣) as numeric(10,2)) 業績
	   from   員工 e left join (訂貨主檔 o 	join 訂貨明細 od on od.訂單號碼=o.訂單號碼)
				on  e.員工編號=o.員工編號 ) 員工歷年業務
pivot ( SUM(業績) for 年度 in ([1996],[1997],[1998]))  my_view
order by 編號,姓名
GO



