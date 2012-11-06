/*
 * generated by Xtext
 */
package mddProject.concreteSyntax.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import jdsl.ContentModel
import jdsl.NamedElement
import jdsl.CMS
import jdsl.ContentType
import java.util.ArrayList
import jdsl.Property
class JDSLGenerator implements IGenerator {

	//No freaking idea, what I'm doing. An attempt at Hello Gunn's World ;)
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		val model = resource.contents.head as ContentModel
		var ArrayList<CMS> cmsList = new ArrayList<CMS>
		var ArrayList<ContentType> contentList = new ArrayList<ContentType>
		
		if(!model.hasElements.empty)
		{
			for (NamedElement c : model.hasElements)
			{
			
				try
				{
					switch c
					{
						CMS : cmsList.add(c as CMS)
						ContentType : contentList.add(c as ContentType)	
					}	
				}
				catch(Exception e)	
				{}	 	
			}
			
			for(CMS cms : cmsList)
			{
				
					for(ContentType ct : contentList)
					{
						switch cms.type
						{
							case cms.type.toString.equals("Jease") : toJease(ct, fsa)
							case cms.type.toString.equals("N2") : toN2Class(ct,fsa )
							case cms.type.toString.equals("Concrete5") : toConcrete5(ct,fsa)
							case cms.type.toString.equals("Plone") : toPlone(ct,fsa)
						}
					}
			}
		}
	 
	}
	
		def className(Resource res) {
		var name = res.URI.lastSegment
		return name.substring(0, name.indexOf('.'))
	}
	
	
	def toJease(ContentType ct,IFileSystemAccess fsa)
	{
		fsa.generateFile(ct.name.toFirstUpper + ".java", toJeaseDomainClass(ct))
	    fsa.generateFile(ct.name.toFirstUpper +"Editor"+".java", toJeaseEditorClass(ct))
		fsa.generateFile(ct.name.toFirstUpper +".jsp", toJeaseJSP(ct))
	    fsa.generateFile(ct.name.toFirstUpper +".xml", toJeaseXML(ct))
	
	}
	def toJeaseDomainClass(ContentType ct)
	'''
	import java.util.Date;
	import jease.cms.domain.Content;

	public class �ct.name.toFirstUpper� extends Content {

	
	�FOR p : ct.hasProperties�
				�
				p.toJeasePropertyField
				
				�
			�ENDFOR�

	�FOR p : ct.hasProperties�
				�p.toJeaseProperty�
			�ENDFOR�

	public StringBuilder getFulltext() {
	return super.getFulltext().append("\n")
		�FOR p : ct.hasProperties�
				.append(�p.name.toLowerCase�).append("\n")
			�ENDFOR�
	.append("");
	}

	public void replace(String target, String replacement) {
	super.replace(target, replacement);
	�FOR p : ct.hasProperties�
	�switch p.type
	{
		case p.type.toString.toLowerCase.equals("string") : p.insertStringReplacement
	}
	�
			�ENDFOR�
		}

	public �ct.name.toFirstUpper� copy(boolean recursive) {
	�ct.name.toFirstUpper� �ct.name.toLowerCase� = (�ct.name.toString.toFirstUpper�)super.copy(recursive);
		�FOR p : ct.hasProperties�
						�ct.name.toLowerCase�.set�p.name.toString.toFirstUpper�(get�p.name.toString.toFirstUpper�());
			�ENDFOR�

	return �ct.name�;
	}
	}
	'''
	def insertStringReplacement(Property p)
	'''
		set�p.name.toFirstUpper�(get�p.name.toString.toFirstUpper�().replace(target, replacement));
	'''

	def toJeaseProperty(Property p)
		'''
	   public �p.determineJeasePropertyType� get�p.name.toString.toString.toFirstUpper�() {
	   return �p.name.toString.toLowerCase�;
	   }

	   public void set�p.name.toString.toFirstUpper�(�p.determineJeasePropertyType� �p.name.toString.toLowerCase�
	   ) {
	   this.�p.name.toString.toLowerCase� = �p.name.toString.toLowerCase�;
	   }
	'''
	
	def toJeasePropertyField(Property p)
	'''
	�p.accessModifer.literal.toString.toLowerCase� �p.determineJeasePropertyType� �p.name.toString.toLowerCase�;
	'''
	
    def determineJeasePropertyType(Property p)
	'''
	�
	switch p.type.literal
	{
	case p.type.literal.equals("string") : toJeasePropertyCaseString(p)
	case p.type.literal.equals("date") : toJeasePropertyCaseDate(p)
	default : toJeasePropertyFieldNormal(p)
	}
	�	
	'''
	
	def toJeasePropertyCaseString(Property p)
	'''String'''
	
	def toJeasePropertyCaseDate(Property p)
	'''Date'''
	
	def toJeasePropertyFieldNormal(Property p)
	'''�p.type.literal.toString.toLowerCase�'''
	
	
	def toJeaseEditorClass(ContentType ct)
    '''
import jease.cms.web.content.editor.ContentEditor;
import jfix.zk.Datetimefield;
import jfix.zk.RichTextarea;
import jfix.zk.Textfield;

public class �ct.name.toString.toFirstUpper�Editor extends ContentEditor<�ct.name.toString.toFirstUpper�> {

 	�FOR p : ct.hasProperties�
 	�if(p.type.literal.equals("date"))
 	{
 	 insertDateField(p) 	
 	}
 	else
 	{
 		insertNonDateField(p)
 	}
 	 � 					
			�ENDFOR�

 public �ct.name.toString.toFirstUpper�Editor() {
 }

 public void init() {
   	�FOR p : ct.hasProperties�
   	add("�p.name.toFirstUpper�", �p.name.toLowerCase�);
			�ENDFOR�

 }

 public void load() {
 	
 	�FOR p : ct.hasProperties�
 	�if(p.type.literal.toLowerCase.equals("date"))
 	{
 	 setDate(p) 	
 	}
 	else
 	{
 		setText(p)
 	}
 	 � 					
			�ENDFOR�
 }

 public void validate() {
 	 	�FOR p : ct.hasProperties�
 	 	validate(�p.name.toLowerCase�.isEmpty(), "�p.name.toString.toFirstUpper� required");				
			�ENDFOR�
 }

 public void save() {
  	�FOR p : ct.hasProperties�
 	�
 	switch p.type.literal
 	{
 		case p.type.literal.toLowerCase.equals("date") : getDate(p) 
 		case p.type.literal.toLowerCase.equals("string") : getText(p)
 		case p.type.literal.toLowerCase.equals("int") : getInt(p)
 		case p.type.literal.toLowerCase.equals("float") : getFloat(p)
 		case p.type.literal.toLowerCase.equals("double") : getDouble(p)
 	}
 	 � 					
			�ENDFOR�
 }
 }
	'''
	
	def getInt(Property p)
	'''
		  getNode().set�p.name.toString.toFirstUpper�(parseInt(�p.name.toLowerCase�.getText()));
	'''
	
	def getFloat(Property p)
	'''
		  getNode().set�p.name.toString.toFirstUpper�(parseFloat(�p.name.toLowerCase�.getText());
	'''
	def getDouble(Property p)
	'''
		  getNode().set�p.name.toString.toFirstUpper�(parseDouble(�p.name.toLowerCase�.getText());
	'''
	
	def getDate(Property p)
	'''
		  getNode().set�p.name.toString.toFirstUpper�(�p.name.toLowerCase�.getDate());
	'''
	
	def getText(Property p)
	'''
	  getNode().set�p.name.toString.toFirstUpper�(�p.name.toLowerCase�.getText());
	'''
	
	def setDate(Property p)
	'''
	  	�p.name.toLowerCase�.setDate(getNode().get�p.name.toFirstUpper�());
	'''
	
	def setText(Property p)
	'''
	  �p.name.toLowerCase�.setText(getNode().get�p.name.toFirstUpper�());
	'''
	
	def insertDateField(Property p)
	'''
	Datetimefield �p.name.toLowerCase� = new Datetimefield();
	'''
	
	def insertNonDateField(Property p)
	'''
	 Textfield �p.name.toLowerCase�  = new Textfield();
	'''
	
	def getDateView(ContentType ct, Property p)
	'''
	<tr>
	<td><b>�p.name.toFirstUpper�:</b></td>
	<td><%=String.format("%1$tF %1$tR",
                  �ct.name.toLowerCase�.get�p.name.toString.toFirstUpper�())%></td>
	</tr>
	'''
	
	def getTextView(ContentType ct, Property p)
	'''
	 <tr>
	 <td><b>�p.name.toFirstUpper�:</b></td>
	 <td><%=�ct.name.toLowerCase�.get�p.name.toString.toFirstUpper�()%></td>
	 </tr>
	'''
	
	def toJeaseJSP(ContentType ct)
    '''
<%@page import="�ct.name.toString.toFirstUpper�"%>
<%
 �ct.name.toString.toFirstUpper� �ct.name.toLowerCase� = (�ct.name.toString.toFirstUpper�)request.getAttribute("Node");
%>
<h1><%=�ct.name.toLowerCase�.getTitle()%></h1>
<table>
	�FOR p : ct.hasProperties�
 	�if(p.type.literal.equals("date"))
 	{
 	  getDateView(ct, p) 	
 	}
 	else
 	{
 		getTextView(ct, p)
 	}
 	 � 					
			�ENDFOR�
</table>

	'''
	//Done
	def toJeaseXML(ContentType ct)
    '''
    <jease>
    <component>
    		<domain>�ct.name.toString.toFirstUpper�</domain>
    		<editor>�ct.name.toString.toFirstUpper�Editor</editor>
    		<icon></icon>
    		<view>�ct.name.toString.toFirstUpper�.jsp</view>
    </component>
    </jease>
	'''
	
	def toN2Class(ContentType ct,IFileSystemAccess fsa)
	{
				fsa.generateFile(ct.name.toFirstUpper + ".cs", toN2ClassFile(ct))
	    		fsa.generateFile("default" +".aspx.cs", toN2CodeBehindFile(ct))
				fsa.generateFile("default" +".aspx", toN2AspxFile(ct))
	}
	
	def toN2ClassFile(ContentType ct)
	'''
	namespace MySite.Items
	{
		[N2.Details.WithEditableTitle("�ct.name.toFirstUpper�",10)]
		public class �ct.name.toFirstUpper� : N2.ContentItem
		{
			
		�FOR p : ct.hasProperties�
				�
				p.toN2PropertyField
				�
			�ENDFOR�
			
			�FOR p : ct.hasProperties�
				�
				p.toN2Property
				�
			�ENDFOR�
	}
	'''
	
	def toN2PropertyField(Property p)
	'''
	�p.accessModifer.literal.toString.toLowerCase� �p.determineN2PropertyType� �p.name.toString.toLowerCase�;
	'''
	
	def toN2Property(Property p)
	'''
		�
		switch p.type
		{
			case p.type.literal.toLowerCase.equals("string") : p.toN2PropertyString
		    case p.type.literal.toLowerCase.equals("date") : p.toN2PropertyDateTime
		    default:  p.toN2PropertyNormal
		}
		
		�
	'''
	
	def toN2PropertyString(Property p)
	'''
		[N2.Details.EditableTextBox("�p.name.toString.toUpperCase�",20)]
			[N2.Web.UI.EditorModifier("TextMode", TextBoxMode.MultiLine)]
			public String �p.name.toString.toLowerCase�
			{
				get {return this.�p.name.toString.toLowerCase�;}
				set {this.�p.name.toString.toLowerCase� = value;}
			}
	'''
	def toN2PropertyDateTime(Property p)
	'''
		[N2.Details.Editable("�p.name.toString.toUpperCase�", typeof(SelectedDate), "SelectedDate", 20)]
			public DateTime �p.name.toString.toLowerCase�
			{
				get {return this.�p.name.toString.toLowerCase�;}
				set {this.�p.name.toString.toLowerCase� = value;}
			}
	'''
	
	def toN2PropertyNormal(Property p)
	'''
		[N2.Details.EditableTextBox("�p.name.toString.toUpperCase�",20)]
			public String �p.name.toString.toLowerCase�
			{
				get {return this.�p.name.toString.toLowerCase�;}
				set {this.�p.name.toString.toLowerCase� = value;}
			}
	'''
	
	def toN2CodeBehindFile(ContentType ct)
	'''
	using System.Web.Security;
	using System.Web.UI;
	using System.Web.UI.WebControls;
	using System.Web.UI.WebControls.WebParts;
	using System.Web.UI.HTMLControls;
	
	namespace MySite
	{
		public partial class _Default : N2.Web.UI.Page<Items.�ct.name.toFirstUpper�>
		{
			protected void Page_Load(object sender, EventArgs e)	
		}
	}
	'''
	
	
	def toN2AspxFile(ContentType ct)
	'''
	<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <h1><%= CurrentPage.Title %></h1>
    		�FOR p : ct.hasProperties�
				�
				p.toN2PropertyAspx
				�
			�ENDFOR�
    </div>
    </form>
</body>
</html>
	
	'''
	
	def toN2PropertyAspx(Property p)
	'''
	 <n2: Display PropertyName="�p.name.toUpperCase�" runat="server" />
	'''
	def determineN2PropertyType(Property p)
	'''
	�	
	switch p.type.literal
	{
	case p.type.literal.equals("string") : toN2PropertyCaseString(p)
	case p.type.literal.equals("date") : toN2PropertyCaseDate(p)
	default : toJeasePropertyFieldNormal(p)
	}
	�	
	'''
	
	def toN2PropertyCaseString(Property p)
	'''String'''
	
	def toN2PropertyCaseDate(Property p)
	'''DateTime'''
	
	def toN2PropertyFieldNormal(Property p)
	'''�p.type.literal.toString.toLowerCase�'''
	
	
	def toConcrete5(ContentType ct,IFileSystemAccess fsa)
	{
		fsa.generateFile("view.php", toViewConcrete5())
	    fsa.generateFile("add.php", toAddConcrete5(ct))
		fsa.generateFile("controller.php", toControllerConcrete5(ct))
		fsa.generateFile("edit.php", toEditConcrete5(ct))
		fsa.generateFile("db.xml", toDBConcrete5(ct))
	}
	
	def toViewConcrete5()
	'''<?php echo $content?>'''
	
	def toControllerConcrete5(ContentType ct)
	'''
	<?php
	class �ct.name.toUpperCase�BlockController extends BlockController {
		
		var $pobj;
		
		protected $btDescription = "Block for " �ct.name.toFirstUpper�;
		protected $btName = "�ct.name.toFirstUpper�";
		protected $btTable = 'bt�ct.name.toFirstUpper�';
		protected $btInterfaceWidth = "350";
		protected $btInterfaceHeight = "300";
		
		
	}
	
?>
	'''
	
	def toDBConcrete5(ContentType ct)
	'''
	<?xml version="1.0"?>
<schema version="0.3">
	<table name="bt�ct.name.toUpperCase�">
		<field name="bID" type="I">
			<key />
			<unsigned />
			</field>
				�FOR p : ct.hasProperties�
				�
				p.toConcrete5DBProperty
				�
			�ENDFOR�
	</table>
</schema>
	'''
	
	
	def toAddConcrete5(ContentType ct)
	'''
<p>This is the Add template for �ct.name.toFirstUpper�</p>
		�FOR p : ct.hasProperties�
				�
				p.toConcrete5DBProperty
				�
			�ENDFOR�
	'''
	
	def toEditConcrete5(ContentType ct)
	'''
	<p>This is the edit template for �ct.name.toFirstUpper�</p>

		�FOR p : ct.hasProperties�
				�
				p.toConcrete5DBProperty
				�
			�ENDFOR�
	'''
	def toConcrete5DBProperty(Property p)
	 //Need somekind of switch for data types.
	 // X2 means Longtext type.
	 // The schema is in AXMLS 
	'''
		<field name="�p.name.toFirstLower�" type="X2">
		</field>
	'''
	
	def toConcrete5AddForm(Property p)
	'''
	<?php echo $form->label('�p.name.toFirstLower�', '�p.name.toFirstUpper�');?>
<?php echo $form->text('�p.name.toFirstLower�', array('style' => 'width: 320px'));?>
	'''
	
		def toConcrete5EditForm(Property p)
		//Not sure about the $content parameter. Need to do more testing.
	'''
	<?php echo $form->label('�p.name.toFirstLower�', '�p.name.toFirstUpper�');?>
	<?php echo $form->text('�p.name.toFirstLower�', $content, array('style' => 'width: 320px'));?>
	'''



	def toPlone(ContentType ct,IFileSystemAccess fsa)
	{
			fsa.generateFile("ErrorLogJDSL.txt", "An error has been encountered. Error code 1: The CMS is currently not supported in Code generator. ")
	}
}