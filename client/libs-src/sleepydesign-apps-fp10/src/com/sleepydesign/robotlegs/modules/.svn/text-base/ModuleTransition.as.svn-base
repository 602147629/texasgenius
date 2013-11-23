package com.sleepydesign.robotlegs.modules
{
	import com.sleepydesign.robotlegs.apps.view.ITransition;
	import com.sleepydesign.robotlegs.apps.view.IView;
	import com.sleepydesign.tasks.ITask;
	import com.sleepydesign.tasks.Task;
	import com.sleepydesign.tasks.TaskManager;

	public class ModuleTransition implements ITransition
	{
		public function start(fromView:IView, toView:IView, onComplete:Function):void
		{
			const taskManager:TaskManager = new TaskManager(true);

			if (fromView)
				var task0:ITask = taskManager.addTask(new Task(function():void
				{
					fromView.deactivate(task0.complete, toView);
				}));

			if (toView)
				var task1:ITask = taskManager.addTask(new Task(function():void
				{
					toView.activate(task1.complete, fromView);
				}));

			taskManager.completeSignal.addOnce(function onTaskManagerComplete():void
			{
				if (onComplete is Function)
					onComplete();
			});

			taskManager.start();
		}
	}
}
