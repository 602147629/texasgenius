package com.sleepydesign.tasks
{
	import com.sleepydesign.core.IDestroyable;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osflash.signals.Signal;

	public class TaskManager implements IDestroyable
	{
		/*
		TODO : cancel more tasks, remove task by id, return uid via addTask
		*/

		private var _isDestroyed:Boolean;

		private var _tasks:Vector.<ITask> = new Vector.<ITask>();

		public function get tasks():Vector.<ITask>
		{
			return _tasks;
		}

		public function get totalTasks():int
		{
			return _tasks.length;
		}

		private var _timer:Timer;
		private const _FPS:int = 30;

		private var _completeSignal:Signal = new Signal();

		public function get completeSignal():Signal
		{
			return _completeSignal;
		}

		private var _isAsync:Boolean = false;

		public function TaskManager(isAsync:Boolean = false)
		{
			_isAsync = isAsync;
		}

		public function addTask(task:ITask):ITask
		{
			// add to queue
			_tasks.fixed = false;
			_tasks.push(task);
			_tasks.fixed = true;

			// to init state
			task.reset();

			return task;
		}

		public function removeTask(task:ITask):ITask
		{
			if (task.isRemoved)
				return task;

			var i:int = _tasks.indexOf(task);
			var f:uint = 0;

			// remove
			_tasks.fixed = false;
			while (i != -1)
			{
				_tasks.splice(i, 1);
				i = _tasks.indexOf(task, i);
				f++;
			}

			// remove
			task.remove();

			_tasks.fixed = true;

			return task;
		}

		public function cancelTask(task:ITask, isCheckForComplete:Boolean = false):ITask
		{
			removeTask(task);

			task.cancel();

			// destroy if need
			if (task is IDestroyable)
				IDestroyable(task).destroy();

			// fire complete if need
			if (isCheckForComplete && (_tasks.length <= 0))
				completeSignal.dispatch();

			return task;
		}

		public function start():void
		{
			if (!_tasks)
				return;
			else if (_tasks.length <= 0)
			{
				completeSignal.dispatch();
				return;
			}

			var tasks_length:int = _tasks.length;
			const TOTAL_TASKS:int = tasks_length;

			if (!_isAsync)
			{
				var addOnce:Function;
				// make a serial link list eg. [task_0 - complete] -> [task_1 - complete] -> ... -> [task_n - complete]
				while (--tasks_length > 0)
				{
					addOnce = _tasks[int(tasks_length - 1)].completeSignal.addOnce;
					addOnce(_tasks[int(tasks_length)].whenRun);
					addOnce(onTaskComplete);
				}

				// stop at tail node
				_tasks[int(TOTAL_TASKS - 1)].completeSignal.addOnce(onAllTasksComplete);

				// start at head node
				_tasks[0].run();
			}
			else
			{
				// link list as Parallel
				if (_timer)
				{
					_timer.stop();
					_timer = null;
				}

				// do task each frame
				_timer = new Timer((1000 / _FPS));
				_timer.addEventListener(TimerEvent.TIMER, onTimer);

				// link
				tasks_length = _tasks.length;
				while (tasks_length--)
					_tasks[int(tasks_length)].completeSignal.addOnce(onAllTasksComplete);

				// start
				_timer.start();
			}
		}

		private function onTimer(event:TimerEvent):void
		{
			run();
		}

		public function run():void
		{
			if (_tasks.length <= 0)
			{
				stop();
				return;
			}

			var index:int = 0;
			var TASKS_LENGTH:int = _tasks.length;

			while (index < _tasks.length)
				ITask(_tasks[int(index++)]).run();
		}

		private function onTaskComplete(task:ITask):void
		{
			removeTask(task);
			task.completeSignal.dispatch(task);
		}

		private function onAllTasksComplete(task:ITask):void
		{
			removeTask(task);
			
			if (_tasks.length <= 0)
			{
				stop();
				_completeSignal.dispatch();
			}
		}

		public function stop():void
		{
			if (!_tasks)
				return;

			// destroy link list
			var i:int = _tasks.length;
			while (i--)
			{
				IDestroyable(_tasks[int(i)]).destroy();
				_tasks[int(i)] = null;
			}

			// destroy parallel
			if (_timer)
			{
				_timer.stop();
				_timer = null;
			}
		}

		public function get destroyed():Boolean
		{
			return _isDestroyed;
		}

		public function destroy():void
		{
			_isDestroyed = true;

			stop();

			_tasks = null;

			if(_completeSignal)
				_completeSignal.removeAll();
			
			_completeSignal = null;
		}
	}
}
