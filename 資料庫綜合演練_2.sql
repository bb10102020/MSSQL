--1.�вέp���u�t�d���q��ơB�P�ⲣ�~�ӼơB�P�ⲣ�~���O�ӼơC
SELECT  E.�m�W ,  E.¾�� , COUNT(DISTINCT  O.�q�渹�X)  �q��ƶq ,
					 	   COUNT(DISTINCT  OD.���~�s��) ���~�Ӽ�,
					       COUNT(DISTINCT  P.���O�s��)   ���O�Ӽ�
FROM   dbo.���u E  LEFT JOIN      
	   (dbo.�q�f�D�� O JOIN  dbo.�q�f����  OD  ON O.�q�渹�X=OD.�q�渹�X
				       JOIN  dbo.���~���  P    ON OD.���~�s��=P.���~�s��
                       JOIN  dbo.���~���O  PG   ON PG.���O�s��=P.���O�s��)
					   ON E.���u�s��=O.���u�s��
GROUP  BY  E.�m�W ,  E.¾��
ORDER BY 1

--2.�д���1997�~�~�Z�̦n���T�W���u�C
SELECT  TOP 3 WITH TIES  E.�m�W ,SUM(���*�ƶq*(1-�馩)) �~�Z
FROM    ���u E JOIN �q�f�D�� O   ON  E.���u�s��=O.���u�s��
			   JOIN �q�f���� OD  ON  O.�q�渹�X=OD.�q�渹�X
WHERE YEAR(O.�q����) = 1997
GROUP BY  E.�m�W
ORDER BY  �~�Z  DESC
GO

--3.�д���1996�~���������~�P��ƶq�C��������~��~�׾P�⥭���ƶq���q�渹�X�ΫȤ�
select O.�q�渹�X,C.���q�W��,SUM(A.�ƶq) �`�ƶq
from �q�f�D�� O JOIN �q�f���� A ON O.�q�渹�X=A.�q�渹�X 
				JOIN ���~��� P ON A.���~�s��=P.���~�s��
				JOIN �Ȥ� C ON O.�Ȥ�s��=C.�Ȥ�s��
				JOIN ���~���O B ON P.���O�s��=B.���O�s��				
WHERE  YEAR(O.�q����)='1996' AND B.���O�W��='����'
GROUP BY O.�q�渹�X,C.���q�W��,B.���O�s��
HAVING  SUM(A.�ƶq)<(SELECT AVG(S1.�ƶq) FROM �q�f���� S1 JOIN  ���~��� S2 ON S1.���~�s��=S2.���~�s�� WHERE S2.���O�s��=B.���O�s��)
go

--1996�~�������������ƶq
select avg(A.�ƶq)
from �q�f�D�� O JOIN �q�f���� A ON O.�q�渹�X=A.�q�渹�X 
				JOIN ���~��� P ON A.���~�s��=P.���~�s��
				JOIN �Ȥ� C ON O.�Ȥ�s��=C.�Ȥ�s��
				JOIN ���~���O B ON P.���O�s��=B.���O�s��				
WHERE  YEAR(O.�q����)='1996' AND B.���O�W��='����'
go


--4.�Ч�X������B(���*�ƶq*(1-�馩))�F15,000���H�W���q��B�ӿ�H���ΫȤ�C
SELECT  O.�q�渹�X , E.�m�W , C.���q�W�� , SUM(���*�ƶq*(1-�馩)) ������B
FROM   dbo.�q�f���� OD  JOIN  dbo.�q�f�D�� O  ON  OD.�q�渹�X = O.�q�渹�X
						JOIN  dbo.���u E  ON   O.���u�s�� = E.���u�s��
						JOIN  dbo.�Ȥ� C  ON   O.�Ȥ�s�� = C.�Ȥ�s��
GROUP BY  O.�q�渹�X , E.�m�W , C.���q�W��
HAVING SUM(���*�ƶq*(1-�馩))>=15000
GO



--5.�вέp���u1996,1997,1998�~�~�Z�A�~�Z���ܤp�Ʀ��2��A��3��|�ˤ��J�A�åH�~�׬������ܲέp��ơA��~�רS���~�Z�̥H�L�����ܡC
select �s��,�m�W,¾��,isnull(cast([1996] as varchar(10)),'�L���') '1996�~',
					  isnull(cast([1997] as varchar(10)),'�L���') '1997�~',
					  isnull(cast([1998] as varchar(10)),'�L���') '1998�~'
from (select  e.���u�s�� �s��,e.�m�W �m�W,e.¾�� ¾��,
			  year(o.�q����) �~��,cast(od.���*od.�ƶq*(1-od.�馩) as numeric(10,2)) �~�Z
	   from   ���u e left join (�q�f�D�� o 	join �q�f���� od on od.�q�渹�X=o.�q�渹�X)
				on  e.���u�s��=o.���u�s�� ) ���u���~�~��
pivot ( SUM(�~�Z) for �~�� in ([1996],[1997],[1998]))  my_view
order by �s��,�m�W
GO



