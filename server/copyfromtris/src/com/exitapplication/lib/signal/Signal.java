package com.exitapplication.lib.signal;

import java.util.ArrayList;


public class Signal {
	
	private ArrayList<SignalEvent> signalEvents = new ArrayList<SignalEvent>();
	
	public void add(SignalEvent signalEvent)
	{
		signalEvents.add(signalEvent);
	}
	
	public void remove(SignalEvent signalEvent)
	{
		signalEvents.remove(signalEvent);
	}
	
	public void removeAll()
	{
		signalEvents.removeAll(signalEvents);
	}
	
	public void dispatch(Object... args)
	{
		for( int i=0 ; i<=signalEvents.size()-1 ; i++ )
		{
			signalEvents.get(i).dispatch(args);
		}
	}
}
