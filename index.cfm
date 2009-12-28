<h1>Remote Form Helpers</h1>

<p>This plugin will enable Remote Form Helpers (jQuery) in your application, to use it, follow the instructions below.</p>

<h2>Methods added</h2>

<ul>
	<li>startRemoteFormTag</li>
	<li>endRemoteFormTag</li>
</ul>

<h2>Example</h2>

<p>Example code for your `new comment` view</p>

<pre>#startRemoteFormTag(action="create")#
	#textField(objectName="comment", property="name")#	
	#textArea(objectName="comment", property="description")#
		
	#submitTag()#
#endRemoteFormTag()#
	
&lt;script type="text/javascript"&gt;
	function onSubmitSuccess(data, textStatus){
		alert(data);
	}		
	function onSubmitError(XMLHttpRequest, textStatus, errorThrown){
		alert(errorThrown);
	}
&lt;/script&gt;
</pre>

<p>Example code for your `create comment` action</p>

<pre>
&lt;cffunction name="create"&gt;
	&lt;cfset comment = model("Comment").new(params.comment)&gt;
	
	&lt;cfset comment.save()&gt;
	
	&lt;cfset renderText(SerializeJSON(comment))&gt;
&lt;/cffunction&gt;
</pre>

<a href="<cfoutput>#cgi.http_referer#</cfoutput>"><<< Go Back</a>