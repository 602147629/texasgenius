package net.area80.async
{
	public class AsyncTask
	{
		
		public var name:String;
		public var task:Function;
		protected var manager:AsyncTaskManager;
		public var autoRelease:Boolean = false;
		
		public function AsyncTask(manager:AsyncTaskManager, name:String, task:Function, autoRelease:Boolean=true)
		{
			this.name = name;
			this.task = task;
			this.manager = manager;
			this.autoRelease = autoRelease;
		}
		public function run():void {
			task(this);
			if(autoRelease) {
				release();
			}
		}
		public function wait ():void {
			autoRelease = false;	
		}
		protected function next ():void {
			manager.next();
		}
		public function release ():void {
			next();
		}
	}
}