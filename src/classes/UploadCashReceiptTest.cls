/*************************************************************************************************
        Created by    :    Dhriti Krishna Ghosh Moulick
        Created On    :    2015-08-06
        Modified by   :    
        Modified on   :    
        Description   :    Test class for tuploading data to Cash Receipt object
**************************************************************************************************/

@isTest
Private class UploadCashReceiptTest{
    Static testmethod void TestDataInsert(){
         
            UploadCashReceipt uploadReceipt = new UploadCashReceipt();//check for positive scenario
            uploadReceipt.nameFile = 'file.csv';
            uploadReceipt.contentFile = blob.valueOf('Receipt Number,Resource Name'+'\n'+
            'REFe00000072A4M,a0ee0000003x7zN,1234,2015-03-03');
            uploadReceipt.ReadFile();
            
            
            
            UploadCashReceipt uploadReceipt1 = new UploadCashReceipt();//Check if file name is not .csv
            uploadReceipt1.nameFile = 'file.png';
            uploadReceipt1.contentFile = blob.valueOf('Receipt Number,Resource Name'+'\n'+
            'REFe00000072A4M,a0ee0000003x7zN,1234,2015-03-03');
            uploadReceipt1.ReadFile();
           
            
            UploadCashReceipt uploadReceipt2 = new UploadCashReceipt();////Check if file is null
            uploadReceipt2.ReadFile();
            
            UploadCashReceipt uploadReceipt4 = new UploadCashReceipt();//Check if receipt Date is incorrect
            uploadReceipt4.nameFile = 'file.csv';
            uploadReceipt4.contentFile = blob.valueOf('Receipt Number,Resource Name'+'\n'+
            'REFe00000072A4M,a0ee0000003x7zN,1256,201503ed03');
            uploadReceipt4.ReadFile();
           
    }
    Static testmethod void TestDataInsertNegative(){
    
            UploadCashReceipt uploadReceipt4 = new UploadCashReceipt();//Check if receipt Amount is incorrect
            uploadReceipt4.nameFile = 'file.csv';
            uploadReceipt4.contentFile = blob.valueOf('Receipt Number,Resource Name'+'\n'+
            'REFe00000072A4M,a0ee0000003x7zN,12we,2015-03-03');
            uploadReceipt4.ReadFile();
           
            
            UploadCashReceipt uploadReceipt5 = new UploadCashReceipt();//Check if receipt Amount is null
             uploadReceipt5.nameFile = 'file.csv';
            uploadReceipt5.contentFile = blob.valueOf('Receipt Number,Resource Name'+'\n'+
            'REFe00000072A4M,a0ee0000003x7zN,,2015-03-03');
            uploadReceipt5.ReadFile();
            
            
            UploadCashReceipt uploadReceipt6 = new UploadCashReceipt();//Check if case number is null
             uploadReceipt6.nameFile = 'file.csv';
            uploadReceipt6.contentFile = blob.valueOf('Receipt Number,Resource Name'+'\n'+
            ',a0ee0000003x7zN,1234,2015-03-03');
            uploadReceipt6.ReadFile();
             
            
            UploadCashReceipt uploadReceipt7 = new UploadCashReceipt();//Check if Resource Name is null
             uploadReceipt7.nameFile = 'file.csv';
            uploadReceipt7.contentFile = blob.valueOf('Receipt Number,Resource Name'+'\n'+
            'REFe00000072A4M,,1234,2015-03-03');
            uploadReceipt7.ReadFile();
             
    }
}