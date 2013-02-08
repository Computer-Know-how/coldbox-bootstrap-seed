component  hint="I handle validation related functions" output="false"
{
	public validationService function init() {
		return this;
	}

	public function createjQueryRules(target,theURL) {
		if (!structKeyExists(target,"constraints") || structIsEmpty(target.constraints)) {
			return '';
		} else {
			var constraints = target.constraints;
			var rules = "rules: {";
			var messages = "messages: {";
			for (var key in constraints) {
				rules &= key & ": {remote: '";
				rules &= theURL & "/?field=" & key;
				rules &= "'},";
				messages &= key & ":{remote: jQuery.validator.format('{0}')},";
			}
			//remove commas
			var rules = left(rules,len(rules)-1);
			var messages = left(messages,len(messages)-1);
			rules &= "},";
			messages &= "}";
			return rules & messages;
		}
	}

	any function stDevValidate(required any target, required string field, any targetValue){

		var rangeMethod = "get" & field & "Range";

		var range = target.rangeFinder(rangeMethod);

		var min = listFirst( range,'..');
		var max = "";
		if( find("..",range) ){
			max = listLast( range,'..');
		}

		// simple value range evaluations?
		if( !isNull(arguments.targetValue) AND targetValue >= min AND ( !len(max) OR targetValue <= max ) ) {
			return true;
		}

		var message="The '#arguments.field#' value is not in the tolerance range (#min# - #max#).  Ignore this error if you are sure the value is correct";
		return message;
	}

}