package com.exitapplication.lib;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import com.exitapplication.TexasExtension;
import com.exitapplication.lib.signal.Signal;

public class URLLoader1 {
	public Signal signalComplete = new Signal();
	public Signal signalError = new Signal();
	
	 public void load(String url){
        URL oracle;
		try {
			oracle = new URL(url);
		
			BufferedReader in;
			in = new BufferedReader(
			new InputStreamReader(oracle.openStream()));

	        String inputLine;
	        while ((inputLine = in.readLine()) != null){
	        	inputLine += inputLine;
	        }
	        in.close();
	        
	        signalComplete.dispatch(inputLine);
		} catch (IOException e) {
			signalError.dispatch( " [message="+e.getMessage()+" | cause="+e.getMessage()+"]");
		}
		
		
		
		
		/*try{
			URL url1;
		    URLConnection   urlConn;
		    DataOutputStream    printout;
		    DataInputStream input;

		    url1 = new URL (url);

		    // URL connection channel.
		    urlConn = url1.openConnection();

		    // Let the run-time system (RTS) know that we want input.
		    urlConn.setDoInput (true);

		    // Let the RTS know that we want to do output.
		    urlConn.setDoOutput (true);

		    // No caching, we want the real thing.
		    urlConn.setUseCaches (false);

		    // Specify the content type.
		    urlConn.setRequestProperty
		    ("Content-Type", "application/x-www-form-urlencoded");

		    // Send POST output.
		    printout = new DataOutputStream (urlConn.getOutputStream ());

		    String content =
		    "txtLevelName=" + "level1" +
		    "&txtLevelData=" + "abcd";

		    printout.writeBytes (content);
		    printout.flush ();
		    printout.close ();

		    // Get response data.
		    input = new DataInputStream (urlConn.getInputStream ());

		    
		    String str;
		    while (null != ((str = input.readLine())))
		    {
		    	System.out.println (str);
		    }

		    input.close ();

		    }
		catch (MalformedURLException me)
		    {
		    System.err.println("MalformedURLException: " + me);
		    }
		catch (IOException ioe)
		    {
		    System.err.println("IOException: " + ioe.getMessage());
		    }*/
		
		
		
		
		
		
		/*try {
			String urlParameters = "param1=a&param2=b&param3=c";
			String request = "http://example.com/index.php";
			HttpURLConnection connection;
				connection = (HttpURLConnection) new URL(request).openConnection();
			 
			connection.setDoOutput(true);
			connection.setDoInput(true);
			connection.setInstanceFollowRedirects(false); 
			connection.setRequestMethod("POST"); 
			connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded"); 
			connection.setRequestProperty("charset", "utf-8");
			connection.setRequestProperty("Content-Length", "" + Integer.toString(urlParameters.getBytes().length));
			connection.setUseCaches (false);
	
			DataOutputStream wr = new DataOutputStream(connection.getOutputStream ());
			wr.writeBytes(urlParameters);
			wr.flush();
			wr.close();
			connection.disconnect();
		
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}          */
    }
	 
	 
	 public void load2(String urlString , TexasExtension main)
	 {
		 String urlParameters = "action_option=getCard&token=1&fbid=1&name=[\"eknimation\",\"akekapon\",\"ake\"]";

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
		   main.trace(" 2loaded:"+ response.toString() );
		 }catch (Exception ioe)
		 {
			 main.trace(" 2 error:"+ ioe.getMessage() );
		 }
	 }
}
