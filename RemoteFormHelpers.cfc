<cfcomponent output="false" mixin="controller">

	<cffunction name="init">
		<cfset this.version = "1.1,1.1.1">
		<cfreturn this>
	</cffunction>

	<cffunction name="pageVisualEffect" access="public" output="false" hint="Creates a visual effect at the specified selector (uses jQuery's UI library)">
		<cfargument name="selector" type="string" required="true" hint="The class or ID of the content you wish to insert HTML into" />
		<cfargument name="name" type="string" required="true" hint="The name of the effect to use, possible values are: 'blind', 'bounce', 'clip', 'drop', 'explode', 'fold', 'highlight', 'puff', 'pulsate', 'scale', 'shake', 'size', 'slide', 'transfer'" />
		<cfargument name="duration" type="string" required="false" hint="A string representing one of the three predefined speeds ('slow', 'normal', or 'fast') or the number of milliseconds to run the animation (e.g. 1000)." />
		
		<cfset var loc = {}>
				
		<cfset loc.result = "$('#arguments.selector#').effect('#arguments.name#', '#arguments.duration#');">

		<cfreturn loc.result />
	</cffunction>

	<cffunction name="pageInsertHTML" access="public" output="false" hint="Inserts HTML content at the specified position and HTML element">
		<cfargument name="selector" type="string" required="true" hint="The class or ID of the content you wish to insert HTML into" />
		<cfargument name="position" type="string" required="false" default="before" hint="Position to insert the content into" />
		<cfargument name="content" type="string" required="false" hint="HTML to insert into" />
		<cfargument name="partial" type="string" required="false" hint="Partial file containing the HTML you wish to insert to" />

		<cfset var loc = {}>

		<cfswitch expression="#arguments.position#">
			<cfcase value="before">
				<cfset arguments.position = "prepend">
			</cfcase>
			<cfcase value="after">
				<cfset arguments.position = "append">
			</cfcase>
			<cfdefaultcase>
				<!--- Throw informative Wheels error --->
			</cfdefaultcase>
		</cfswitch>

		<cfif StructKeyExists(arguments, "content")>
			<cfset loc.HTMLContent = JSStringFormat(arguments.content)>
		<cfelseif StructKeyExists(arguments, "partial")>
			<cfset loc.HTMLContent = JSStringFormat(includePartial(arguments.partial))>
		<cfelse>
			<!--- Throw informative Wheels error --->
		</cfif>

		<cfset loc.resultHTML = "$('#arguments.selector#').#arguments.position#('#loc.HTMLContent#');">

		<cfreturn loc.resultHTML />
	</cffunction>

	<cffunction name="pageReplaceHTML" access="public" output="false" hint="Replace the HTML content of the specified element">
		<cfargument name="selector" type="string" required="true" hint="The class or ID of the content you wish to insert HTML into" />
		<cfargument name="content" type="string" required="false" hint="HTML to replace with" />
		<cfargument name="partial" type="string" required="false" hint="Partial file containing the HTML you wish to replace with" />

		<cfset var loc = {}>

		<cfif StructKeyExists(arguments, "content")>
			<cfset loc.HTMLContent = JSStringFormat(arguments.content)>
		<cfelseif StructKeyExists(arguments, "partial")>
			<cfset loc.HTMLContent = JSStringFormat(includePartial(arguments.partial))>
		<cfelse>
			<!--- Throw informative Wheels error --->
		</cfif>

		<cfset loc.resultHTML = "$('#arguments.selector#').html('#loc.HTMLContent#');">

		<cfreturn loc.resultHTML />
	</cffunction>

	<cffunction name="pageRemove" access="public" output="false" hint="Removes the specified element">
		<cfargument name="selector" type="string" required="true" hint="The class or ID of the content you wish to insert HTML into" />
		<!---<cfargument name="options" type="string" required="false" hint="jQuery specific options to the apply to the remove function" />--->

		<cfset var loc = {}>

		<cfset loc.resultHTML = "$('#arguments.selector#').remove();">

		<cfreturn loc.resultHTML />
	</cffunction>

	<cffunction name="pageHide" access="public" output="false" hint="Hides the specified element">
		<cfargument name="selector" type="string" required="true" hint="The class or ID of the content you wish to hide" />

		<cfset var loc = {}>

		<cfset loc.resultHTML = "$('#arguments.selector#').hide();">
		
		<cfreturn loc.resultHTML />
	</cffunction>

	<cffunction name="pageShow" access="public" output="false" hint="Shows the specified element">
		<cfargument name="selector" type="string" required="true" hint="The class or ID of the content you wish to show" />

		<cfset var loc = {}>

		<cfset loc.resultHTML = "$('#arguments.selector#').show();">

		<cfreturn loc.resultHTML />
	</cffunction>

	<cffunction name="pageRedirectTo" access="public" output="false" hint="Redirects the user to the desired location according to Wheels `urlFor` rules">
		
		<cfset var loc = {}>

		<cfset loc.resultHTML = "window.location.replace('#URLFor(argumentCollection = arguments)#');">
		
		<cfreturn loc.resultHTML />
	</cffunction>
	
	<cffunction name="pageInsertFlash" hint="Dynamically inserts a specified flash key into the DOM.">
		<cfargument name="key" type="string" required="false">
		<cfargument name="selector" type="string" required="false" default=".flash-messages">
		<cfargument name="reset" type="boolean" required="false" default="true" hint="If this is set to true, anything leftover in the flash div will be cleared.">
		
		<cfscript>
			var loc = {};
			loc.returnJS = "";
			
			if (arguments.reset)
				loc.returnJS = pageReplaceHTML(selector=arguments.selector, content="");
			
			if (structKeyExists(arguments, "key")) {
				loc.content = "<p class=""" & arguments.key & """>" & flash(arguments.key) & "</p>";
				loc.returnJS = pageReplaceHTML(selector=arguments.selector, content=loc.content);
			} else {
				loc.flashCollection = flash();
				for (key in loc.flashCollection) {
					loc.flashElement = structFind(loc.flashCollection, key);
					loc.content = "<p class=""" & LCase(key) & """>" & loc.flashElement &"</p>";
					loc.returnJS = loc.returnJS & '' & pageInsertHTML(selector=arguments.selector, content=loc.content);
				}
			}
		</cfscript>
		<cfreturn loc.returnJS>
	</cffunction>
	
	<!--- Wheels overwrites --->
	
	<cffunction name="startFormTag" returntype="string" access="public" output="false" hint="">
		<cfargument name="method" type="string" required="false" hint="The type of method to use in the form tag. `get` and `post` are the options.">
		<cfargument name="multipart" type="boolean" required="false" hint="Set to `true` if the form should be able to upload files.">
		<cfargument name="spamProtection" type="boolean" required="false" hint="Set to `true` to protect the form against spammers (done with JavaScript).">
		<cfargument name="route" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="controller" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="action" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="key" type="any" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="params" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="onlyPath" type="boolean" required="false" hint="See documentation for @URLFor.">
		<cfargument name="host" type="string" required="false" hint="See documentation for @URLFor.">
		<cfargument name="protocol" type="string" required="false" hint="See documentation for @URLFor.">
		<cfargument name="port" type="numeric" required="false" hint="See documentation for @URLFor.">
		<cfscript>
			var loc = {};
			$args(name="startFormTag", args=arguments);

			// sets a flag to indicate whether we use get or post on this form, used when obfuscating params
			request.wheels.currentFormMethod = arguments.method;

			// set the form's action attribute to the URL that we want to send to
			if (!ReFindNoCase("^https?:\/\/", arguments.action))
				arguments.action = URLFor(argumentCollection=arguments);

			// make sure we return XHMTL compliant code
			arguments.action = toXHTML(arguments.action);

			// deletes the action attribute and instead adds some tricky javascript spam protection to the onsubmit attribute
			if (arguments.spamProtection)
			{
				loc.onsubmit = "this.action='#Left(arguments.action, int((Len(arguments.action)/2)))#'+'#Right(arguments.action, ceiling((Len(arguments.action)/2)))#';";
				arguments.onsubmit = $addToJavaScriptAttribute(name="onsubmit", content=loc.onsubmit, attributes=arguments);
				StructDelete(arguments, "action");
			}

			// set the form to be able to handle file uploads
			if (!StructKeyExists(arguments, "enctype") && arguments.multipart)
				arguments.enctype = "multipart/form-data";
			
			if (StructKeyExists(arguments, "remote") && IsBoolean(arguments.remote))
				arguments["data-remote"] = arguments.remote;
			
			loc.skip = "multipart,spamProtection,route,controller,key,params,anchor,onlyPath,host,protocol,port,remote";
			if (Len(arguments.route))
				loc.skip = ListAppend(loc.skip, $routeVariables(argumentCollection=arguments)); // variables passed in as route arguments should not be added to the html element
			if (ListFind(loc.skip, "action"))
				loc.skip = ListDeleteAt(loc.skip, ListFind(loc.skip, "action")); // need to re-add action here even if it was removed due to being a route variable above

			loc.returnValue = $tag(name="form", skip=loc.skip, attributes=arguments);
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="linkTo" returntype="string" access="public" output="false" hint="">
		<cfargument name="text" type="string" required="false" default="" hint="The text content of the link.">
		<cfargument name="confirm" type="string" required="false" default="" hint="Pass a message here to cause a JavaScript confirmation dialog box to pop up containing the message.">
		<cfargument name="route" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="controller" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="action" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="key" type="any" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="params" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="onlyPath" type="boolean" required="false" hint="See documentation for @URLFor.">
		<cfargument name="host" type="string" required="false" hint="See documentation for @URLFor.">
		<cfargument name="protocol" type="string" required="false" hint="See documentation for @URLFor.">
		<cfargument name="port" type="numeric" required="false" hint="See documentation for @URLFor.">
		<cfargument name="href" type="string" required="false" hint="Pass a link to an external site here if you want to bypass the Wheels routing system altogether and link to an external URL.">
		<cfscript>
			var loc = {};
			loc.returnValue = $args(name="linkTo", cachable=true, args=arguments);
			if (!StructKeyExists(loc, "returnValue"))
			{
				// only run our linkTo code if we do not have a cached result
				if (Len(arguments.confirm))
					arguments["data-confirm"] = JSStringFormat(arguments.confirm);
				if (StructKeyExists(arguments, "remote") && IsBoolean(arguments.remote))
					arguments["data-remote"] = arguments.remote;
				if (!StructKeyExists(arguments, "href"))
					arguments.href = URLFor(argumentCollection=arguments);
				arguments.href = toXHTML(arguments.href);
				if (!Len(arguments.text))
					arguments.text = arguments.href;
				loc.skip = "text,confirm,route,controller,action,key,params,anchor,onlyPath,host,protocol,port,remote";
				if (Len(arguments.route))
					loc.skip = ListAppend(loc.skip, $routeVariables(argumentCollection=arguments)); // variables passed in as route arguments should not be added to the html element
				loc.returnValue = $element(name="a", skip=loc.skip, content=arguments.text, attributes=arguments);
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="buttonTo" returntype="string" access="public" output="false" hint="">
		<cfargument name="text" type="string" required="false" hint="The text content of the button.">
		<cfargument name="confirm" type="string" required="false" hint="See documentation for @linkTo.">
		<cfargument name="image" type="string" required="false" hint="If you want to use an image for the button pass in the link to it here (relative from the `images` folder).">
		<cfargument name="disable" type="any" required="false" hint="Pass in `true` if you want the button to be disabled when clicked (can help prevent multiple clicks), or pass in a string if you want the button disabled and the text on the button updated (to ""please wait..."", for example).">
		<cfargument name="route" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="controller" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="action" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="key" type="any" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="params" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for @URLFor.">
		<cfargument name="onlyPath" type="boolean" required="false" hint="See documentation for @URLFor.">
		<cfargument name="host" type="string" required="false" hint="See documentation for @URLFor.">
		<cfargument name="protocol" type="string" required="false" hint="See documentation for @URLFor.">
		<cfargument name="port" type="numeric" required="false" hint="See documentation for @URLFor.">
		<cfscript>
			var loc = {};
			$args(name="buttonTo", reserved="method", args=arguments);
			arguments.action = URLFor(argumentCollection=arguments);
			arguments.action = toXHTML(arguments.action);
			arguments.method = "post";
			if (Len(arguments.confirm))
				loc.submitTagArguments["data-confirm"] = JSStringFormat(arguments.confirm);
			if (StructKeyExists(arguments, "remote") && IsBoolean(arguments.remote))
				arguments["data-remote"] = arguments.remote;
			if (Len(arguments.disable))
				loc.submitTagArguments["data-disable-with"] = JSStringFormat(arguments.disable);
			
			loc.submitTagArguments.value = arguments.text;
			loc.submitTagArguments.image = arguments.image;
			loc.content = submitTag(argumentCollection=loc.submitTagArguments);
			loc.skip = "disable,image,text,confirm,route,controller,key,params,anchor,onlyPath,host,protocol,port,remote";
			if (Len(arguments.route))
				loc.skip = ListAppend(loc.skip, $routeVariables(argumentCollection=arguments)); // variables passed in as route arguments should not be added to the html element
			loc.returnValue = $element(name="form", skip=loc.skip, content=loc.content, attributes=arguments);
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="submitTag" returntype="string" access="public" output="false" hint="">
		<cfargument name="value" type="string" required="false" hint="Message to display in the button form control.">
		<cfargument name="image" type="string" required="false" hint="File name of the image file to use in the button form control.">
		<cfargument name="disable" type="any" required="false" hint="Whether or not to disable the button upon clicking. (prevents double-clicking.)">
		<cfscript>
			var loc = {};
			$args(name="submitTag", reserved="type,src", args=arguments);
			if (Len(arguments.disable))
				arguments["data-disable-with"] = JSStringFormat(arguments.disable);
			if (Len(arguments.image))
			{
				// create an img tag and then just replace "img" with "input"
				arguments.type = "image";
				arguments.source = arguments.image;
				StructDelete(arguments, "value");
				StructDelete(arguments, "image");
				StructDelete(arguments, "disable");
				loc.returnValue = imageTag(argumentCollection=arguments);
				loc.returnValue = Replace(loc.returnValue, "<img", "<input");
			}
			else
			{
				arguments.type = "submit";
				loc.returnValue = $tag(name="input", close=true, skip="image,disable", attributes=arguments);
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="$requestContentType" access="public" output="false" returntype="string">
		<cfargument name="params" type="struct" required="false" default="#variables.params#" />
		<cfargument name="httpAccept" type="string" required="false" default="#request.cgi.http_accept#" />
		<cfscript>
			var loc = {};
			loc.format = "html";

			// see if we have a format param
			if (StructKeyExists(arguments.params, "format"))
				return arguments.params.format;

			for (loc.item in application.wheels.formats) {
				if (arguments.httpAccept CONTAINS application.wheels.formats[loc.item])
					return loc.item;
			}
		</cfscript>
		<cfreturn loc.format />
	</cffunction>
	
</cfcomponent>