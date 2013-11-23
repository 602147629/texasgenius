package EXIT
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author EXIT
	 */
	public class SetPropByMouse extends MovieClip
	{
		var lastMouseX:Number = new Number();
		var thisPath:MovieClip;
		var stepArray:Array = new Array();
		var nowStep:int = -1;
		var oldValue:Number;
		var directionAhead:Boolean = true;
		//--------------------------- createTextField -------------------------------------------------------
		var label1:TextField = createTextField(0, 20, 200, 20, TextFieldType.DYNAMIC, "variable :: ");
		var var1:TextField = createTextField(label1.width, 20, 200, 20,TextFieldType.INPUT,"mc1");
		/*label1.setSelection(0, 9);
		label1.alwaysShowSelection = true;*/
		var label2:TextField = createTextField(0, label1.height+label1.y, 200, 20,TextFieldType.DYNAMIC,"property :: ");
		var var2:TextField = createTextField(label2.width, label1.height + label1.y, 200, 20, TextFieldType.INPUT, "x");

		var label3:TextField = createTextField(0, label2.height + label2.y, 200, 20, TextFieldType.DYNAMIC, "value :: ");
		//-------------------------------------------------------------------------------------------------------
		public function SetPropByMouse(_thisPath)
		{
			thisPath = _thisPath;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event) {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		}
		private function keyDown(e:KeyboardEvent) {
			if(e.ctrlKey){
				if (e.keyCode == 90 && nowStep > 0) {//ctrl+z
					if (directionAhead && nowStep < stepArray.length) {
						trace('ctrlZ  :::   directionAhead='+directionAhead+'  nowStep from ' + nowStep + ' to ' + nowStep+'        stepArray.length = '+stepArray.length);
						directionAhead = false;
						thisPath[stepArray[ nowStep].variable ][ stepArray[nowStep].property ] = stepArray[nowStep].oldValue;
						label3.text = (stepArray[ nowStep].variable + '.' + stepArray[nowStep].property + ' = ' + stepArray[nowStep].oldValue);
					}else if (!directionAhead) {
						trace('ctrlZ  :::   directionAhead='+directionAhead+'  nowStep from ' + nowStep + ' to ' + (nowStep-1)+'        stepArray.length = '+stepArray.length);
						nowStep--;
						thisPath[stepArray[ nowStep].variable ][ stepArray[nowStep].property ] = stepArray[nowStep].oldValue;
						label3.text = (stepArray[ nowStep].variable + '.' + stepArray[nowStep].property + ' = ' + stepArray[nowStep].oldValue);
					}
				}else if (e.keyCode == 89 ) {//ctrl+y
					if (!directionAhead && nowStep < stepArray.length) {
						trace('ctrlY   directionAhead='+directionAhead+'  nowStep from ' + nowStep + ' to ' + nowStep+ '        stepArray.length = ' + stepArray.length);
						directionAhead = true;
						thisPath[stepArray[ nowStep].variable ][ stepArray[nowStep].property ] = stepArray[nowStep].newValue;
						label3.text = (stepArray[ nowStep].variable + '.' + stepArray[nowStep].property + ' = ' + stepArray[nowStep].newValue);
					}else if(directionAhead && nowStep < (stepArray.length-1)){
						trace('ctrlY   directionAhead='+directionAhead+'  nowStep from ' + nowStep + ' to ' + (nowStep+1)+'        stepArray.length = '+stepArray.length);
						nowStep++;
						thisPath[stepArray[ nowStep].variable ][ stepArray[nowStep].property ] = stepArray[nowStep].newValue;
						label3.text = (stepArray[ nowStep].variable + '.' + stepArray[nowStep].property + ' = ' + stepArray[nowStep].newValue);
					}
				}
			}
		}

		//---------------------------------------------- MOUSE EVENT ---------------------------------------
		private function mouseDown(e:MouseEvent) {
			if(e.altKey){
				oldValue = thisPath[var1.text][var2.text];
				trace('******************SetPropByMouse.mouseDown**********************  oldValue ::: '+var1.text + '.' + var2.text + ' = ' + thisPath[var1.text][var2.text]);
				lastMouseX = stage.mouseX;
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			}
		}
		private function mouseUp(e:MouseEvent) {
			if(e.altKey){
				if (thisPath[var1.text][var2.text] != oldValue) {
					if (directionAhead && nowStep < (stepArray.length-1)) {
						trace('splice directionAhead');
						stepArray.splice(nowStep , stepArray.length);
					}else if(!directionAhead && nowStep < stepArray.length){
						trace('splice directionAhead');
						stepArray.splice((nowStep-1) , stepArray.length);
					}
					trace(nowStep + ' : ' + stepArray.length);
					nowStep++;
					directionAhead = true;
					stepArray.push( { variable:var1.text, property:var2.text, newValue:thisPath[var1.text][var2.text], oldValue:oldValue } );
					trace(stepArray[nowStep].variable + '.' + stepArray[nowStep].property + '=' + stepArray[nowStep].newValue+'  from'+stepArray[nowStep].oldValue);
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
					trace('mouseUped ::    nowStep=' + nowStep + ' : stepArray.length=' + stepArray.length);
				}
			}
		}
		private function mouseMove(e:MouseEvent) {
			thisPath[var1.text][var2.text] += stage.mouseX - lastMouseX;
			label3.text = (var1.text + '.' + var2.text + ' = ' + thisPath[var1.text][var2.text]);
			lastMouseX = stage.mouseX;
		}

		//----------------------------------------------- TEXT FIELD ------------------------------------------
		private function createTextField(x:Number, y:Number, width:Number, height:Number,type,text:String):TextField {
			var result:TextField = new TextField();
			result.x = x, result.y = y, result.width = width, result.height = height,result.type = type,result.text = text;
			result.autoSize =  TextFieldAutoSize.LEFT;
			if (type == 'input'){
				result.border = true;
				result.borderColor = 0x999999;
				//result.addEventListener(Event.CHANGE, getProp);
			}else
			result.selectable = false;
			addChild(result);
			return result;
		}
	}

}

