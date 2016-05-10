public with sharing class ISP_PromoterAlbumLightningCon {
    public String albumId{get;set;}
    public ISP_PromoterAlbumLightningCon(ApexPages.StandardController controller) {
        albumId = Apexpages.currentPage().getParameters().get('id');
    }
    
    public PageReference redicectBasedOnProfile(){
       Profile p = [select name from Profile where id =:UserInfo.getProfileId()];
       if(p.Name != 'Instore Promoter'){
          
          return new PageReference('/apex/ISP_StoreAlbum?id='+albumId);
       }else{        
 
          return null;
       }
    }

}