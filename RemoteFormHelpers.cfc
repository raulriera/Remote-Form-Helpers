<cfcomponent output="false" mixin="controller">

	<cffunction name="init">
		<cfset this.version = "1.0">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="renderRemotePage" access="public" hint="Renders the specified remote view, it will append a '-js' value to the current action, or the value specified in the 'action' argument">
		<cfargument name="action" type="string" default="#params.action#" />
		
		<!--- Render the page with no layout and with a suffix of "js" --->
		<cfreturn renderPage(action="#arguments.action#-js", layout=false)>
	</cffunction>
	
	<cffunction name="startRemoteFormTag" returntype="string" access="public" output="false"
		hint="Builds and returns a string containing the opening form tag. The form's action will be built according to the same rules as `URLFor`.">
		<cfargument name="method" type="string" required="false" default="#application.wheels.functions.startFormTag.method#" hint="The type of method to use in the form tag, `get` and `post` are the options">
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
		<cfargument name="onSuccessCallback" type="string" required="false" hint="callback name when the ajax call succeeds" />
		<cfargument name="onErrorCallback" type="string" required="false" hint="callback name when the ajax call fails" />
		<cfscript>
			var loc = {};
			$insertDefaults(name="startFormTag", input=arguments);
	
			// sets a flag to indicate whether we use get or post on this form, used when obfuscating params
			request.wheels.currentFormMethod = arguments.method;
	
			// set the form's action attribute to the URL that we want to send to
			arguments.action = URLFor(argumentCollection=arguments);
	
			// make sure we return XHMTL compliant code
			arguments.action = Replace(arguments.action, "&", "&amp;", "all");
		
			loc.skip = "route,controller,key,params,anchor,onlyPath,host,protocol,port,onSuccessCallback,onErrorCallback";
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
		<cfargument name="text" type="string" required="false" default="" hint="The text content of the link">
		<cfargument name="confirm" type="string" required="false" default="" hint="Pass a message here to cause a JavaScript confirmation dialog box to pop up containing the message">
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
		<cfargument name="onSuccessCallback" type="string" required="false" hint="callback name when the ajax call succeeds" />
		<cfargument name="onErrorCallback" type="string" required="false" hint="callback name when the ajax call fails" />
		
		<cfscript>
			var loc = {};
			$insertDefaults(name="linkTo", reserved="href", input=arguments);
			
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
			loc.skip = "text,confirm,route,controller,action,key,params,anchor,onlyPath,host,protocol,port,onSuccessCallback,onErrorCallback";
			if (Len(arguments.route))
				loc.skip = ListAppend(loc.skip, $routeVariables(argumentCollection=arguments)); // variables passed in as route arguments should not be added to the html element
						
			loc.returnValue = $element(name="a", skip=loc.skip, content=arguments.text, attributes=arguments);
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="$ajaxSetup" access="public" returnType="string" output="false">
		
		<cfset var loc.returnValue = {}>
		
		<!--- setup the .ajax method --->
		<cfset loc.returnValue = "$.ajax({ type: '#arguments.method#', url: '#arguments.action#', data: $(this).serialize(), dataType: 'script'">
		
		<!--- add only the passed in callbacks --->
		<cfif StructKeyExists(arguments, "onSuccessCallback")>
			<cfset loc.returnValue = loc.returnValue & ", success: function(data, textStatus){#arguments.onSuccessCallback#(data, textStatus);}">
		</cfif>
		<cfif StructKeyExists(arguments, "onErrorCallback")>
			<cfset loc.returnValue = loc.returnValue & ", error: function(XMLHttpRequest, textStatus, errorThrown){#arguments.onErrorCallback#(XMLHttpRequest, textStatus, errorThrown);}">
		</cfif>
		
		
		<!--- todo: add support for the following callbacks 
		beforeSend
		complete --->
		
		<!--- Close the line --->
		<cfset loc.returnValue = loc.returnValue & "}); return false;">
		
		<cfreturn loc.returnValue />
	</cffunction>
	
</cfcomponent>