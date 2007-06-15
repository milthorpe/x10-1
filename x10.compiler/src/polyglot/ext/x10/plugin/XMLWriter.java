package polyglot.ext.x10.plugin;

import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintStream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;

import polyglot.util.InternalCompilerError;

public class XMLWriter {
	
	FileOutputStream w;

	public XMLWriter(String name) throws IOException {
		super();
		w = new FileOutputStream(name);
	}

	public void writeElement(Element n) throws IOException {
		DOMSource source = new DOMSource(n);
		TransformerFactory transFactory = TransformerFactory.newInstance();
		try {
			Transformer format = transFactory.newTransformer();
			format.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
			format.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			format.setOutputProperty(OutputKeys.INDENT, "yes");
			format.transform(source, new StreamResult(w));
		}
		catch (TransformerException e) {
			throw new InternalCompilerError("Error in serializing data to stream");
		}
	}
	
	public void close() throws IOException {
		w.close();
	}

}
