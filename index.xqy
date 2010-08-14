xquery version '1.0-ml';

(: First we import the library that generates the tree :)
import module namespace mvc = "http://ns.dscape.org/2010/dxc/mvc"
  at "dxc/mvc/mvc.xqy" ;

(: 
 : This function receives a string as the parameter $o
 : which will be either 'a', 'b', 'c' or 'd' and
 : generates an input field for the form
 :)
declare function local:generate-option( $o ) {
 (<br/>, <label for="/question/answer/{$o}">{$o}) </label>,
      <input type="text" name="/question/answer/{$o}" 
        id="/question/answer/{$o}" size="50"/>) };

(: This function simply displays an html form as described in the figures :)
declare function local:display-form() {
  <form name="question_new" method="POST" action="/" id="question_new">
    <input type="hidden" name="/question/created-at" 
      id="/question/created-at" value="{fn:current-dateTime()}"/>
    <input type="hidden" name="/question/author" 
      id="/question/author" value="{xdmp:get-current-user()}"/>
    <br/> <label for="/question/difficulty">Difficulty: </label>
      <input type="text" name="/question/difficulty" 
        id="/question/difficulty" size="50"/>
    <br/> <label for="/question/topic">Topic:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </label>
      <input type="text" name="/question/topic" 
        id="/question/topic" size="50"/>
    <br/><br/> <label for="/question/text">Question</label><br/>
    &nbsp;&nbsp;&nbsp; <textarea name="/question/text" id="/question/text" 
      rows="2" cols="50">
    Question goes here </textarea>
  <br/>
  { (: using the generate option function button to generate four fields :)
    for $o in ('a','b','c','d') return local:generate-option( $o ) }
  <br/><br/><input type="submit" name="submit" id="submit" value="Submit"/>
   </form> } ;

(: this function will process the insert and display the result
 : for now it simply shows the tree that was generated from the HTML form
 :)
declare function local:display-insert() {
  xdmp:quote( mvc:tree-from-request-fields() ) } ;

(: Now we set the content type to text html so the browser renders
 : the page as HTML as opposed to XML :)
xdmp:set-response-content-type("text/html"),
<html>
  <head>
    <title>New Question</title>
  </head>
  <body> {
  (: if it's a post then the user submited the form :)   
  if( xdmp:get-request-method() = "POST" )
  then local:display-insert()
  else
    (: the user wants to create a new question :)
    local:display-form() }
  </body>
</html>
