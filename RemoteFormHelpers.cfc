<cfcomponent output="false" mixin="controller">

	<cffunction name="init">
		<cfset this.version = "1.1">
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

	<cffunction name="renderRemotePage" access="public" output="false" hint="Renders the specified remote view, it will append a '.js' value to the current action, or the value specified in the 'action' argument. So your filename should be [action].js.cfm">
		<cfargument name="action" type="string" default="#params.action#" />

		<!--- Render the page with no layout and with a suffix of "js" --->
		<cfreturn renderPage(action="#arguments.action#.js", layout=false)>
	</cffunction>

	<cffunction name="startRemoteFormTag" returntype="string" access="public" output="false"
		hint="Builds and returns a string containing the opening form tag. The form's action will be built according to the same rules as `URLFor`.">
		<cfargument name="method" type="string" required="false" default="#application.wheels.functions.startFormTag.method#" hint="See documentation for @startFormTag">
		<cfargument name="route" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="controller" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="action" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="key" type="any" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="params" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="onlyPath" type="boolean" required="false" default="#application.wheels.functions.startFormTag.onlyPath#" hint="See documentation for @URLFor">
		<cfargument name="host" type="string" required="false" default="#application.wheels.functions.startFormTag.host#" hint="See documentation for @URLFor">
		<cfargument name="protocol" type="string" required="false" default="#application.wheels.functions.startFormTag.protocol#" hint="See documentation for @URLFor">
		<cfargument name="port" type="numeric" required="false" default="#application.wheels.functions.startFormTag.port#" hint="See documentation for @URLFor">
		<cfargument name="onSuccess" type="string" required="false" hint="Function to execute when the ajax request succeeds" />
		<cfargument name="onError" type="string" required="false" hint="Function to execute when the ajax request fails" />
		<cfargument name="onComplete" type="string" required="false" hint="Function to execute when the ajax request is complete (runs on error and success)" />
		<cfargument name="onBeforeSend" type="string" required="false" hint="Function to execute before the ajax request is sent." />

		<cfscript>
			var loc = {};
			$args(name="startFormTag", args=arguments);

			// sets a flag to indicate whether we use get or post on this form, used when obfuscating params
			request.wheels.currentFormMethod = arguments.method;

			// set the form's action attribute to the URL that we want to send to
			arguments.action = URLFor(argumentCollection=arguments);

			// make sure we return XHMTL compliant code
			arguments.action = Replace(arguments.action, "&", "&amp;", "all");

			loc.skip = "route,controller,key,params,anchor,onlyPath,host,protocol,port,onSuccess,onError,onComplete,onBeforeSend";
			if (Len(arguments.route))
				loc.skip = ListAppend(loc.skip, $routeVariables(argumentCollection=arguments)); // variables passed in as route arguments should not be added to the html element
			if (ListFind(loc.skip, "action"))
				loc.skip = ListDeleteAt(loc.skip, ListFind(loc.skip, "action")); // need to re-add action here even if it was removed due to being a route variable above

			// setup the onSubmit attribute
			arguments.onSubmit = $ajaxSetup(argumentCollection=arguments);

			loc.returnValue = $tag(name="form", skip=loc.skip, attributes=arguments);
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

	<cffunction name="endRemoteFormTag" returntype="string" access="public" output="false"
		hint="Builds and returns a string containing the closing `form` tag.">
		<cfreturn endFormTag()>
	</cffunction>

	<cffunction name="remoteLinkTo" returntype="string" access="public" output="false"
		hint="Creates an AJAX link to another page in your application.">
		<cfargument name="text" type="string" required="false" default="" hint="See documentation for @linkTo">
		<cfargument name="confirm" type="string" required="false" default="" hint="See documentation for @linkTo">
		<cfargument name="route" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="controller" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="action" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="key" type="any" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="params" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="anchor" type="string" required="false" default="" hint="See documentation for @URLFor">
		<cfargument name="onlyPath" type="boolean" required="false" default="#application.wheels.functions.linkTo.onlyPath#" hint="See documentation for @URLFor">
		<cfargument name="host" type="string" required="false" default="#application.wheels.functions.linkTo.host#" hint="See documentation for @URLFor">
		<cfargument name="protocol" type="string" required="false" default="#application.wheels.functions.linkTo.protocol#" hint="See documentation for @URLFor">
		<cfargument name="port" type="numeric" required="false" default="#application.wheels.functions.linkTo.port#" hint="See documentation for @URLFor">
		<cfargument name="onSuccess" type="string" required="false" hint="Function to execute when the ajax request succeeds" />
		<cfargument name="onError" type="string" required="false" hint="Function to execute when the ajax request fails" />
		<cfargument name="onComplete" type="string" required="false" hint="Function to execute when the ajax request is complete (runs on error and success)" />
		<cfargument name="onBeforeSend" type="string" required="false" hint="Function to execute before the ajax request is sent." />

		<cfscript>
			var loc = {};
			$args(name="linkTo", reserved="href", args=arguments);

			arguments.href = URLFor(argumentCollection=arguments);
			arguments.href = Replace(arguments.href, "&", "&amp;", "all"); // make sure we return XHMTL compliant code

			// Setup the onClick attribute
			arguments.onClick = $ajaxSetup(argumentCollection=arguments);

			if (Len(arguments.confirm)){
				arguments.onClick = "if (!confirm('#arguments.confirm#')) { return false; };" & arguments.onClick;
				/* arguments.onclick = $addToJavaScriptAttribute(name="onclick", content=loc.onclick, attributes=arguments); */
			}

			if (!Len(arguments.text))
				arguments.text = arguments.href;
			loc.skip = "text,confirm,route,controller,action,key,params,anchor,onlyPath,host,protocol,port,onSuccess,onError,onComplete,onBeforeSend";
			if (Len(arguments.route))
				loc.skip = ListAppend(loc.skip, $routeVariables(argumentCollection=arguments)); // variables passed in as route arguments should not be added to the html element

			loc.returnValue = $element(name="a", skip=loc.skip, content=arguments.text, attributes=arguments);
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

	<cffunction name="remoteButtonTo" access="public" returnType="string" output="false"
		hint="Creates an AJAX button to another page in your application.">
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
		<cfargument name="onSuccess" type="string" required="false" hint="Function to execute when the ajax request succeeds" />
		<cfargument name="onError" type="string" required="false" hint="Function to execute when the ajax request fails" />
		<cfargument name="onComplete" type="string" required="false" hint="Function to execute when the ajax request is complete (runs on error and success)" />
		<cfargument name="onBeforeSend" type="string" required="false" hint="Function to execute before the ajax request is sent." />
		
		<cfscript>
			var loc = {};
			var loc.onClick = "";
			
			$args(name="buttonTo", args=arguments);
			
			// sets a flag to indicate whether we use get or post on this form, used when obfuscating params
			arguments.method = "post";
			request.wheels.currentFormMethod = arguments.method;
				
			arguments.action = URLFor(argumentCollection=arguments);
			arguments.action = Replace(arguments.action, "&", "&amp;", "all");
			
			if (Len(arguments.confirm))
				loc.onClick = "return confirm('#arguments.confirm#')";
				
			loc.content = submitTag(value=arguments.text, image=arguments.image, disable=arguments.disable,onClick=loc.onClick);
			
			loc.skip = "confirm,disable,image,route,controller,key,params,anchor,onlyPath,host,protocol,port,onSuccess,onError,onComplete,onBeforeSend";
			if (Len(arguments.route))
				loc.skip = ListAppend(loc.skip, $routeVariables(argumentCollection=arguments)); // variables passed in as route arguments should not be added to the html element
			if (ListFind(loc.skip, "action"))
				loc.skip = ListDeleteAt(loc.skip, ListFind(loc.skip, "action")); // need to re-add action here even if it was removed due to being a route variable above
			
			// Setup the onSubmit attribute
			arguments.onSubmit = $ajaxSetup(argumentCollection=arguments);
				
			loc.returnValue = $element(name="form", skip=loc.skip, content=loc.content, attributes=arguments);
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

	<cffunction name="renderJavascript" hint="Renders either a partial or HTML content to a DOM object.">
		<cfargument name="selector" type="string" required="true">
		<cfargument name="content" type="string" required="false">
		<cfargument name="partial" type="string" required="false">
		<cfargument name="includeFlash" type="boolean" required="false" default="true">
			
		<cfcontent type="text/javascript">
		<cfscript>
			var loc = {};
			var loc.returnJS = "";
			
			if (arguments.includeFlash)
				loc.returnJS = pageInsertFlash();
				
			loc.returnJS = loc.returnJS & '' & pageReplaceHTML(argumentCollection=arguments);
			
			renderText(loc.returnJS);
		</cfscript>
	</cffunction>
	
	<cffunction name="pageInsertFlash" hint="Dynamically inserts a specified flash key into the DOM.">
		<cfargument name="key" type="string" required="false">
		<cfargument name="selector" type="string" required="false" default=".flash-messages">
		<cfargument name="reset" type="boolean" required="false" default="true" hint="If this is set to true, anything leftover in the flash div will be cleared.">
		
		<cfscript>
			var loc = {};
			var loc.returnJS = "";
			
			if (arguments.reset)
				var loc.returnJS = pageReplaceHTML(selector=arguments.selector, content="");
			
			if (structKeyExists(arguments, "key")) {
				loc.content = "<p class=""" & arguments.key & """>" & flash(arguments.key) & "</p>";
				loc.returnJS = pageReplaceHTML(selector=arguments.selector, content=loc.content);
			} else {
				var loc.flashCollection = flash();
				for (key in loc.flashCollection) {
					var loc.flashElement = structFind(loc.flashCollection, key);
					loc.content = "<p class=""" & LCase(key) & """>" & loc.flashElement &"</p>";
					loc.returnJS = loc.returnJS & '' & pageInsertHTML(selector=arguments.selector, content=loc.content);
				}
			}
		</cfscript>
		<cfreturn loc.returnJS>
	</cffunction>
	
	<cffunction name="$ajaxSetup" access="public" returnType="string" output="false">

		<cfset var loc = {}>

		<!--- setup the .ajax method --->
		<cfset loc.returnValue = "$.ajax({ dataType: 'script'">

		<!--- If this is a form, use the serialize method for the data and the action argument --->
		<cfif NOT StructKeyExists(arguments, "href")>
			<cfset loc.returnValue = loc.returnValue & ", type: '#arguments.method#', url: '#arguments.action#', data: $(this).serialize()">
		<cfelse>
			<cfset loc.returnValue = loc.returnValue & ", url: '#arguments.href#'">
		</cfif>

		<!--- add only the passed in callbacks --->
		<cfif StructKeyExists(arguments, "onSuccess")>
			<cfset loc.returnValue = loc.returnValue & ", success: function(data, textStatus){#arguments.onSuccess#}">
		</cfif>
		<cfif StructKeyExists(arguments, "onError")>
			<cfset loc.returnValue = loc.returnValue & ", error: function(XMLHttpRequest, textStatus, errorThrown){#arguments.onError#}">
		</cfif>
		<cfif StructKeyExists(arguments, "onBeforeSend")>
			<cfset loc.returnValue = loc.returnValue & ", beforeSend: function(XMLHttpRequest){#arguments.onBeforeSend#}">
		</cfif>
		<cfif StructKeyExists(arguments, "onComplete")>
			<cfset loc.returnValue = loc.returnValue & ", complete: function(XMLHttpRequest, textStatus){#arguments.onComplete#}">
		</cfif>

		<!--- Close the line --->
		<cfset loc.returnValue = loc.returnValue & "}); return false;">

		<cfreturn loc.returnValue />
	</cffunction>

</cfcomponent>