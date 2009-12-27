<cfcomponent output="false" mixin="controller">

	<cffunction name="init">
		<cfset this.version = "1.0">
		<cfreturn this>
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
		<cfargument name="onSuccessCallback" type="string" required="false" default="onSubmitSuccess" hint="callback name when the ajax call success" />
		<cfargument name="onErrorCallback" type="string" required="false" default="onSubmitError" hint="callback name when the ajax call fails" />
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
			arguments.onSubmit = "$.ajax({ type: '#arguments.method#', url: '#arguments.action#', success: function(data, textStatus){#arguments.onSuccessCallback#(data, textStatus);}, error: function(XMLHttpRequest, textStatus, errorThrown){#arguments.onErrorCallback#(XMLHttpRequest, textStatus, errorThrown);}, data: $(this).serialize()}); return false;";
			
			loc.returnValue = $tag(name="form", skip=loc.skip, attributes=arguments);
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="endRemoteFormTag" returntype="string" access="public" output="false"
		hint="Builds and returns a string containing the closing `form` tag.">
		<cfscript>
			if (StructKeyExists(request.wheels, "currentFormMethod"))
				StructDelete(request.wheels, "currentFormMethod");
		</cfscript>
		<cfreturn "</form>">
	</cffunction>
	
</cfcomponent>