trigger relatedobj on Case (after insert, after update) 
{
    try
    {
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            List<Case> AsIds = new List<Case>([Select AccountId, AssetId, ContactId from Case where Id In : trigger.newMap.keySet()]);
        
            List<Id>  Ids = new List<Id>();
            List<Id>  ContactIds = new List<Id>();
            for(Integer j=0; j< AsIds.size();j++)
            { 
                Ids.add(AsIds.get(j).AssetId);
                ContactIds.add(AsIds.get(j).ContactId);
            }
            Asset[] assets = [Select AccountId, ContactId from Asset Where Id In : Ids];
            List<Contact> updateCon=new List<Contact>();
            List<Asset> updateAsset=new List<Asset>();
            List<Contact> conAccount=new List<Contact>([Select AccountId from Contact where id In : ContactIds]);
            for(Case cs:Trigger.new)
            {
                for(Integer i=0; i< assets.size();i++)
                {
                    if(conAccount.get(i).AccountId == null)
                    {
                        Contact con = new Contact(Id=AsIds.get(i).ContactId);
                        con.AccountId=assets.get(i).AccountId;
                        updateCon.add(con);
                    }
                }
        
                for(Integer i=0; i< AsIds.size();i++)
                {
                    Asset AssCon= new Asset(Id=AsIds.get(i).AssetId);
                    AssCon.ContactId=AsIds.get(i).ContactId;
                    updateAsset.add(AssCon);
                }
            }
            update updateCon;
            update updateAsset;
        }
    }
    catch(Exception e)
    {}
}