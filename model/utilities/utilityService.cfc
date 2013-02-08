component hint="I handle some general utilites functions of the system" output="false" singleton="true"
{
	/* Constructor*/
	public any function init()
	 	hint="I am the constructor for this class"
	 	output="false"
	{
		return this;
	}

	/**
	* Returns a random alphanumeric string of a user-specified length.
	*
	* @param stringLenth      Length of random string to generate. (Required)
	* @return Returns a string.
	* @author Kenneth Rainey (kip.rainey@incapital.com)
	* @version 1, February 3, 2004
	*/
	function getRandString(stringLength) {
		var tempAlphaList = "a|b|c|d|e|g|h|i|k|L|m|n|o|p|q|r|s|t|u|v|w|x|y|z";
		var tempNumList = "1|2|3|4|5|6|7|8|9|0";
		var tempCompositeList = tempAlphaList&"|"&tempNumList;
		var tempCharsInList = listLen(tempCompositeList,"|");
		var tempCounter = 1;
		var tempWorkingString = "";

		//loop from 1 to stringLength to generate string
		while (tempCounter LTE stringLength) {
		    tempWorkingString = tempWorkingString&listGetAt(tempCompositeList,randRange(1,tempCharsInList),"|");
		    tempCounter = tempCounter + 1;
		}

		return tempWorkingString;
	}
}