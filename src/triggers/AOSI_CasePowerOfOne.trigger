trigger AOSI_CasePowerOfOne on Case (before update) {

    IF(AOSI_UtilRecursionHandler.isPowerOf1Recirsive ==FALSE){
        AOSI_UtilRecursionHandler.isPowerOf1Recirsive =TRUE;
        AOSI_casePowerOfOneHandler.TimeCapture(Trigger.newMap,Trigger.OldMap);
        AOSI_casePowerOfOneHandler.powerOfOne(Trigger.New,Trigger.OldMap);
    }
}