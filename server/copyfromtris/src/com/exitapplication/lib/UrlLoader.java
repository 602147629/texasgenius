package com.exitapplication.lib;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;

import com.exitapplication.TexasExtension;
import com.exitapplication.lib.signal.Signal;

public class UrlLoader {
	public Signal signalComplete = new Signal();
	public Signal signalError = new Signal();
	
	private ArrayList<Param> params = new ArrayList<Param>();
	
	public UrlLoader()
	{
	}
	
	public void load(String urlString)
	 {
		String urlParameters = "";
		for( int i=0 ; i<=params.size()-1 ; i++ ){
			urlParameters += params.get(i).name+"="+params.get(i).value;
			if( i!=params.size()-1 ){
				urlParameters+="&";
			}
		}
		
		 params = new ArrayList<Param>();
		 
		 HttpURLConnection connection = null;  
		 try {
		   URL url = new URL(urlString);
		   connection = (HttpURLConnection)url.openConnection();

		   // Use post and add the type of post data as URLENCODED
		   connection.setRequestMethod("POST");
		   connection.setRequestProperty("Content-Type","application/x-www-form-urlencoded");

		   // Optinally add the language and the data content
		   connection.setRequestProperty("Content-Length", "" + Integer.toString(urlParameters.getBytes().length));
		   connection.setRequestProperty("Content-Language", "en-US");  

		   // Set the mode as output and disable cache.
		   connection.setUseCaches (false);
		   connection.setDoInput(true);
		   connection.setDoOutput(true);

		   //Send request
		   DataOutputStream wr = new DataOutputStream (connection.getOutputStream ());
		   wr.writeBytes (urlParameters);
		   wr.flush ();
		   wr.close ();


		   // Get Response    
		   // Optionally you can get the response of php call.
		   InputStream is = connection.getInputStream();
		   BufferedReader rd = new BufferedReader(new InputStreamReader(is));
		   String line;
		   StringBuffer response = new StringBuffer(); 
		   while((line = rd.readLine()) != null) {
		     response.append(line);
		     response.append('\r');
		   }
		   rd.close();
		   signalComplete.dispatch(response.toString());
		 }catch (Exception e)
		 {
			 signalError.dispatch( " [message="+e.getMessage()+" | cause="+e.getMessage()+"]");
		 }
	 }

	public void addParam(String _name , String _value ) 
	{
		params.add(new Param(_name, _value));
	}
	
	private class Param
	{
		public String name;
		public String value;
		public Param(String _name , String _value )
		{
			name = _name;
			value = _value;
		}
	}

	public void dispose() {
		signalComplete.removeAll();
		signalError.removeAll();
	}
}
