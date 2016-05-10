public with sharing class TBN_RecursionHelper 
{

	public static boolean isDelete = true;
	public static boolean isInsert = true;
	public static boolean isAfterInsert = true;
	public static boolean isBeforeUpdate = true;
	public static boolean isBeforeInsert = true;
	public static boolean isAfterUpdate = true;
	public static boolean isinsertCaseComment = true;
	//public static boolean isAfterUpdate = 
	
	public static boolean getisDelete()
	{
		return isDelete;
	}
	public static void setisDelete(boolean t)
	{
		isDelete = t;
	}
	//for Case Comment trigger alone this is used
	public static boolean getisinsertCaseComment()
	{
		return isinsertCaseComment;
	}
	public static void setisinsertCaseComment(boolean t)
	{
		isinsertCaseComment = t;
	}
	// for before Insert
	public static boolean getisInsert()
	{
		return isInsert;
	}
	public static void setisInsert(boolean t)
	{
		isInsert = t;
	}
	// for After Insert
	public static boolean getisAfterInsert()
	{
		return isAfterInsert;
	}
	public static void setisAfterInsert(boolean t)
	{
		isAfterInsert = t;
	}
	
	// for before update
	public static boolean getisBeforeUpdate()
	{
		return isBeforeUpdate;
	}
	public static void setisBeforeUpdate(boolean t)
	{
		isBeforeUpdate = t;
	}
	// for After update
	public static boolean getisAfterUpdate()
	{
		return isAfterUpdate;
	}
	public static void setisAfterUpdate(boolean t)
	{
		isAfterUpdate = t;
	}
}