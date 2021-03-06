/****** Script for SelectTopNRows command from SSMS  ******/
/* 
- Find cases which a person did both tasks 'Create Purchase Order Item' and 'Record Goods Receipt' 
- There are NO case which a person did both tasks 'Create Purchase Order Item' and 'Record Invoice Receipt' 
- Output : Save only [_case_concept_name_] which a person did both two tasks
"*/
SELECT distinct B.[_case_concept_name_],
	 B.[_case_Purchasing_Document_] 
INTO [DIM].[case_segregation_duty]

FROM [stg].[case_table_filtered] B JOIN [stg].[event_table_filtered] A 
ON B.[_case_concept_name_]=A.[_case_concept_name_]
WHERE A.[_case_concept_name_] IN 
(
SELECT A._case_concept_name_ 
FROM  stg.event_table_filtered AA
WHERE A._case_concept_name_=AA._case_concept_name_ 
	AND AA._event_User_ like 'user%'	
	AND A._event_concept_name_='Create Purchase Order Item'	
	AND AA._event_concept_name_='Record Goods Receipt'
	AND A._event_time_timestamp_<=AA._event_time_timestamp_ 
	AND A._event_User_ = AA._event_User_
)