package net.area80.component.composer.transition
{
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	
	/**
	 * InOutTransition
	 * Transition composer for movieclip object, required 3 frame labels
	 * 1. Frame label "in"  
	 * 2. Frame label "standby"
	 * 3. Frame label "out"
	 * 
	 */
	public class InOutTransition extends Transition
	{
		
		public function InOutTransition($skin:MovieClip)
		{
			super($skin);
			initFrame();
		}
		
		protected function get skinAsMovieClip ():MovieClip {
			return skin as MovieClip;
		}
		
		override public function resetToStart():void
		{
			skinAsMovieClip.gotoAndStop(1);
			super.resetToStart();
		}
		
		protected function initFrame ():void {
			var labels:Array = skinAsMovieClip.currentLabels;
			var standByFrame:int = -1;
			var inFrame:int = -1;
			var outFrame:int = -1;
			for(var i:uint =0;i<labels.length;i++) {
				var label:FrameLabel = labels[i] as FrameLabel;
				if(label.name=="standby") standByFrame = label.frame;
				if(label.name=="in") inFrame = label.frame;
				if(label.name=="out") outFrame = label.frame;
			}
			if(standByFrame != -1 && inFrame !=-1 && outFrame != -1) {
				skinAsMovieClip.addFrameScript(standByFrame-1,onTransitionInComplete);
				skinAsMovieClip.addFrameScript(skinAsMovieClip.totalFrames-1,onTransitionOutComplete);
				skinAsMovieClip.gotoAndStop(1);
			} else {
				throw new Error("[InOutTransition] Movieclip content must have 3 frame labels (in, out, standby)");
			}
		}
		
		override protected function onTransitionInComplete():void
		{
			skinAsMovieClip.stop();
			super.onTransitionInComplete();  
		}
		
		override protected function onTransitionOutComplete():void
		{
			skinAsMovieClip.stop();
			super.onTransitionOutComplete();
		}
		
		
		override public function transitionIn():void
		{
			skinAsMovieClip.gotoAndPlay("in");
		}
		
		override public function transitionOut():void
		{
			skinAsMovieClip.gotoAndPlay("out");
		}
		
	}
}