package net.area80.debug
{

	import flash.utils.describeType;
	import flash.utils.getTimer;

	public class UnitTest
	{
		protected var tasks:Vector.<Task> = new Vector.<Task>;

		public function UnitTest()
		{
		}

		public function addTask(task:Function, name:String = null, arguments:Array = null):void
		{
			if (!name) {
				var typeXML:XML = describeType(task);
				var type:String = String(typeXML.@name).split("::").join(".");
				name = type;
			}
			tasks.push(new Task(name, task, arguments));
		}

		public function run(times:int = 1, displayLog:Boolean = true):void
		{
			var loopstart:int;
			var length:int = tasks.length;
			var currentTask:Task;
			var stime:int;
			var i:int;

			//clear
			for (i = 0; i < length; i++) {
				tasks[int(i)].times = new Vector.<int>;
			}

			if (displayLog)
				log("start " + times + " times.");
			var runstart:int = getTimer();
			for (var loop:int = 0; loop < times; loop++) {
				for (i = 0; i < length; i++) {
					currentTask = tasks[int(i)];
					stime = getTimer();
					currentTask.run.apply(this, currentTask.args);
					currentTask.times.push(int(getTimer() - stime));
				}
			}
			var end:int = getTimer() - runstart;
			if (displayLog)
				traceLog();
			if (displayLog)
				log("end - " + end + "ms");
		}

		protected function traceLog():void
		{
			for (var i:int = 0; i < tasks.length; i++) {
				logTaskFormat(tasks[i]);
			}
		}

		protected function logTaskFormat(tasks:Task):void
		{
			log(tasks.name + "\t\t\t" + tasks.avgTime + "/" + tasks.totalTimes + "ms");
		}

		protected function log(message:String):void
		{
			trace(message);
		}
	}


}

internal class Task
{
	public var name:String;
	public var run:Function;
	public var args:Array;
	public var times:Vector.<int> = new Vector.<int>;

	public function Task(name:String, task:Function, arguments:Array = null):void
	{
		this.name = name;
		this.run = task;
		this.args = arguments;
	}

	public function get totalTimes():int
	{
		var res:int = 0;
		for (var i:int = 0; i < times.length; i++) {
			res += times[i];
		}
		return res;
	}

	public function get avgTime():int
	{
		return int(totalTimes / loop);
	}

	public function get loop():int
	{

		return times.length;
	}
}


