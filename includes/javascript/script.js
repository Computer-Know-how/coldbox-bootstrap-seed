$(document).ready(function() {
	//Setup tooltips
	$("[rel=tooltip]").tooltip();
	
	//Setup Popovers
	$("[rel=popover]").popover();

	//Setup Datepickers
	$(".datepicker").datepicker();

	//Setup WYSIWYG Editors
	$(".wysiwyg").wysihtml5();

	//Flicker messages
	var t=setTimeout("toggleFlickers()",5000);

	//Multiselects
	$('select[multiple]').wl_Multiselect();

	$('#deleteConfirm').bind('show', function() {
		//setup our variables
		var newUrl = $(this).data('href'),
	        deleteButton = $(this).find('##deleteButton')

	    //set the delete button for the respective action
		deleteButton.attr('href', newUrl);
	})

	$('.confirm-delete').click(function(e) {
	    //prevent the default click action
		e.preventDefault();

	    //get the href of the delete button
		var href = $(this).attr('href');
	    $('#deleteConfirm').data('href', href).modal('show');
	});

	//setup the datatable
	$('#boardMeetings').dataTable( {
		"sDom": "lfrtip",
		"sPaginationType": "bootstrap",
		"oLanguage": {
			"sLengthMenu": "_MENU_ records per page"
		},
		"bDestroy" : true,
		"aoColumns": [
			{ "sType": "date" },
			null,
			null
		]
	} );

});

function toggleFlickers(){
	$(".flickerMessages, [class^=cbox_messagebox]").slideToggle();
}

/**
  * Return true, if the value is a valid date, also making this formal check mm/dd/yyyy.
  *
  * @example jQuery.validator.methods.date("01/01/1900")
  * @result true
  *
  * @example jQuery.validator.methods.date("13/01/1990")
  * @result false
  *
  * @example jQuery.validator.methods.date("01.01.1900")
  * @result false
  *
  * @example <input name="pippo" class="dateUS" />
  * @desc Declares an optional input element whose value must be a valid date.
  *
  * @name jQuery.validator.methods.dateUS
  * @type Boolean
  * @cat Plugins/Validate/Methods
  */

jQuery.validator.addMethod(
	"dateUS",
	function(value, element) {
		var check = false;
		var re = /^\d{1,2}\/\d{1,2}\/\d{4}$/;
		if( re.test(value)){
			var adata = value.split('/');
			var mm = parseInt(adata[0],10);
			var dd = parseInt(adata[1],10);
			var yyyy = parseInt(adata[2],10);
			var xdata = new Date(yyyy,mm-1,dd);
			if ( ( xdata.getFullYear() == yyyy ) && ( xdata.getMonth () == mm - 1 ) && ( xdata.getDate() == dd ) )
				check = true;
			else
				check = false;
		} else
			check = false;
		return this.optional(element) || check;
	},
	"Please enter a date in the format mm/dd/yyyy"
);