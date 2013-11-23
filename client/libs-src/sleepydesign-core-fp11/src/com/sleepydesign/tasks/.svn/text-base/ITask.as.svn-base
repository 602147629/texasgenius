package com.sleepydesign.tasks
{
	import org.osflash.signals.Signal;

	public interface ITask
	{
		function get index():int;
		
		function get completeSignal():Signal;

		function whenRun(task:ITask):void;
		function run():void;
		function get isStarted():Boolean;

		function complete():void;
		function get isCompleted():Boolean;

		function cancel():void;
		function get isCanceled():Boolean;

		function remove():void;
		function get isRemoved():Boolean;

		function reset():void;
	}
}
