package com.sleepydesign.tasks
{
	import com.sleepydesign.core.IDestroyable;
	
	import org.osflash.signals.Signal;

	public class Task implements ITask, IDestroyable
	{
		protected var _index:int;

		public function get index():int
		{
			return _index;
		}
		
		protected var _isStarted:Boolean;

		public function get isStarted():Boolean
		{
			return _isStarted;
		}

		protected var _isCompleted:Boolean;

		public function get isCompleted():Boolean
		{
			return _isCompleted;
		}

		protected var _isCanceled:Boolean;

		public function get isCanceled():Boolean
		{
			return _isCanceled;
		}

		protected var _isRemoved:Boolean;

		public function get isRemoved():Boolean
		{
			return _isRemoved;
		}

		protected var _command:Function;
		protected var _args:Array;

		protected var _completeSignal:Signal = new Signal(ITask);

		public function get completeSignal():Signal
		{
			return _completeSignal;
		}

		public function Task(command:Function = null, ...args)
		{
			if (command is Function)
				_command = command;
			
			_args = args;
		}

		public function whenRun(task:ITask):void
		{
			run();
		}
		
		public function run():void
		{
			if (_isStarted || _isCompleted || _isCanceled)
				return;

			_isStarted = true;
			
			if (_command is Function)
				_command.apply(this, _args);
		}

		public function complete():void
		{
			_isCompleted = true;

			_completeSignal.dispatch(this);
		}

		public function cancel():void
		{
			_isCanceled = true;

			if (_completeSignal)
				_completeSignal.removeAll();
		}

		public function remove():void
		{
			_isRemoved = true;
		}

		public function reset():void
		{
			_isStarted = _isCompleted = _isRemoved = false;
		}
		
		protected var _isDestroyed:Boolean;
		
		public function get destroyed():Boolean
		{
			return _isDestroyed;
		}
		
		public function destroy():void
		{
			_isDestroyed = true;
			
			cancel();
			remove();
		}
	}
}
