<!DOCTYPE html>
<html >
<head>

	<title>任务栏</title>
	<link rel="stylesheet" href="../style/9/jquery-ui-1.7.2.custom.css" type="text/css">
	<link rel="stylesheet" href="../style/9/task_form.css" type="text/css">
	
	<script type="text/javascript" src="script/jquery-1.3.2.min.js"></script>
	<script type="text/javascript" src="script/jquery-ui-1.7.2.custom.min.js"></script>

	<script type="text/javascript">
		$(document).ready(
			function() {
				$("#tabs").tabs();
			}
		);
	</script>

</head>
<body>

<div id="page-header" class="ui-widget-header">
	<a href="http://www.jazzanowak.de" class="icon home" title="Home"><span class="ui-icon ui-icon-home"> </span></a>
	<h1>jQuery Sticky Notes Plugin</h1>
	<div id="twitter"><a href="http://twitter.com/danielnowak" title="Updates posted on Twitter"><img src="images/twitter_1.png" alt="Twitter.com" width="32" height="32" /></a></div>
</div>
<div id="tabs">

	<ul>
		<li><a href="#tab1">Getting Started</a></li>

		<li><a href="#tab2">Demo</a></li>
		<li><a href="#tab3">Options</a></li>		
		<li><a href="#tab7">Download</a></li>
	</ul>
	<div id="tab1" data-tabid="getting-started">
		        <h1>Overview</h1>
		        <p>The jQuery Sticky Notes Plugin allows you to easily and unobtrusively add sticky notes on your website. <br/>

		 		This sticky notes plugin was created because the original <a href="http://plugins.jquery.com/project/ui-sticky">plugin</a> has not fit my usability needs.</p>
		        <h1>Quick Start Guide</h1>
		        <div class="step-holder">
					<span class="step-counter ui-widget-header ui-corner-all">1</span>
					Add a div to your page with fixed width and height:
		        <pre><code class="mix">

&lt;div id="notes" style="width:800px;height:600px;"&gt;
&lt;/div&gt;</code></pre>
				</div>
				
		        <div class="step-holder"><span class="step-counter ui-widget-header ui-corner-all">2</span>
				Include jQuery, jQuery UI (draggable and resiable are needed), the Stick Notes Plugin, a CSS files and a short script to
		        initialize the the notes container when the <abbr title="Document Object Model">DOM</abbr> is ready:
		        <pre><code class="mix">&lt;html&gt;
&lt;head&gt;

    &lt;script type="text/javascript" src="jquery-1.3.2.min.js"&gt;&lt;/script&gt;
    &lt;script type="text/javascript" src="jquery.ui-1.7.2.custom.min.js"&gt;&lt;/script&gt;
    &lt;script type="text/javascript" src="jquery.stickynotes.js"&gt;&lt;/script&gt;
    &lt;link rel="stylesheet" href="jquery.stickynotes.css" type="text/css"&gt;

    &lt;script type="text/javascript"&gt;

        // wait for the DOM to be loaded
        $(document).ready(function() {
            $('#notes').stickyNotes();
        });
    &lt;/script&gt;
&lt;/head&gt;
...</code></pre>
			</div>

		    <p><strong>That's it!</strong></p>
	</div>
	<div id="tab2" data-tabid="demo">

		
        <h1>Demo</h1>
		<div>
			
			<h2>Usage</h1>
				<p>				
				<ol>
					<li>Create a note by clicking on the add note button.</li>	
					<li>Edit the note.</li>						
					<li>Stop editing the note by clicking on the wooden background.</li>											
					<li>Reedit the note by double clicking on the notes text.</li>											
					<li>Resize the note with the small icon on the right bottom corner of the note.</li>											
					<li>Reposition the note by dragging it on the the wooden background.</li>		
					<li>Delete the note by clicking on the cross in the left top corner of the note.</li>

				</ol>		
			</p>
		</div>


		<div id="notes" style="width:1000px;height:600px;">
		</div>
		<script type="text/javascript" src="script/jquery.stickynotes.js"></script>
		<link rel="stylesheet" href="css/jquery.stickynotes.css" type="text/css">
		
		<script type="text/javascript" charset="utf-8">
		
			jQuery(document).ready(function() {
				var options = {
					notes:[{"id":1,
					      "text":"Test Internet Explorer",
						  "pos_x": 50,
						  "pos_y": 50,	
						  "width": 200,
						  "height": 200													
					    }]
				};
				jQuery("#notes").stickyNotes(options);
			});
		</script>

	</div>
	
	<div id="tab3" data-tabid="options-object">
		        <h1>Options</h1>
		        <dl class="options">
		        <dt>notes</dt>
		        <dd><p>The notes that are rendered initialy on the board.</p>
					<p>Example:

<pre><code class="mix">
var options = {notes:[{"id":1,
	"text":"Test Internet Explorer",
	"pos_x": 50,
	"pos_y": 50,	
	"width": 200,							
	"height": 200,													
}]}
jQuery("#notes").stickyNotes(options);
</code></pre></p>					
		        </dd>
		        <dt>resizable</dt>
		        <dd>
					<p>A flag that defines whether the notes are resizeable.<br/> Default value: true</p>
					<p>Example:
<pre><code class="mix">

var options = {resizable:false}
jQuery("#notes").stickyNotes(options);
</code></pre></p>					
		        </dd>
		        <dt>controls</dt>
		        <dd><p>A flag that defines whether the controlls (add note button) should be rendered.<br/> Default value: true</p>
<p>Example:
<pre><code class="mix">
var options = {controls:false}
jQuery("#notes").stickyNotes(options);
</code></pre></p>			
			
		        </dd>
		        <dt>editCallback</dt>

		        <dd><p>Callback function to be invoked after a note was edited.</p>
<p>Example:
<pre><code class="mix">
var edited = function(note) {
	alert("Edited note with id " + note.id + ", new text : " + note.text);
}
var options = {editCallback: edited}
jQuery("#notes").stickyNotes(options);
</code></pre></p>			
			
		        </dd>

		        <dt>createCallback</dt>
				<dd><p>Callback function to be invoked after a note was created.</p>
<p>Example:
<pre><code class="mix">

var created = function(note) {
	alert("Created note with id " + note.id + ", text : " + note.text);
}
var options = {createCallback: created}
jQuery("#notes").stickyNotes(options);
</code></pre></p>					
				</dd>
		        <dt>deleteCallback</dt>
		        <dd><p>Callback function to be invoked after a note was deleted.</p>
<p>Example:
<pre><code class="mix">
var deleted = function(note) {
	alert("Deleted note with id " + note.id + ", text : " + note.text);
}
var options = {deleteCallback: deleted}
jQuery("#notes").stickyNotes(options);
</code></pre></p>					
			
		        </dd>
		        <dt>moveCallback</dt>

		        <dd><p>Callback function to be invoked after a note was moved.</p>
<p>Example:
<pre><code class="javascript">
var moved = function(note) {
	alert("Moved note with id " + note.id + ", text : " + note.text);
}
var options = {moveCallback: moved}
jQuery("#notes").stickyNotes(options);
</code></pre></p>					

				</dd>
		        <dt>resizeCallback</dt>
		        <dd><p>Callback function to be invoked after a note was resized.</p>
<p>Example:
<pre><code class="javascript">
var resized = function(note) {
	alert("Resized note with id " + note.id + ", text : " + note.text);
}
var options = {resizeCallback: resized}
jQuery("#notes").stickyNotes(options);

</code></pre></p>					

				</dd>
	</div>
	
	

	<div id="tab7" data-tabid="download">

		<h1>Download</h1>
        <p>
		The Sticky Notes Plugin can be downloaded from <a href="https://code.google.com/p/jquery-sticky-notes/">Google Code</a>.
        <p />

        <p />
        <h1>Support</h1>
        Support for the jQuery Form Plugin is available through the
        <a class="external" href="http://groups.google.com/group/jquery-sticky-notes">jQuery Sticky Notes Google Group</a>.
        <p />
        <div id="footer">
        This site is maintained by Daniel Nowak.
        </div>
	</div>

</div>
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-1646805-13");
pageTracker._trackPageview();
} catch(err) {}</script>
</body>
</html>
