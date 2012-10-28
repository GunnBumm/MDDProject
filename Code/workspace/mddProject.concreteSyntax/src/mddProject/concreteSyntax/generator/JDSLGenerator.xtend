/*
 * generated by Xtext
 */
package mddProject.concreteSyntax.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import jdsl.ContentModel
import jdsl.CMSEnum
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
		fsa.generateFile(ct.name + ".java", toJeaseDomainClass(ct))
	    fsa.generateFile(ct.name +"Editor"+".java", toJeaseEditorClass(ct))
		fsa.generateFile(ct.name +".jsp", toJeaseJSP(ct))
	    fsa.generateFile(ct.name +".xml", toJeaseXML(ct))
	
	}
	def toJeaseDomainClass(ContentType ct)
	'''
	import java.util.Date;
	import jease.cms.domain.Content;

	public class �ct.name.toUpperCase� extends Content {

	private String topic;
	private String location;
	private Date start;
	private Date stop;

	public String getTopic() {
	return topic;
	}

	public void setTopic(String topic) {
	this.topic = topic;
	}

	public String getLocation() {
	return location;
	}

	public void setLocation(String location) {
	this.location = location;
	}

	public Date getStart() {
	return start;
	}

	public void setStart(Date start) {
	this.start = start;
	}

	public Date getStop() {
	return stop;
	}

	public void setStop(Date stop) {
	this.stop = stop;
	}

	public StringBuilder getFulltext() {
	return super.getFulltext().append("\n")
	.append(topic).append("\n")
	.append(location);
	}

	public void replace(String target, String replacement) {
	super.replace(target, replacement);
	setTopic(getTopic().replace(target, replacement));
	setLocation(getLocation().replace(target, replacement));
	}

	public �ct.name.toUpperCase� copy(boolean recursive) {
	�ct.name.toUpperCase� �ct.name� = (�ct.name.toUpperCase�) super.copy(recursive);
	meeting.setTopic(getTopic());
	meeting.setLocation(getLocation());
	meeting.setStart(getStart());
	meeting.setStop(getStop());
	return �ct.name�;
	}
	}
	� �
	'''
	
	def toJeaseProperty(Property p)
	'''
	
	'''
	
    def toJeasePropertyField(Property p)
	'''
	
	'''
	
	def toJeaseEditorClass(ContentType ct)
    '''
	
	import jease.cms.web.content.editor.ContentEditor;
	import jfix.zk.Datetimefield;
	import jfix.zk.RichTextarea;
	import jfix.zk.Textfield;
	
	'''
	
	def toJeaseJSP(ContentType ct)
    '''
	
	'''
	
	def toJeaseXML(ContentType ct)
    '''
    <jease>
    <component>
    		<domain>�ct.name.toUpperCase�</domain>
    		<editor>�ct.name.toUpperCase�Editor</editor>
    		<icon></icon>
    		<view>/custom/�ct.name.toUpperCase�.jsp</view>
    </component>
    </jease>
	'''
	
	def toN2Class(ContentType ctm,IFileSystemAccess fsa)
	{
		//Note that N2 combines domain class and editor into one class file thanks to C# attributes. 
	}
	
	def toConcrete5(ContentType ct,IFileSystemAccess fsa)
	{
		//Call to Create Controller.php
		//Call to Create Edit.php
		//Call to Create add.php
		//Call to whatever we are missing.
	}
	
	def toPlone(ContentType ct,IFileSystemAccess fsa)
	{
		//Louis was here: Checking push.
	}
}