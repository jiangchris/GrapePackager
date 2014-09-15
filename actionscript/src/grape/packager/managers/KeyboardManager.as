package grape.packager.managers
{
import flash.display.Stage;
import flash.events.KeyboardEvent;

import mx.core.InteractionMode;

public class KeyboardManager
	{
		protected static var mStage:Stage = null;
		protected static var EventList:Array = null;
		
		public static const UP:int = 38;
		public static const DOWN:int = 40;
		public static const LEFT:int = 37;
		public static const RIGHT:int = 39;
		public static const A:int = 65;
		public static const D:int = 68;
		public static const W:int = 87;
		public static const S:int = 83;
		public static const Z:int = 90;
		public static const X:int = 88;
		public static const C:int = 67;
		public static const V:int = 86;
		public static const N:int = 78;
		public static const P:int = 80;
		public static const Q:int = 81;
		public static const B:int = 66;
		
		public static const F2:int = 113;
		public static const ESC:int = 27;
		public static const DEL:int = 46;

        public static const ENTER:int = 13;
        public static const TAB:int = 9;
		
		protected static var mIsEnabled:Boolean = true;
		public function KeyboardManager(){}
		
		public static function Init(stg:Stage):void{
            mStage = stg;
            mStage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyEvent);
            mStage.addEventListener(KeyboardEvent.KEY_UP,onKeyEvent);
			
			EventList = new Array();
		}
		
		protected static function onKeyEvent(event:KeyboardEvent):void{
			if(!mIsEnabled)
				return;
			
			var type:String;
			var key:int;
			var ctrl:Boolean;
			var shift:Boolean;
			
			for(var i:int = 0;i < EventList.length;i++)
			{
				type = EventList[i]["type"];
				key = EventList[i]["key"];
				ctrl = EventList[i]["ctrl"];
				shift = EventList[i]["shift"];
				if(type == event.type && key == event.keyCode && ctrl == event.ctrlKey && shift == event.shiftKey)
				{
					EventList[i]["fun"](event);
				}
			}
		}
		
		public static function Destroy():void{
			EventList = null;
            mStage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyEvent);
            mStage.removeEventListener(KeyboardEvent.KEY_UP,onKeyEvent);
            mStage = null;
		}
		
		public static function get isEnabled():Boolean{return mIsEnabled;}
		public static function set isEnabled(value:Boolean):void{
			if(value != mIsEnabled){
				mIsEnabled = value;
			}
		}
		
		public static function AddKeyEvent(EventType:String,fun:Function,key:int,ctrl:Boolean = false,shift:Boolean = false):void{
			var obj:Object = new Object();
			obj["type"] = EventType;
			obj["fun"] = fun;
			obj["key"] = key;
			obj["ctrl"] = ctrl;
			obj["shift"] = shift;
			EventList.push(obj);
		}
		
		public static function RemoveKeyEvent(EventType:String,fun:Function):void{
			for(var i:int = 0;i < EventList.length;i++){
				if(EventList[i]["fun"] == fun){
					EventList.splice(i,1);
				}
			}
		}
	}
}
