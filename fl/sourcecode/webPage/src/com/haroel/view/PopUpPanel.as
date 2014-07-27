package com.haroel.view
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Cubic;
	import com.haroel.events.DDEvent;
	import com.haroel.events.UIEventDispatcher;
	import com.haroel.model.MenuItemVO;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class PopUpPanel
	{
		private var _material:MovieClip;
		
		private var _currentId:int = -1;
		
		public function PopUpPanel()
		{
			super();
			init();
		}
		private function init():void
		{
			
			var cls:Class = App.asset.getClass(ResourceConfig.CLS_MPANEL);
			_material = new cls();
			
			_material.x = (Main.stageWidth - _material.width)/2;
			_material.y = -_material.height;
			_material.addEventListener(Event.REMOVED_FROM_STAGE,removeHandler);
//			_material.blendShader
			function removeHandler(evt:Event):void
			{
				_material.removeEventListener(Event.REMOVED_FROM_STAGE,removeHandler);
				
				UIEventDispatcher.getInstance().dispatchEvent(new DDEvent(DDEvent.POPUPVIEW_REMOVE,null));
			}
//			(SimpleButton)(_material.m_closeBtn).addEventListener(MouseEvent.CLICK,closePanel);
		}
		
		public function playMoveInAction():void
		{
			TweenLite.to(_material, 0.5, {y:0, motionBlur:true, ease:Cubic.easeInOut});
		}
		
		public function playMoveOutAction():void
		{			
			TweenLite.to(_material,0.5,{y:-_material.height,onComplete:removeNode});
			function removeNode():void
			{
				_material.parent.removeChild(_material);
			}
		}
		
		public function set info(value:MenuItemVO):void
		{
			if (_currentId == value.id)
			{
				return;
			}
			_currentId = value.id;
			(TextField)(_material.m_label).text = value.label;
		}
		public function get material():MovieClip
		{
			return _material;
		}

	}
}