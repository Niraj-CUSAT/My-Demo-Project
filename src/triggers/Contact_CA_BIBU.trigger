trigger Contact_CA_BIBU on Contact (before insert,before update) {
if(!Test.isRunningTest())
	QAS_NA.RecordStatusSetter.InvokeRecordStatusSetterConstrained(trigger.new,trigger.old,trigger.IsInsert,2);
}